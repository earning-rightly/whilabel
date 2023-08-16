from bs4 import BeautifulSoup
import cfscrape
from apps.batches.wb_distillery_collector.wb_distillery_collector_pre.wb_distillery_collector_pre_values import distillery_summary_collect_url as url , distillery_summary_collect_data as pre_scrap

def collect():            #증류소의 초기 정보를 수집하는 함수
    """
        collect.
            Note:
                브랜드 초기정보 수집 함수
    """
    scraper = cfscrape.create_scraper()
    soup = BeautifulSoup(
        scraper.get(url['distillery']).content,
        'lxml'
        )
    #whisky base에 distillery 카테고리 홈페이지 정보 수집
    clickable_list = soup.select(".clickable") #증류소 갯수 확인 type : list

    data_list = soup.select(".data")           #data로 시작하는 class 명 수집 type : list

    for i in range(len(clickable_list)):       #증류쇼 갯수만큼 반복
        pre_scrap['distillery_name'].append(clickable_list[i].text.replace("\t", "").replace("\n", ""))  # 브랜드 초기정보 수집
        pre_scrap['link'].append(clickable_list[i].a['href'])
        pre_scrap['country'].append(data_list[4 * (i + 1)].text)
        pre_scrap['whiskies'].append(data_list[(4 * (i + 1)) + 1].text)
        pre_scrap['votes'].append(data_list[(4 * (i + 1)) + 2].text)
        pre_scrap['rating'].append(data_list[(4 * (i + 1)) + 3].text)
