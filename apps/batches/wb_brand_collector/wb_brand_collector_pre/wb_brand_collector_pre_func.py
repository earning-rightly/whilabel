from bs4 import BeautifulSoup
import cfscrape
from tqdm import tqdm

def collect(scrap_dict : dict, url : str ): # 브랜드의 초기 정보를 수집하는 함수
    """
        collect.
            Note:
                브랜드 사전 정보 수집 함수
    """
    scraper = cfscrape.create_scraper()
    soup = BeautifulSoup(
        scraper.get(
            url=url).content,
        features='lxml'
    )
    # whisky base에 brands 카테고리 홈페이지 정보 수집
    clickable_list = soup.select(".clickable")  # 태그안 클래스명이 clickable인경우 추출, Returns : list
    data_list = soup.select(".data")  # 태그안 클래스명이 data 추출, Returns : list
    for i in tqdm(range(len(clickable_list))):  # 브랜드 수만큼 반복, 브랜드 사전 정보 수집
        scrap_dict['brand_name'].append(clickable_list[i].text.replace("\t", "").replace("\n", ""))  # 브랜드명 수집
        scrap_dict['link'].append(clickable_list[i].a['href'])  # whisky base 브랜드 페이지 수집
        scrap_dict['country'].append(data_list[5 * (i + 1)].text)  # 나라명 수집
        scrap_dict['whiskies'].append(data_list[(5 * (i + 1)) + 1].text)  # 위스키 갯수 수집
        scrap_dict['votes'].append(data_list[(5 * (i + 1)) + 2].text)  # 투표수 수집
        scrap_dict['rating'].append(data_list[(5 * (i + 1)) + 3].text)  # 평점 수집
        scrap_dict['wb_rank'].append(data_list[(5 * (i + 1)) + 4].text)  # whisky base 랭크 수집
