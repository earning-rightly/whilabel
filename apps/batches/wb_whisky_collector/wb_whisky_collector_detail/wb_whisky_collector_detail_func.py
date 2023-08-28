import asyncio
import random
import bs4
from bs4 import BeautifulSoup
import pandas as pd
from webdriver_manager.chrome import ChromeDriverManager
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
from batches.wb_libs import wb_libs_func
import aiohttp.client_exceptions
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service as ChromeService

from apps.batches.wb_whisky_collector.wb_whisky_collector_detail.wb_whisky_collector_detail_values import \
    whisky_collect_detail_scrap as whisky_detail_scrap

async def scrap_whisky_collector_detail(url : str, sema : asyncio.Semaphore, url_index : int):
    """
        scrap_whisky_collector_detail.
            Args:
                url : 수집해야할 홈페이지 링크.
                sema : 비동기식 해당 스레드 위치주소.
                loop :  (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
                url_index : 현재 수집중인 url의 index
            Note:
                수집된 위스키 링크에 대하여 위스키의 각종 정보를 수집하는 함수
            Raises:
               aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결 진행중)
    """

    def extract_information_related_with_whisky(url : str, soup : bs4.BeautifulSoup, url_index : int):
        """
            extract_information_related_brand.
                Args:
                    url : 수집해야할 홈페이지 링크.

                Note:
                    실직적으로 브랜드 상세 정보를 수집하는 함수
                Raises:
                   IndexError : soup을 통해 생성한 title_list, value_list값이 현재 준비해둔 값과 안맞을때 (해결)
        """
        whisky_detail_scrap['link'][url_index] = url
        if soup.select(
                '.col-sm-offset-3.col-sm-6.site-error') != []:  # 해당 위스키 페이지가 사라짐 #ex) : https://www.whiskybase.com/whiskies/whisky/170176/aberfeldy-1996-ca

            pass
        else:  # 위스키 사이트가 active일때
            try:
                whisky_detail_scrap['whisky_name'][url_index] = soup.select('.name header h1')[
                    0].text.strip()  # 위스키 이름 추출
                pass

            except IndexError:
                if soup.text in '503':
                    print('503 error')
                    turn_around_selenum(url=url, url_index=url_index)

            # 위스키별 정보 사이트에선 태그구분(클래스명, 아이디명)등으로 구분없이 dt로 되어있어 딕셔너리를 사용하여 키 매칭하여 해당 값을 리스트에 저장
            dt_list = soup.select('dt')  # 딕셔너리에 대한 key 매칭을 위해 수집
            dd_list = soup.select('dd')  # 캐에대한 value값

            for i in range(len(dt_list)):
                if dt_list[i].text.strip() == 'Overall rating' or dt_list[i].text.strip() == 'votes' or dt_list[
                    i].text.strip() == 'vote':  # 변경필요 == -> !=으로
                    pass
                else:
                    if dt_list[i].text.strip() == 'Distilleries' or dt_list[i].text.strip() == 'Distillery':
                        dis_dict = {}
                        for link in dd_list[i].div:
                            if link.text.strip() != ',':
                                dis_dict[link.text.strip()] = link['href']
                                whisky_detail_scrap["distillery"][url_index] = dis_dict
                    else:

                        whisky_detail_scrap[dt_list[i].text.strip().lower().replace(' ', '_')][url_index] = dd_list[
                            i].text.strip()
            try:
                whisky_detail_scrap['overall_rating'][url_index] = soup.select('dd.votes-rating')[
                    0].text.strip()  # 딕셔너리에 넣지않은이유는 vote투표수가 여러개일때와 한개일때의 dt태그명이 다른점과 같은 데이터가 2번 추출된다든점에서 따로 진행
                whisky_detail_scrap['votes'][url_index] = soup.select('dd.votes-count')[0].text.strip()

            except IndexError:
                if soup.text in '503':
                    print('503 error')
                    turn_around_selenum(url=url, url_index=url_index)
                else:
                    pass
            try:
                if soup.select('.photo')[0]['href'] != 'https://static.whiskybase.com/storage/whiskies/default/big.png?v4':
                    whisky_detail_scrap['photo'][url_index] = soup.select('.photo')[0]['href']

            except IndexError:
                pass
            try:
                whisky_detail_scrap['block_price'][url_index] = soup.select('.block-price')[0].text.strip().split('\n')[
                    1]  # 위스키 가격이 있는경우

            except IndexError:
                # print('block-price miss : ' + url)
                pass
            real_tag_list = []
            tag_list = soup.select('.tag-name')  # 클래스명 이 tag-name 추출
            for tag in tag_list:
                real_tag_list.append(tag.text.strip())
            real_tast_num = []
            tast_list = soup.select('.btn-tastingtag')
            for tast in tast_list:
                real_tast_num.append(tast['data-num'])
            whisky_detail_scrap['tag_name'][url_index] = dictionary = dict(  # tastingtag와 해당 맛에 대한 투표수를 딕셔너리로 만들어 저장
                zip(real_tag_list, real_tast_num))

    async def turn_around_selenum(url : str, url_index : int):
        """
           turn_around_selenum.
               Args:
                   url : 수집해야할 홈페이지 링크.
                   url_index : 수집해야할 홈페이지 번호

               Note:
                   aiohttp.client_exceptions.ClientConnectorError발생시 selenuium으로 동작하기 위해 만든 함수

        """
        await asyncio.sleep(3)
        chrome_options = Options()
        chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
        driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()),options=chrome_options)
        driver.get(url)
        driver.implicitly_wait(3)
        soup = BeautifulSoup(markup=driver.page_source,
                             features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
        extract_information_related_with_whisky(url=url, soup=soup, url_index=url_index)
        driver.close()

    async with sema:
        async with ClientSession(trust_env=True, connector=TCPConnector(ssl=False)) as session:
            await asyncio.sleep(random.randrange(3, 6))  # 세션 차단을 방지하기위한  3 - 6초내외로 난수 딜레이
            try:
                async with session.get(url, ssl=False) as response:
                    r = await response.read()
                    soup = BeautifulSoup(markup=r, features='lxml')
                    extract_information_related_with_whisky(url=url, soup=soup, url_index=url_index)

            except aiohttp.client_exceptions.ClientConnectorError:  # 비동기식 접속으로 443포트에 대한 접속이 안되는 에러에 대한 예외처리
                await turn_around_selenum(url, url_index)


async def extract_whisky_detail_collector_async(link : list):
    """
        extract_whisky_detail_collector_async.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
                loop : (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    semaphore = asyncio.Semaphore(30)  #최대 비동기 갯수 30개 제한
    fts = [asyncio.ensure_future(scrap_whisky_collector_detail(u, semaphore, url_index=url_index)) for url_index, u in
           enumerate(link)]
    await tqdm_asyncio.gather(*fts)


def collect(mode: str, current_date: str):
    """
        collect.
        Args:
                mode : {brand or distillery} mode를 통해 read_csv파일 결정.
                current_date : 사전에 수집된 위스키 링크를 가져오기 위해 날짜 정보 추출
            Note:
                파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    table = pd.read_csv('results/' + current_date + '/csv/link/wb_' + mode + '_whisky_collector_link.csv')
    wb_libs_func.reset_list_size(len(table), whisky_detail_scrap)
    asyncio.run(extract_whisky_detail_collector_async(table.whisky_link))
