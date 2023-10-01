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


def turn_around_selenium(table: pd.Series, whisky_link_scrap: dict):
    """
        turn_around_selenium.
    """
    chrome_options = Options()
    chrome_options.add_argument("--headless=new")  # 크롬 창 실행없이 백그라운드에서 실행
    driver = webdriver.Chrome(service=ChromeService(ChromeDriverManager().install()), options=chrome_options)
    driver.get(table.link)
    driver.implicitly_wait(3)

    # BeautifulSoup을 통해 수집된 페이지 검색
    soup = BeautifulSoup(markup=driver.page_source, features='lxml')
    extract_whisky_link(soup=soup, table=table, whisky_link_scrap=whisky_link_scrap)

    driver.close()


def extract_whisky_link(soup: bs4.BeautifulSoup, table: pd.Series, whisky_link_scrap: dict):
    """
        extract_whisky_link.
    """
    link_list = soup.select(".clickable")
    for link in link_list:  # 위스키 사진기준으로 위스키 갯수를 파악후 반복문으로 링크 수집
        # clickable이라는 클래명을 가진 태그에서 위스키 링크 추출하여  whikie_link 리스트에 저장
        whisky_link_scrap['whisky_link'].append(link['href'])


def apply_scrap_whisky_link(table: pd.Series, whisky_link_scrap: dict):
    """
        apply_scrap_whisky_link.
    """
    try:
        scraper = cfscrape.create_scraper()
        soup = BeautifulSoup(
            scraper.get(url=table.link).content,
            features='lxml'
        )  # BeautifulSoup을 통해 수집된 페이지 검색
        extract_whisky_link(soup=soup, table=table, whisky_link_scrap=whisky_link_scrap)
    except Exception:
        turn_around_selenium(table=table, whisky_link_scrap=whisky_link_scrap)


def collect_whisky_link(batch_type: BatchType, current_date: str, whisky_link_scrap: dict):
    """
        collect_whisky_link.
    """
    table = pd.read_csv(f'results/{current_date}/csv/pre/{batch_type.value}.csv')  # 증류소, 브랜드에서 추출한 사전 정보 가져오기
    table.progress_apply(lambda x: apply_scrap_whisky_link(table=x, whisky_link_scrap=whisky_link_scrap), axis=1)
