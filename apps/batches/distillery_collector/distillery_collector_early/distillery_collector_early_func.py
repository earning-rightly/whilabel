from bs4 import BeautifulSoup
import cfscrape
from apps.batches.distillery_collector.distillery_collector_early import distillery_collector_early_values

def scrap_distillery_collector_early():            #증류소의 초기 정보를 수집하는 함수
        """
            scrap_distillery_collector_early.
                Note:
                    증류소 초기정보 수집 함수
        """
        scraper = cfscrape.create_scraper()
        soup = BeautifulSoup(scraper.get(
            distillery_collector_early_values.distillery_collec_early_url_dict['distillery']).content, 'lxml')
        #whisky base에 distillery 카테고리 홈페이지 정보 수집
        clickable_list = soup.select(".clickable") #증류소 갯수 확인 type : list

        data_list = soup.select(".data")           #data로 시작하는 class 명 수집 type : list

        for i in range(len(clickable_list)):       #증류소 갯수만큼 반복
            distillery_collector_early_values.distillery_name_list.append(clickable_list[i].text) #증류소 초기정보 수집
            distillery_collector_early_values.link_list.append(clickable_list[i].a['href'])
            distillery_collector_early_values.country_list.append(data_list[4 * (i + 1)].text)
            distillery_collector_early_values.whiskies_list.append(data_list[4 * (i + 1) + 1].text)
            distillery_collector_early_values.votes_list.append(data_list[4 * (i + 1) + 2].text)
            distillery_collector_early_values.rating_list.append(data_list[4 * (i + 1) + 3].text)
