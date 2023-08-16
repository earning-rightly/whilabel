import asyncio
import random
import ssl
import traceback
import aiohttp.client_exceptions
from bs4 import BeautifulSoup
import pandas as pd
from batches.wb_whisky_collector.wb_whisky_collector_link.wb_whisky_collector_link_values import whisky_collect_link_scrap as link_scrap
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession


async def extract_whiksy_link_collector(url_index,url, sema, loop):
    """
        extract_whiksy_link_collector.
            Args:
                url : 수집해야할 홈페이지 링크.
                sema : 비동기식 해당 스레드 위치주소.
                loop :  (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
            Note:
                증류소, 브랜드 에서 위스키 링크를 수집하기 위해 비동기식 처리를 위한 함수
            Raises:
               aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결 진행중)
    """

    def extract_whisky_link(soup):
        photo_list = soup.select(".photo.buttons")
        link = soup.select(".clickable")
        for i in range(len(photo_list)):  # 위스키 사진기준으로 위스키 갯수를 파악후 반복문으로 링크 수집

            # clickable이라는 클래명을 가진 태그에서 위스키 링크 추출하여  whikie_link 리스트에 저장
            link_scrap['whisky_link'].append(link[i]['href'])

    async with sema:
        sslcontext = ssl.create_default_context(purpose=ssl.Purpose.CLIENT_AUTH)
        async with ClientSession(trust_env=True) as session:
            await asyncio.sleep(random.randrange(5,60))  # 세션 차단을 방지하기위한  15초내외로 난수 딜레이
            try:

                async with session.get(url, ssl=sslcontext)as response:
                    r = await response.read()
                    soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')
                    extract_whisky_link(soup)
            except aiohttp.client_exceptions.ClientConnectorError:  # 비동기식 접속으로 443포트에 대한 접속이 안되는 에러에 대한 예외처리

                from selenium import webdriver
                import chromedriver_autoinstaller
                from selenium.webdriver.chrome.options import Options
                print('used selenuim!!')
                print(url_index)
                chrome_options = Options()
                # headless 설정

                chromedriver_autoinstaller.install()  # Check if the current version of chromedriver exists
                # and if it doesn't exist, download it automatically,
                # then add chromedriver to path
                chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
                driver = webdriver.Chrome(options=chrome_options)
                driver.get(url[:url.rfind(('/'))] + '/about')
                driver.implicitly_wait(3)
                soup = await loop.run_in_executor(None, BeautifulSoup, driver.page_source,
                                                  'lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
                extract_whisky_link(soup=soup)
                driver.close()
            except:
                # write error_log.txt
                traceback.print_exc()

async def extract_whisky_link_collector_async(link, loop):
    """
        extract_whisky_link_collector_async.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
                loop : (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    semaphore = asyncio.Semaphore(30)
    fts = [asyncio.ensure_future(extract_whiksy_link_collector(url_index,u, semaphore,loop)) for url_index, u in enumerate(link)]
    await tqdm_asyncio.gather(*fts)
def collect(mode):
    """
        collect.
        Args:
                mode : {brand or distillery} mode를 통해 read_csv파일 결정.
            Note:
                파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    table = pd.read_csv('wb_'+mode+'_collector_pre.csv')                              # 증류소, 브랜드에서 추출한 사전 정보 가져오기
    loop = asyncio.get_event_loop()
    loop.run_until_complete(extract_whisky_link_collector_async(table.link, loop))
    loop.close