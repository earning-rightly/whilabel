from bs4 import BeautifulSoup
import cfscrape
from tqdm import tqdm


def collect_brand_pre(scrap_dict: dict, url: str):  # 브랜드의 초기 정보를 수집하는 함수
    """
    collect_bottler_pre
        Args:
            scrap_dict (dict): 수집한 정보를 담을 딕셔너리.
            url (str): 수집해야할 홈페이지ㄴ
        Notes:
            브랜드의 사전 정보를 수집하는 함수입니다.
    """
    # cfscrape를 사용하여 웹 페이지에 접속하는 scraper 생성
    scraper = cfscrape.create_scraper()

    # BeautifulSoup을 사용하여 웹 페이지 파싱
    soup = BeautifulSoup(
        scraper.get(
            url=url).content,
        features='lxml'
    )
    # whisky base에 brands 카테고리 홈페이지 정보 수집
    clickable_list = soup.select(".clickable")
    data_list = soup.select(".data")

    for i in tqdm(range(len(clickable_list))):  # 브랜드 수만큼 반복, 브랜드 사전 정보 수집
        brand_name = clickable_list[i].text.replace("\t", "").replace("\n", "")
        link = clickable_list[i].a['href']

        # 수집한 정보를 딕셔너리에 추가
        scrap_dict['brand_name'].append(brand_name)  # 브랜드명 수집
        scrap_dict['link'].append(link)  # whisky base 브랜드 페이지 수집
        scrap_dict['country'].append(data_list[5 * (i + 1)].text)  # 나라명 수집
        scrap_dict['whiskies'].append(data_list[(5 * (i + 1)) + 1].text)  # 위스키 갯수 수집
        scrap_dict['votes'].append(data_list[(5 * (i + 1)) + 2].text)  # 투표수 수집
        scrap_dict['rating'].append(data_list[(5 * (i + 1)) + 3].text)  # 평점 수집
        scrap_dict['wb_rank'].append(data_list[(5 * (i + 1)) + 4].text)  # whisky base 랭크 수집