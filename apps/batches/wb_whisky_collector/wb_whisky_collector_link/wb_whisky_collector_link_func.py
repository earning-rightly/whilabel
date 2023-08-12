import asyncio
import ssl
from bs4 import BeautifulSoup
import pandas as pd
from batches.wb_whisky_collector.wb_whisky_collector_link.wb_whisky_collector_link_values import whisky_collect_link_scrap as link_scrap
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession


async def extract_whiksy_link_collector(url, sema, loop):
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
    async with sema:
        sslcontext = ssl.create_default_context(purpose=ssl.Purpose.CLIENT_AUTH)
        async with ClientSession(trust_env=True) as session:
            async with session.get(url, ssl=sslcontext)as response:
                await asyncio.sleep(3)  # 세션 차단을 방지하기위한 3초 딜레이
                r = await response.read()
                soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')
                photo_list = soup.select(".photo.buttons")
                link = soup.select(".clickable")
                for i in range(len(photo_list)):  # 위스키 사진기준으로 위스키 갯수를 파악후 반복문으로 링크 수집

                 # clickable이라는 클래명을 가진 태그에서 위스키 링크 추출하여  whikie_link 리스트에 저장
                    link_scrap['whisky_link'].append(link[i]['href'])


async def extract_whisky_link_collector_async(link, loop):
    """
        extract_whisky_link_collector_async.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
                loop : (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    semaphore = asyncio.Semaphore(10)
    fts = [asyncio.ensure_future(extract_whiksy_link_collector(u, semaphore,loop)) for u in link]
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