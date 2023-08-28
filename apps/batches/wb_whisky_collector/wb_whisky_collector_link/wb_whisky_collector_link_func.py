import asyncio
import random
import ssl
import traceback
import aiohttp.client_exceptions
import bs4
from bs4 import BeautifulSoup
import pandas as pd
from webdriver_manager.chrome import ChromeDriverManager
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service as ChromeService


from apps.batches.wb_whisky_collector.wb_whisky_collector_link.wb_whisky_collector_link_values import \
    whisky_collect_link_scrap as link_scrap

async def extract_whiksy_link_collector(url : str , sema : asyncio.Semaphore):
    """
        extract_whiksy_link_collector.
            Args:
                url : 수집해야할 홈페이지 링크.
                sema : 비동기식 해당 스레드 위치주소.
            Note:
                증류소, 브랜드 에서 위스키 링크를 수집하기 위해 비동기식 처리를 위한 함수
            Raises:
               aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결)
    """

    def extract_whisky_link(soup : bs4.BeautifulSoup):
        link = soup.select(".clickable")

        for i in range(len(link)):  # 위스키 사진기준으로 위스키 갯수를 파악후 반복문으로 링크 수집
            # clickable이라는 클래명을 가진 태그에서 위스키 링크 추출하여  whikie_link 리스트에 저장
            link_scrap['whisky_link'].append(link[i]['href'])

    async with sema:
        sslcontext = ssl.create_default_context(purpose=ssl.Purpose.CLIENT_AUTH)
        async with ClientSession(trust_env=True) as session:
            await asyncio.sleep(random.randrange(3, 10))  # 세션 차단을 방지하기위한  15초내외로 난수 딜레이
            try:

                async with session.get(url, ssl=sslcontext) as response:
                    r = await response.read()
                    soup = BeautifulSoup(markup=r, features='lxml')
                    extract_whisky_link(soup)

            except aiohttp.client_exceptions.ClientConnectorError:  # 비동기식 접속으로 443포트에 대한 접속이 안되는 에러에 대한 예외처리
                chrome_options = Options()
                chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
                driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()),options=chrome_options)
                driver.get(url)
                driver.implicitly_wait(3)
                soup = BeautifulSoup(markup=driver.page_source,features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
                extract_whisky_link(soup=soup)
                driver.close()
            except:
                traceback.print_exc()


async def extract_whisky_link_collector_async(link : list):
    """
        extract_whisky_link_collector_async.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    semaphore = asyncio.Semaphore(30)
    fts = [asyncio.ensure_future(extract_whiksy_link_collector(url= url, sema=semaphore)) for url in link]
    await tqdm_asyncio.gather(*fts)

def collect(mode: str, current_date: str):
    """
        collect.
        Args:
                mode : {brand or distillery} mode를 통해 read_csv파일 결정.
                current_date : 위스키 링크를 수집하기위해 사전에 수집된 정보를 가져오기 위해 날짜 정보 추출
            Note:
                파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    table = pd.read_csv('results/' + current_date + '/csv/pre/wb_' + mode + '_collector_pre.csv')  # 증류소, 브랜드에서 추출한 사전 정보 가져오기
    asyncio.run(extract_whisky_link_collector_async(table.link))
