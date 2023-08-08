from bs4 import BeautifulSoup
import page_1_value
import pandas as pd
import cfscrape
import json

def scrap_page_1(mode = 'brand'): #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    scraper = cfscrape.create_scraper()

    soup = BeautifulSoup(scraper.get(page_1_value.page_1_url_dict[mode]).content, 'lxml')
    clickable_list = soup.select(".clickable")
    data_list = soup.select(".data")
    #print(len(clickable_list))

    if mode  == 'distillery':
        for i in range(len(clickable_list)):
            page_1_value.distillery_name_list.append(clickable_list[i].text)
            page_1_value.link_list.append(clickable_list[i].a['href'])
            page_1_value.country_list.append(data_list[4 * (i + 1)].text)
            page_1_value.whiskies_list.append(data_list[4 * (i + 1) + 1].text)
            page_1_value.votes_list.append(data_list[4 * (i + 1) + 2].text)
            page_1_value.rating_list.append(data_list[4 * (i + 1) + 3].text)
    elif mode == 'brand':
        for i in range(len(clickable_list)):
            page_1_value.distillery_name_list.append(clickable_list[i].text)
            page_1_value.link_list.append(clickable_list[i].a['href'])
            page_1_value.country_list.append(data_list[5 * (i + 1)].text)
            page_1_value.whiskies_list.append(data_list[5 * (i + 1) + 1].text)
            page_1_value.votes_list.append(data_list[5 * (i + 1) + 2].text)
            page_1_value.rating_list.append(data_list[5 * (i + 1) + 3].text)
            page_1_value.wb_rank_list.append(data_list[5 * (i + 1) + 4].text)
def save_results(mode = 'distillery'): #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    results = pd.DataFrame(page_1_value.data)
    results.to_csv(mode+'.csv')
    with open(mode+'.json', 'w') as outfile:
        json.dump(page_1_value.data, outfile, indent=4)
    #results.to_sql()

def write_log(current_time, log_mode, mode = 'distillery'):
    def start():
        with open("log.txt", "a") as f:
            f.write('\nstart time : ' + str(current_time) + '\nmode : ' + mode+'\nlevel : page 1')
        f.close()
    def end():
        with open("log.txt", "a") as f:

            f.write('\nfinish time : ' + str(current_time) + " : " + mode+'\nlevel : page 1')
        f.close()

    if log_mode == 'start':
        start()
    elif log_mode == 'end':
        end()
