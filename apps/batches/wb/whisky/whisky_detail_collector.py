import asyncio
import random
import bs4
from bs4 import BeautifulSoup
import pandas as pd
from webdriver_manager.chrome import ChromeDriverManager
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
import aiohttp.client_exceptions
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service as ChromeService

from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.enums import BatchType


async def scrap_whisky_collector_detail(url: str, sema: asyncio.Semaphore, url_index: int, scrap_dict: dict):
    """
        scrap_whisky_collector_detail.
            Args:
                url : 수집해야할 홈페이지 링크.
                sema : 비동기식 해당 스레드 위치주소.
                url_index : 현재 수집중인 url의 index
                scrap_dict : data
            Note:
                수집된 위스키 링크에 대하여 위스키의 각종 정보를 수집하는 함수
            Raises:
               aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결)
    """

    def extract_information_related_with_whisky():
        """
            extract_information_related_brand.
                Args:
                Note:
                    실직적으로 브랜드 상세 정보를 수집하는 함수
                Raises:
                   IndexError : soup을 통해 생성한 title_list, value_list값이 현재 준비해둔 값과 안맞을때 (해결)
        """
        scrap_dict['link'][url_index] = url

        # 해당 위스키 페이지가 사라짐 -> 함수 반환
        # ex) : https://www.whiskybase.com/whiskies/whisky/170176/aberfeldy-1996-ca
        if soup.select('.col-sm-offset-3.col-sm-6.site-error'):
            return

        try:
            scrap_dict['whisky_name'][url_index] = soup.select('.name header h1')[0].text.strip()  # 위스키 이름 추출
        except IndexError:
            if soup.text in '503':
                print('503 error')
                turn_around_selenium(url=url, idx=url_index)

        # 위스키별 정보 사이트에선 태그구분(클래스명, 아이디명)등으로 구분없이 dt로 되어있어 딕셔너리를 사용하여 키 매칭하여 해당 값을 리스트에 저장
        dt_list = soup.select('dt')  # 딕셔너리에 대한 key 매칭을 위해 수집
        dd_list = soup.select('dd')  # 캐에대한 value값

        for i in range(len(dt_list)):
            if (dt_list[i].text.strip() == 'Overall rating'
                    or dt_list[i].text.strip() == 'votes'
                    or dt_list[i].text.strip() == 'vote'):  # 변경필요 == -> !=으로
                pass
            else:
                if (dt_list[i].text.strip() == 'Distilleries'
                        or dt_list[i].text.strip() == 'Distillery'):
                    dis_dict = {}
                    for link in dd_list[i].div:
                        if link.text.strip() != ',':
                            dis_dict[link.text.strip()] = link['href']
                            scrap_dict["distillery"][url_index] = dis_dict
                else:
                    title = dt_list[i].text.strip().lower().replace(' ', '_')
                    scrap_dict[title][url_index] = dd_list[i].text.strip()

        try:
            # 딕셔너리에 넣지않은이유는 vote투표수가 여러개일때와 한개일때의 dt태그명이 다른점과 같은 데이터가 2번 추출된다든점에서 따로 진행
            scrap_dict['overall_rating'][url_index] = soup.select('dd.votes-rating')[0].text.strip()
            scrap_dict['votes'][url_index] = soup.select('dd.votes-count')[0].text.strip()
        except IndexError:
            if soup.text in '503':
                print('503 error')
                turn_around_selenium(url=url, idx=url_index)
            else:
                pass
        try:
            photo_prefix = 'https://static.whiskybase.com/storage/whiskies/default/big.png?v4'
            if soup.select('.photo')[0]['href'] != photo_prefix:
                scrap_dict['photo'][url_index] = soup.select('.photo')[0]['href']
        except IndexError:
            pass

        try:
            # 위스키 가격이 있는경우
            scrap_dict['block_price'][url_index] = soup.select('.block-price')[0].text.strip().split('\n')[1]
        except IndexError:
            pass

        tag_list = soup.select('.tag-name')  # 클래스명 이 tag-name 추출
        real_tag_list = [tag.text.strip() for tag in tag_list]

        taste_list = soup.select('.btn-tastingtag')
        real_taste_num = [taste['data-num'] for taste in taste_list]

        # tastingtag와 해당 맛에 대한 투표수를 딕셔너리로 만들어 저장
        scrap_dict['tag_name'][url_index] = {k: v for k, v in zip(real_tag_list, real_taste_num)}

    async def turn_around_selenium(url: str, idx: int):
        """
           turn_around_selenum.
               Args:
                   url : 수집해야할 홈페이지 링크.
                   idx : 수집해야할 홈페이지 번호

               Note:
                   aiohttp.client_exceptions.ClientConnectorError발생시 selenuium으로 동작하기 위해 만든 함수

        """
        await asyncio.sleep(3)
        chrome_options = Options()
        chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
        driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=chrome_options)
        driver.get(url)
        driver.implicitly_wait(3)
        soup = BeautifulSoup(markup=driver.page_source,
                             features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
        extract_information_related_with_whisky(url=url, soup=soup, url_index=idx)
        driver.close()

    async with sema:
        async with ClientSession(trust_env=True, connector=TCPConnector(ssl=False)) as session:
            await asyncio.sleep(random.randrange(3, 6))  # 세션 차단을 방지하기위한  15초내외로 난수 딜레이
            try:
                async with session.get(url, ssl=False) as response:
                    r = await response.read()
                    soup = BeautifulSoup(markup=r, features='lxml')
                    extract_information_related_with_whisky()

            except aiohttp.client_exceptions.ClientConnectorError:  # 비동기식 접속으로 443포트에 대한 접속이 안되는 에러에 대한 예외처리
                await turn_around_selenium(url, url_index)


async def run_whisky_detail_collector(link: list, scrap_dict: dict):
    """
        extract_whisky_detail_collector_async.
    """
    smp = asyncio.Semaphore(30)
    fts = [asyncio.ensure_future(scrap_whisky_collector_detail(u, smp, idx, scrap_dict)) for idx, u in enumerate(link)]
    await tqdm_asyncio.gather(*fts)


def collect_whisky_detail(batch_type: BatchType, current_date: str, scrap_dict: dict):
    table = pd.read_csv(f'results/{current_date}/csv/link/{batch_type.value}.csv')
    wb_libs_func.reset_list_size(len(table), scrap_dict)
    asyncio.run(run_whisky_detail_collector(table.whisky_link, scrap_dict))
