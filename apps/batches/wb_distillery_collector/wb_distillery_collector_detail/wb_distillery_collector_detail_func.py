import asyncio
import random
import aiohttp.client_exceptions
from bs4 import BeautifulSoup
import pandas as pd
from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_distillery_collector.wb_distillery_collector_detail.wb_distillery_collector_detail_values import distillery_collect_detail_scrap as detail_scrap
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
import traceback

async def extract_distillery_collector_detail(url_index, url, sema, loop):
    """
        extract_distillery_collector_detail.
            Args:
                url : 수집해야할 홈페이지 링크.
                sema : 비동기식 해당 스레드 위치주소.
                loop :  (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
                table : pd.read_csv로 읽은 데이터 프레임
                url_index : 수집중인 증류소 url index 값
            Note:
                증류소 상세정보를 수집하기 위해 비동기식 처리를 위한 함수
            Raises:
               aiohttp.client_exceptions.ClientConnectorError : ssl connect 문제 (해결 진행중)
    """
    def extract_information_related_with_distillery(soup, url_index):
        """
            extract_information_related_distillery.
                Args:
                    url : 수집해야할 홈페이지 링크.

                Note:
                    실직적으로 증류소 상세 정보를 수집하는 함수
                Raises:
                   IndexError : soup을 통해 생성한 title_list, value_list값이 현재 준비해둔 값과 안맞을때 (해결)
        """
        title_list = soup.select('.title')
        value_list = soup.select('.value')
        try:
            detail_scrap['company_about'][url_index] = soup.select('.company-about p span')[0].text.strip() #증류소 timeline 수집
        except IndexError: #증류소 timeline 정보가 없는경우
            pass
        try:
            detail_scrap['company_address'][url_index] = soup.select('.company-address')[0].text.strip()   #증류소 주소 수집
        except IndexError: #증류소 주소 정보가 없는경우
            pass
        for i in range(len(title_list)):
            try:
                if title_list[i].text.strip() == 'Specialists':                #title_list 값이 Specialists인경우엔 Specialist가 복수개인경우가 있어 딕셔너리로 저장
                    specialists_dict = {}
                    for avatar in soup.select('.specialists li'):
                        specialists_dict[avatar.a['href']] = avatar.a.text.strip()
                        detail_scrap['specialists'][url_index] = specialists_dict
                else:
                    detail_scrap[title_list[i].text.strip().lower().replace(' ','_')][url_index] = value_list[i].text.strip()  #나머지 title_list에사 소문자로 변경 및 빈칸을 '_'로
                                                                                                                               #채운후 detail_scrap의 키와 비교하여 순서에 맞게 저장
            except:
                pass
    async with sema:
        async with ClientSession(trust_env=True, connector=TCPConnector(ssl=False)) as session:
            # install pyopenssl[pip install pyOpenSSL]
            # if uninstall openssl then, connection error about port 443
            await asyncio.sleep(random.randrange(15))  # 세션 차단을 방지하기위한  15초내외로 난수 딜레이
            try:
                async with session.get(url[:url.rfind(('/'))]+'/about',ssl = False) as response:
                    r = await response.read()
                    soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')
                    extract_information_related_with_distillery(soup= soup, url_index= url_index)

            except aiohttp.client_exceptions.ClientConnectorError:
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
                extract_information_related_with_distillery(soup=soup, url_index=url_index)
                driver.close()
            except:
                # write error_log.txt
                traceback.print_exc()

async def extract_distillery_collector_detail_async(link,loop):
    """
        extract_distillery_collector_detail_async.
            Args:
                link : 수집해야할 홈페이지 전체 링크.
                loop : (async_execution)함수에서 asyncio.get_event_loop로 생성한 loop값
            Note:
                비동식 제한 갯수 설정(Semaphore) 및 수집해야할 홈페이지 반복문 실행
    """
    semaphore = asyncio.Semaphore(30)  #비동기 최대 갯수 50개 제한
    fts = [asyncio.ensure_future(extract_distillery_collector_detail(url_index, u, semaphore,loop)) for url_index, u in enumerate(link)]
    await tqdm_asyncio.gather(*fts)

def collect():
    """
        collect.
            Note:
                파일 읽기 및 파일크기에따른 리스트 초기화(reset_list_size) loop생성
    """
    distillery_table = pd.read_csv('wb_distillery_collector_pre.csv')
    wb_libs_func.reset_list_size(len(distillery_table), detail_scrap)

    loop = asyncio.get_event_loop()
    loop.run_until_complete(extract_distillery_collector_detail_async(distillery_table.link,loop))
    loop.close

