import asyncio
import random
import aiohttp.client_exceptions
import bs4
from bs4 import BeautifulSoup
import pandas as pd
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
import traceback
from selenium.webdriver.chrome.options import Options
from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager

from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.enums import BatchType


async def extract_bottler_detail(url_index: int, url: str, sema: asyncio.Semaphore, scrap_dict: dict):
    """
    extract_bottler_detail.
        Args:
            url_index (int): 증류소 URL의 인덱스.
            url (str): 증류소 홈페이지 링크.
            sema (asyncio.Semaphore): 비동기 세마포어.
            scrap_dict (dict): 수집한 정보를 담을 딕셔너리.
        Note:
            bottler 상세정보를 수집하기 위해 비동기식 처리를 위한 함수
    """

    def extract_title_and_value(sp: bs4.BeautifulSoup, index: int):
        """
        extract_title_and_value.
            Args:
                sp (bs4.BeautifulSoup): 증류소 홈페이지 정보.
                index (int): 증류소 URL의 인덱스.
            Note:
                    beautifulsoup을 이용한 bottler 상세 정보수집
        """
        title_list = sp.select('.title')
        value_list = sp.select('.value')

        try:
            scrap_dict['company_about'][index] = sp.select('.company-about p span')[0].text.strip()
        except IndexError:
            pass

        try:
            scrap_dict['company_address'][index] = sp.select('.company-address')[0].text.strip()
        except IndexError:
            pass

        for title_index in range(len(title_list)):
            try:
                if title_list[title_index].text.strip() == 'Specialists':
                    specialists_dict = {}
                    for avatar in sp.select('.specialists li'):
                        specialists_dict[avatar.a.text.strip()] = avatar.a['href']
                    scrap_dict['specialists'][index] = specialists_dict
                else:
                    title = title_list[title_index].text.strip().lower().replace(' ', '_')
                    scrap_dict[title][index] = value_list[title_index].text.strip()
            except Exception:
                pass

    # 비동기 세마포어를 사용하여 동시에 수행 가능한 작업의 수를 제한합니다.
    async with sema:
        async with ClientSession(
                trust_env=True,
                connector=TCPConnector(ssl=False)
        ) as session:
            # 요청 사이에 임의의 대기 시간을 설정하여 서버에 부하를 줄입니다.
            await asyncio.sleep(random.randrange(15))
            try:
                # aiohttp를 사용하여 웹 페이지에 접근합니다.
                async with session.get(
                        url[:url.rfind(('/'))] + '/about',
                        ssl=False
                ) as response:
                    r = await response.read()
                    soup = BeautifulSoup(markup=r, features='lxml')
                    extract_title_and_value(sp=soup, index=url_index)

            except aiohttp.client_exceptions.ClientConnectorError:
                # aiohttp에서 연결 오류가 발생하는 경우, Selenium을 사용하여 대체합니다.
                chrome_options = Options()
                chrome_options.add_argument("--headless=new")
                driver = webdriver.Chrome(
                    service=ChromeService(ChromeDriverManager().install()),
                    options=chrome_options
                )
                driver.get(url[:url.rfind(('/'))] + '/about')
                driver.implicitly_wait(3)
                soup = BeautifulSoup(markup=driver.page_source, features='lxml')
                extract_title_and_value(sp=soup, index=url_index)
                driver.close()
            except Exception:
                traceback.print_exc()


async def run_bottler_detail_collector(link: list, scrap_dict: dict):
    """
    run_bottler_detail_collector.
        Args:
            link (list): 증류소 홈페이지 링크 리스트.
            scrap_dict (dict): 수집한 정보를 담을 딕셔너리.
    """
    # Semaphore를 사용하여 비동기 작업의 동시 실행 수를 제한합니다.
    sm = asyncio.Semaphore(30)
    fts = [asyncio.ensure_future(
        extract_bottler_detail(idx, u, sm, scrap_dict)) for idx, u in enumerate(link)]
    # 비동기 작업을 실행하고 완료될 때까지 기다립니다.
    await tqdm_asyncio.gather(*fts)


def collect_bottler_detail(current_date: str, scrap_dict: dict):
    """
    collect_bottler_detail
        Args:
            current_date (str): 현재 날짜.
            scrap_dict (dict): 수집한 정보를 담을 딕셔너리.
    """
    # 증류소 정보가 포함된 CSV 파일을 읽어옵니다.
    bottler_table = pd.read_csv(f'results/{current_date}/csv/pre/{BatchType.BOTTLER_PRE.value}.csv')
    # scrap_dict 내의 리스트 크기를 초기화합니다.
    wb_libs_func.reset_list_size(len(bottler_table), scrap_dict)
    # 비동기 작업을 실행합니다.
    asyncio.run(run_bottler_detail_collector(bottler_table.link, scrap_dict))
