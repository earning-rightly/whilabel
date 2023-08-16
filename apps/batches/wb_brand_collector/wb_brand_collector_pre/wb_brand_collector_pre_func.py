from bs4 import BeautifulSoup
import cfscrape
from batches.wb_brand_collector.wb_brand_collector_pre.wb_brand_collector_pre_values import brand_summary_collect_url as url , brand_summary_collect_data as pre_scrap

def collect():    #브랜드의 초기 정보를 수집하는 함수
        """
            collect.
                Note:
                    브랜드 사전 정보 수집 함수
        """
        scraper = cfscrape.create_scraper()
        soup = BeautifulSoup(
                scraper.get(url['brand']).content,
                'lxml'
                )
        #whisky base에 brands 카테고리 홈페이지 정보 수집
        clickable_list = soup.select(".clickable") #태그안 클래스명이 clickable인경우 추출, Returns : list
        data_list = soup.select(".data")           #태그안 클래스명이 data 추출, Returns : list

        for i in range(len(clickable_list)):       #브랜드 수만큼 반복, 브랜드 사전 정보 수집
            pre_scrap['brand_name'].append(clickable_list[i].text.replace("\t","").replace("\n","")) #브랜드명 수집
            pre_scrap['link'].append(clickable_list[i].a['href'])           #whisky base 브랜드 페이지 수집
            pre_scrap['country'].append(data_list[5 * (i + 1)].text)        #나라명 수집
            pre_scrap['whiskies'].append(data_list[(5 * (i + 1)) + 1].text) #위스키 갯수 수집
            pre_scrap['votes'].append(data_list[(5 * (i + 1)) + 2].text)    #투표수 수집
            pre_scrap['rating'].append(data_list[(5 * (i + 1)) + 3].text)   #평점 수집
            pre_scrap['wb_rank'].append(data_list[(5 * (i + 1)) + 4].text)  #whisky base 랭크 수집