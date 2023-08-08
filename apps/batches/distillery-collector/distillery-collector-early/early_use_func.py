from bs4 import BeautifulSoup
import cfscrape
import distillery_values
import pandas as pd
import json

def scrap_distillery_collector_early():
        scraper = cfscrape.create_scraper()

        soup = BeautifulSoup(scraper.get(distillery_values.distillery_collec_early_url_dict['distillery']).content, 'lxml')
        clickable_list = soup.select(".clickable")
        data_list = soup.select(".data")

        for i in range(len(clickable_list)):
            distillery_values.distillery_name_list.append(clickable_list[i].text)
            distillery_values.link_list.append(clickable_list[i].a['href'])
            distillery_values.country_list.append(data_list[4 * (i + 1)].text)
            distillery_values.whiskies_list.append(data_list[4 * (i + 1) + 1].text)
            distillery_values.votes_list.append(data_list[4 * (i + 1) + 2].text)
            distillery_values.rating_list.append(data_list[4 * (i + 1) + 3].text)