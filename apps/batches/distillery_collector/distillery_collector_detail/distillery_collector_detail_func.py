import asyncio
from bs4 import BeautifulSoup
import pandas as pd
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
from apps.batches.libs import libs_func
from apps.batches.distillery_collector.distillery_collector_detail import distillery_collector_detail_values

async def extract_distillery_collector_detail(url, sema, loop, table):
    """
            extract_brand_collector_detail.
                Args:
                    url : 수집해야할 홈페이지 링크.
                    sema : 비동기식 해당 스레드 위치주소.
                    loop :  (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
                    table : pd.read_csv로 읽은 데이터 프레임
                Note:
                    브랜드 상세정보를 수집하기 위해 비동기식 처리를 위한 함수
                Raises:
                   aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결 진행중)
        """

    def extract_information_related_distillery(url, soup, table):
        """
            extract_information_related_brand.
                Args:
                    url : 수집해야할 홈페이지 링크.
                    soup : 수집해야할 홈페이지의 모든정보(html형식[XML])
                    table : pd.read_csv로 읽은 데이터 프레임
                Note:
                    실직적으로 브랜드 상세 정보를 수집하는 함수
                Raises:
                   IndexError : soup을 통해 생성한 title_list, value_list값이 현재 준비해둔 값과 안맞을때 (해결)
        """
        title_list = soup.select('.title')     #태그안 클래스명이 title인경우 추출, Returns : list
        value_list = soup.select('.value')     #태그안 클래스명이 value인경우 추출, Returns : list
        try:
            distillery_collector_detail_values.company_about_list[table[table.link == url].index[0]] = soup.select('.company-about p span')[0].text.strip()
        except IndexError:
            #print("company timeline has gone...."+url)
            pass
        try:
            distillery_collector_detail_values.company_address_list[table[table.link == url].index[0]] = soup.select('.company-address')[0].text.strip()
        except:
            pass
        for i in range(len(title_list)):

            try:
                if title_list[i].text.strip() == 'Specialists':  #specialist 이름과 홈페이지 링크 추출
                    specialists_dict = {}
                    for avatar in soup.select('.specialists li'): #증류소에 속해있는 specialist 수 만큼 추출
                        specialists_dict[avatar.a['href']] = avatar.a.text.strip()
                        distillery_collector_detail_values.distillery_collec_detail_scrap_dict['Specialists'][
                            table[table.link == url].index[0]] = specialists_dict
                else:
                    distillery_collector_detail_values.distillery_collec_detail_scrap_dict[title_list[i].text.strip()][
                        table[table.link == url].index[0]] = value_list[i].text.strip()    # distillery_collec_detail_scrap_dict안에서 title_list를 검색하여 해당 value값 리스트에 저장
            except:
                pass

    async with sema:
        async with ClientSession(trust_env=True, connector=TCPConnector(ssl=False)) as session:
            # install pyopenssl[pip install pyOpenSSL]
            # if uninstall openssl then, connection error about port 443
            async with session.get(url[:url.rfind(('/'))]+'/about',ssl = False) as response:
                r = await response.read()
                soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')
                extract_information_related_distillery(url, soup, table)

async def scrap_distillery_collector_detail_async(link,loop,table):
    """
        scrap_distillery_collector_detail_async.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
                loop : (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
                table : pd.read_csv로 읽은 데이터 프레임
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    semaphore = asyncio.Semaphore(100)  # 동시 처리 100개 제한
    fts = [asyncio.ensure_future(extract_distillery_collector_detail(u, semaphore, loop, table)) for u in link]
    await tqdm_asyncio.gather(*fts)

def async_execution():
    """
        async_execution.
            Note:
                파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    distillery_table = pd.read_csv('distillery_collector_early.csv')
    libs_func.reset_list_size(distillery_table, distillery_collector_detail_values.distillery_collec_detail_result_dict)

    loop = asyncio.get_event_loop()
    loop.run_until_complete(scrap_distillery_collector_detail_async(distillery_table.link,loop,distillery_table))
    loop.close

