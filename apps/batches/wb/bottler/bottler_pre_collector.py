from bs4 import BeautifulSoup
import cfscrape
from tqdm import tqdm


def collect_bottler_pre(scrap_dict : dict, url : str):
    scraper = cfscrape.create_scraper()
    soup = BeautifulSoup(
        scraper.get(url=url).content,
                    features='lxml'
    )

    # whisky base에 bottler 카테고리 홈페이지 정보 수집
    clickable_list = soup.select(".clickable")
    data_list = soup.select(".data")
    for i in tqdm(range(len(clickable_list))):  # 증류쇼 갯수만큼 반복
        bottler_name = clickable_list[i].text.replace("\t", "").replace("\n", "")
        link = clickable_list[i].a['href']

        scrap_dict['bottler_name'].append(bottler_name)
        scrap_dict['link'].append(link)
        scrap_dict['country'].append(data_list[4 * (i + 1)].text)
        scrap_dict['whiskies'].append(data_list[(4 * (i + 1)) + 1].text)
        scrap_dict['votes'].append(data_list[(4 * (i + 1)) + 2].text)
        scrap_dict['rating'].append(data_list[(4 * (i + 1)) + 3].text)
