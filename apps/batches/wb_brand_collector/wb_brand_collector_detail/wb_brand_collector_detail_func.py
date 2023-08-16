import asyncio
from bs4 import BeautifulSoup
import pandas as pd
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
from batches.wb_libs import wb_libs_func
from batches.wb_brand_collector.wb_brand_collector_detail.wb_brand_collector_detail_values import brand_collect_detail_scrap as detail_scrap

async def extract_brand_collector_detail(url_index, url, sema, loop):
    """
        extract_brand_collector_detail.
            Args:
                url : 수집해야할 홈페이지 링크.
                sema : 비동기식 해당 스레드 위치주소.
                loop :  (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
                table : pd.read_csv로 읽은 데이터 프레임
                url_index : 수집중인 브랜드 url index 값
            Note:
                브랜드 상세정보를 수집하기 위해 비동기식 처리를 위한 함수
            Raises:
               aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결 진행중)
    """
    def extract_information_related_brand(soup,url_index):
        """
            extract_information_related_brand.
                Args:
                    url : 수집해야할 홈페이지 링크.

                Note:
                    실직적으로 브랜드 상세 정보를 수집하는 함수
                Raises:
                   IndexError : soup을 통해 생성한 title_list, value_list값이 현재 준비해둔 값과 안맞을때 (해결)
        """
        title_list = soup.select('.title')   #태그안 클래스명이 title인경우 추출, Returns : list
        value_list = soup.select('.value')   #태그안 클래스명이 value인경우 추출, Returns : list

        for i in range(len(title_list)):

            detail_scrap[title_list[i].text.strip().lower()][url_index] = value_list[i].text.strip()  # brand_collec_detail_scrap_dict안에서 title_list를 검색하여 해당 value값 리스트에 저장
            #scrap해서 가져오는 title변수를 대문자 lower(소문자화)하여 brand_collect_detail_scrap 안에 키로 비교하게는 좋은지 or
            #수집용 딕셔너리(대문자 == scrap해서 가져오는 title변수를 소문자화 안해도됨.)와 저장용 딕셔너리(소문자)로 구분해서 만들지

    async with sema:
        async with ClientSession(trust_env=True, connector=TCPConnector(ssl=False)) as session: #세션 생성
            # install pyopenssl[pip install pyOpenSSL]
            # if uninstall openssl then, connection error about port 443
            await asyncio.sleep(5)  # 세션 차단을 방지하기위한 3초 딜레이
            async with session.get(url[:url.rfind(('/'))]+'/about',ssl = False) as response:    #세션에 브랜드 상세주소 페이지 호출
                r = await response.read()
                soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')               #BeautifulSoup을 통해 수집된 페이지 검색
                extract_information_related_brand(soup = soup, url_index= url_index)
               # async with sleep (50) 수정필
async def extract_brand_collector_detail_async(link,loop):
    """
        extract_brand_collector_detail_async.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
                loop : (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    semaphore = asyncio.Semaphore(10)                                                          #동시 처리 50개 제한
    fts = [asyncio.ensure_future(extract_brand_collector_detail(url_index, u, semaphore,loop)) for url_index, u in enumerate(link)]
    await tqdm_asyncio.gather(*fts)

def collect():
    """
        collect.
            Note:
                파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    brand_table = pd.read_csv('wb_brand_collector_pre.csv')
    wb_libs_func.reset_list_size(len(brand_table), detail_scrap)   #brand_table에 갯수만큼 저장해야할 리스트 초기화

    loop = asyncio.get_event_loop()                                                                         #loop 생성
    loop.run_until_complete(extract_brand_collector_detail_async(brand_table.link,loop))
    loop.close                                                                                              #loop 종료