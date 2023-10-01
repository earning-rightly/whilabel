import bs4
import cfscrape
from bs4 import BeautifulSoup
import pandas as pd
from webdriver_manager.chrome import ChromeDriverManager
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service as ChromeService
from tqdm import tqdm

from apps.batches.wb.common.enums import BatchType

tqdm.pandas()  # tqdm의 pandas전용 메소드를 호출합니다


def turn_around_selenum(table: pd.Series, whisky_link_scrap: dict):
    """
        turn_around_selenum.
            Args:
                url : 수집해야할 홈페이지 링크.
                url_index : 수집해야할 홈페이지 순서(번호)

            Note:
                aiohttp.client_exceptions.ClientConnectorError 발생시 셀레니움으로 대체하여 수집하는 함수
    """
    chrome_options = Options()
    chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=chrome_options)
    driver.get(table.link)
    driver.implicitly_wait(3)
    soup = BeautifulSoup(markup=driver.page_source,
                         features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
    extract_link_related_with_whisky(soup=soup, table=table, whisky_link_scrap=whisky_link_scrap)
    driver.close()


def extract_link_related_with_whisky(soup: bs4.BeautifulSoup, table: pd.Series, whisky_link_scrap: dict):
    """
        extract_link_related_with_whisky.
            Args:
                soup : 수집해야할 홈페이지 링크.
                table : 수집해야할 홈페이지 순서(번호)

            Note:
                aiohttp.client_exceptions.ClientConnectorError 발생시 셀레니움으로 대체하여 수집하는 함수
    """
    link_list = soup.select(".clickable")
    if link_list == []:
        print(table.link)

    for link in link_list:  # 위스키 사진기준으로 위스키 갯수를 파악후 반복문으로 링크 수집
        # clickable이라는 클래명을 가진 태그에서 위스키 링크 추출하여  whikie_link 리스트에 저장
        whisky_link_scrap['whisky_link'].append(link['href'])


def apply_scrap_whisky_link(table: pd.Series, whisky_link_scrap: dict):
    """
        apply_scrap_whisky_link.
            Args:
                table : 수집해야할 홈페이지 순서(번호)
                whisky_link_scrap
            Note:
                aiohttp.client_exceptions.ClientConnectorError 발생시 셀레니움으로 대체하여 수집하는 함수
    """
    try:
        scraper = cfscrape.create_scraper()
        soup = BeautifulSoup(
            scraper.get(
                url=table.link).content,
            features='lxml')  # BeautifulSoup을 통해 수집된 페이지 검색
        extract_link_related_with_whisky(soup=soup, table=table, whisky_link_scrap=whisky_link_scrap)

    except:  # ?
        turn_around_selenum(table=table, whisky_link_scrap=whisky_link_scrap)


def collect_whisky_link(batch_type: BatchType, current_date: str, whisky_link_scrap: dict):
    """
        collect_whisky_link.
    """
    table = pd.read_csv(f'results/{current_date}/csv/pre/{batch_type.value}.csv')  # 증류소, 브랜드에서 추출한 사전 정보 가져오기
    table.progress_apply(lambda x: apply_scrap_whisky_link(table=x, whisky_link_scrap=whisky_link_scrap), axis=1)
