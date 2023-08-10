from bs4 import BeautifulSoup
import cfscrape
import brand_collector_early_values

def extract_distillery_collector_early():    #브랜드의 초기 정보를 수집하는 함수
        """
            extract_distillery_collector_early.
                Note:
                    브랜드 초기정보 수집 함수
        """
        scraper = cfscrape.create_scraper()
        soup = BeautifulSoup(scraper.get(
            brand_collector_early_values.brand_collec_early_url_dict['brand']).content, 'lxml')
        #whisky base에 distillery 카테고리 홈페이지 정보 수집
        clickable_list = soup.select(".clickable") #태그안 클래스명이 clickable인경우 추출, Returns : list
        data_list = soup.select(".data")           #태그안 클래스명이 data 추출, Returns : list

        for i in range(len(clickable_list)):       #브랜드 수만큼 반복
            brand_collector_early_values.brand_name_list.append(clickable_list[i].text) #브랜드 초기정보 수집
            brand_collector_early_values.link_list.append(clickable_list[i].a['href'])
            brand_collector_early_values.country_list.append(data_list[4 * (i + 1)].text)
            brand_collector_early_values.whiskies_list.append(data_list[4 * (i + 1) + 1].text)
            brand_collector_early_values.votes_list.append(data_list[4 * (i + 1) + 2].text)
            brand_collector_early_values.rating_list.append(data_list[4 * (i + 1) + 3].text)