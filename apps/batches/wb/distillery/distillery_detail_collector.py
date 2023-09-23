import asyncio
import random
import aiohttp.client_exceptions
import bs4
from bs4 import BeautifulSoup
import pandas as pd
from selenium.webdriver.chrome.service import Service as ChromeService
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
import traceback
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.enums import BatchType


async def extract_distillery_detail(url_index: int, url: str, sema: asyncio.Semaphore, scrap_dict: dict):
    """
        extract_distillery_detail.
            Args:
                url : 수집해야할 홈페이지 링크.
                sema : 비동기식 해당 스레드 위치주소.
                url_index : 수집중인 브랜드 url index 값
            Note:
                증류소 상세정보를 수집하기 위해 비동기식 처리를 위한 함수
            Raises:
               aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결 진행중)
    """

    def extract_title_and_value(sp: bs4.BeautifulSoup, index: int):
        """
            extract_title_and_value.
                Args:
                    sp : 수집해야할 홈페이지 정보.
                    index : 수집해야할 홈페이지 링크 index.
                Note:
                    실직적으로 증류소 상세 정보를 수집하는 함수
                Raises:
                   IndexError : soup을 통해 생성한 title_list, value_list값이 현재 준비해둔 값과 안맞을때 (해결)
        """
        title_list = sp.select('.title')
        value_list = sp.select('.value')

        # 증류소 timeline 수집
        try:
            scrap_dict['company_about'][index] = sp.select('.company-about p span')[0].text.strip()
        except IndexError:  # 증류소 timeline 정보가 없는경우
            pass

        # 증류소 주소 수집
        try:
            scrap_dict['company_address'][index] = sp.select('.company-address')[0].text.strip()
        except IndexError:  # 증류소 주소 정보가 없는경우
            pass

        for i in range(len(title_list)):
            try:
                # title_list 값이 Specialists인경우엔 Specialist가 복수개인경우가 있어 딕셔너리로 저장
                if title_list[i].text.strip() == 'Specialists':
                    specialists_dict = {}
                    for avatar in sp.select('.specialists li'):
                        specialists_dict[avatar.a.text.strip()] = avatar.a['href']
                        scrap_dict['specialists'][index] = specialists_dict
                else:
                    # 나머지 title_list에사 소문자로 변경 및 빈칸을 '_'로
                    # 채운후 detail_scrap의 키와 비교하여 순서에 맞게 저장
                    title = title_list[i].text.strip().lower().replace(__old=' ', __new='_')
                    scrap_dict[title][index] = value_list[i].text.strip()
            except Exception:
                pass

    async with sema:
        async with ClientSession(
                trust_env=True,
                connector=TCPConnector(ssl=False)
        ) as session:
            await asyncio.sleep(random.randrange(15))  # 세션 차단을 방지하기위한  15초내외로 난수 딜레이
            try:
                async with session.get(
                        url[:url.rfind(('/'))] + '/about',
                        ssl=False
                ) as response:
                    r = await response.read()
                    soup = BeautifulSoup(markup=r, features='lxml')
                    extract_title_and_value(soup, url_index)

            except aiohttp.client_exceptions.ClientConnectorError:
                await asyncio.sleep(random.randrange(15))  # 세션 차단을 방지하기위한  15초내외로 난수 딜레이
                try:
                    async with session.get(url[:url.rfind(('/'))] + '/about', ssl=False) as response:
                        r = await response.read()
                        soup = BeautifulSoup(markup=r, features='lxml')
                        extract_title_and_value(soup, url_index)

                except aiohttp.client_exceptions.ClientConnectorError:
                    chrome_options = Options()
                    chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
                    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()),
                                              options=chrome_options)
                    driver.get(url[:url.rfind(('/'))] + '/about')
                    driver.implicitly_wait(3)
                    soup = BeautifulSoup(markup=driver.page_source, features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
                    extract_title_and_value(soup, url_index)
                    driver.close()
                except Exception:
                    traceback.print_exc()


async def run_distillery_detail_collector(link: list, scrap_dict: dict):
    """
        run_distillery_detail_collector.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    smp = asyncio.Semaphore(30)  # 비동기 최대 갯수 30개 제한
    fts = [asyncio.ensure_future(extract_distillery_detail(idx, u, smp, scrap_dict)) for idx, u in enumerate(link)]
    await tqdm_asyncio.gather(*fts)


def collect_distillery_detail(current_date: str, scrap_dict: dict):
    """
        collect.
            Note:
                파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    distillery_table = pd.read_csv(f'results/{current_date}/csv/pre/{BatchType.DISTILLERY_PRE.value}.csv')
    wb_libs_func.reset_list_size(len(distillery_table), scrap_dict)
    asyncio.run(run_distillery_detail_collector(distillery_table.link, scrap_dict))
