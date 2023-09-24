import asyncio
import aiohttp.client_exceptions
import bs4
from bs4 import BeautifulSoup
import pandas as pd
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
import traceback
import random
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager

from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.enums import BatchType


async def extract_brand_detail(url_index: int, url: str, sema: asyncio.Semaphore, scrap_dict: dict):
    """
    extract_brand_detail.
        Args:
            scrap_dict (dict): 수집한 정보를 담을 딕셔너리.
            url (str): 브랜드 홈페이지 링크.
            sema (asyncio.Semaphore): 비동기 세마포어.
            url_index (int): 브랜드 URL의 인덱스.
        Note:
            브랜드 상세정보를 수집하기 위해 비동기식 처리를 위한 함수
    """

    def extract_title_and_value(sp: bs4.BeautifulSoup, index: int):
        """
        extract_title_and_value.
            Args:
                sp (bs4.BeautifulSoup): 브랜 홈페이지 정보.
                index (int): 브랜드 URL의 인덱스.
            Note:
                beautifulsoup을 이용한 브랜드 상세 정보수집
        """
        title_list = sp.select('.title')
        value_list = sp.select('.value')
        for i in range(len(title_list)):
            title = title_list[i].text.strip().lower()
            scrap_dict[title][index] = value_list[i].text.strip()

    # 비동기 세마포어를 사용하여 동시에 수행 가능한 작업의 수를 제한합니다.
    async with sema:
        async with ClientSession(
                trust_env=True,
                connector=TCPConnector(ssl=False)
        ) as session:  # 세션 생성
            await asyncio.sleep(random.randrange(10))  # 세션 차단을 방지하기위한  10초내외로 난수 딜레이
            try:
                # aiohttp를 사용하여 웹 페이지에 접근합니다.
                async with session.get(
                        url=url[:url.rfind(('/'))] + '/about',
                        ssl=False
                ) as response:  # 세션에 브랜드 상세주소 페이지 호출
                    r = await response.read()
                    soup = BeautifulSoup(markup=r,
                                         features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
                    extract_title_and_value(soup, url_index)

            except aiohttp.client_exceptions.ClientConnectorError:
                # aiohttp에서 연결 오류가 발생하는 경우, Selenium을 사용하여 대체합니다.
                chrome_options = Options()
                chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
                driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()),
                                          options=chrome_options)
                driver.get(url[:url.rfind(('/'))] + '/about')
                driver.implicitly_wait(3)
                soup = BeautifulSoup(markup=driver.page_source,
                                     features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
                extract_title_and_value(
                    sp=soup,
                    index=url_index)
                driver.close()
            except Exception:
                traceback.print_exc()


async def run_brand_detail_collector(link: str, scrap_dict: dict):
    """
    run_brand_detail_collector.
        Args:
            link : 수집해야할 홈페이지 전체 링크.
        Note:
            비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    # Semaphore를 사용하여 비동기 작업의 동시 실행 수를 제한합니다.
    sm = asyncio.Semaphore(30)  # 동시 처리 30개 제한
    fts = [asyncio.ensure_future(extract_brand_detail(idx, u, sm, scrap_dict)) for idx, u in enumerate(link)]
    # 비동기 작업을 실행하고 완료될 때까지 기다립니다.
    await tqdm_asyncio.gather(*fts)


def collect_brand_detail(current_date: str, scrap_dict: dict):
    """
    collect_brand_detail.
         Args:
            current_date : 수집전 가져와야할 파일의 경로 확인을 위해 저장 날짜 추출.
        Note:
            파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    # 브랜드 정보가 포함된 CSV 파일을 읽어옵니다.
    brand_table = pd.read_csv(f'results/{current_date}/csv/pre/{BatchType.BRAND_PRE.value}.csv')
    # scrap_dict 내의 리스트 크기를 초기화합니다.
    wb_libs_func.reset_list_size(len(brand_table), scrap_dict)  # brand_table에 갯수만큼 저장해야할 리스트 초기화
    # 비동기 작업을 실행합니다.
    asyncio.run(run_brand_detail_collector(brand_table.link, scrap_dict))  # 비동기 실행
