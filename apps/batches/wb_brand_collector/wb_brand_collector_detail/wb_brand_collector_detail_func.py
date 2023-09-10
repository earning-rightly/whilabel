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

from apps.batches.wb_libs import wb_libs_func

async def extract_brand_collector_detail(url_index: int, url : str, sema : asyncio.Semaphore, scrap_dict : dict):
    """
        extract_brand_collector_detail.
            Args:
                url : 수집해야할 홈페이지 링크.
                sema : 비동기식 해당 스레드 위치주소.
                url_index : 수집중인 브랜드 url index 값
            Note:
                브랜드 상세정보를 수집하기 위해 비동기식 처리를 위한 함수
            Raises:
               aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결)
    """

    def extract_information_related_with_brand(soup: bs4.BeautifulSoup, url_index: int):
        """
            extract_information_related_brand.
                Args:
                    soup : 수집해야할 홈페이지 정보.
                    url : 수집해야할 홈페이지 링크.
                Note:
                    실직적으로 브랜드 상세 정보를 수집하는 함수
                Raises:
                   IndexError : soup을 통해 생성한 title_list, value_list값이 현재 준비해둔 값과 안맞을때 (해결)
        """
        title_list = soup.select('.title')  # 태그안 클래스명이 title인경우 추출, Returns : list
        value_list = soup.select('.value')  # 태그안 클래스명이 value인경우 추출, Returns : list
        for i in range(len(title_list)):
            scrap_dict[title_list[i].text.strip().lower()][url_index] = value_list[i].text.strip()

    async with sema:
        async with ClientSession(
                trust_env=True,
                connector=TCPConnector(ssl=False)) as session:  # 세션 생성
            await asyncio.sleep(random.randrange(10))  # 세션 차단을 방지하기위한  15초내외로 난수 딜레이
            try:
                async with session.get(
                        url=url[:url.rfind(('/'))] + '/about',
                        ssl=False) as response:  # 세션에 브랜드 상세주소 페이지 호출
                    r = await response.read()
                    soup = BeautifulSoup(markup=r,
                                         features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
                    extract_information_related_with_brand(
                        soup=soup,
                        url_index=url_index)

            except aiohttp.client_exceptions.ClientConnectorError:  # 비동기식 접속으로 443포트에 대한 접속이 안되는 에러에 대한 예외처리
                chrome_options = Options()
                chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
                driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()),
                                          options=chrome_options)
                driver.get(url[:url.rfind(('/'))] + '/about')
                driver.implicitly_wait(3)
                soup = BeautifulSoup(markup=driver.page_source,
                                     features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
                extract_information_related_with_brand(
                                                    soup=soup,
                                                    url_index=url_index)
                driver.close()
            except:
                traceback.print_exc()


async def extract_brand_collector_detail_async(link: str, scrap_dict : dict):
    """
        extract_brand_collector_detail_async.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    semaphore = asyncio.Semaphore(30)  # 동시 처리 30개 제한
    fts = [asyncio.ensure_future(extract_brand_collector_detail(url_index=url_index, url=url, sema=semaphore, scrap_dict = scrap_dict)) for url_index, url in enumerate(link)]
    await tqdm_asyncio.gather(*fts)
from apps.batches.wb_libs.enums import BatchType
def collect(batch_type : str, current_date: str, scrap_dict : dict):
    """
        collect.
             Args:
                current_date : 수집전 가져와야할 파일의 경로 확인을 위해 저장 날짜 추출.
            Note:
                파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    brand_table = pd.read_csv(f'results/{current_date}/csv/pre/{BatchType.BRAND_PRE.value}.csv')
    wb_libs_func.reset_list_size(len(brand_table), scrap_dict)  # brand_table에 갯수만큼 저장해야할 리스트 초기화
    asyncio.run(extract_brand_collector_detail_async(brand_table.link, scrap_dict))  # 비동기 실행