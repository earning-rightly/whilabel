from bs4 import BeautifulSoup
import cfscrape
from tqdm import tqdm


def collect_bottler_pre(scrap_dict: dict, url: str):
    """
        collect_bottler_pre
        Args:
            scrap_dict (dict): 수집한 정보를 담을 딕셔너리.
            url (str): 수집해야할 홈페이지ㄴ
        Notes:
            보틀러 사전 정보를 수집하는 함수입니다.

    """

    # cfscrape를 사용하여 웹 페이지에 접속하는 scraper 생성
    scraper = cfscrape.create_scraper()

    # BeautifulSoup을 사용하여 웹 페이지 파싱
    soup = BeautifulSoup(
        scraper.get(url=url).content,
        features='lxml'
    )

    # whisky base에서 bottler 카테고리 홈페이지 정보 수집
    clickable_list = soup.select(".clickable")
    data_list = soup.select(".data")

    # 증류소 갯수만큼 반복
    for i in tqdm(range(len(clickable_list))):
        # 증류소 이름과 링크 수집
        bottler_name = clickable_list[i].text.replace("\t", "").replace("\n", "")
        link = clickable_list[i].a['href']

        # 수집한 정보를 딕셔너리에 추가
        scrap_dict['bottler_name'].append(bottler_name)
        scrap_dict['link'].append(link)
        scrap_dict['country'].append(data_list[4 * (i + 1)].text)
        scrap_dict['whiskies'].append(data_list[(4 * (i + 1)) + 1].text)
        scrap_dict['votes'].append(data_list[(4 * (i + 1)) + 2].text)
        scrap_dict['rating'].append(data_list[(4 * (i + 1)) + 3].text)