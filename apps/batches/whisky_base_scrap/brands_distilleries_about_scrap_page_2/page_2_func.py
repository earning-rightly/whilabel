import asyncio
from bs4 import BeautifulSoup
import pandas as pd
import page_2_value
import json
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession
from aiohttp import TCPConnector

async def getpage(url, sema, loop, table ,mode):
    def find_brand_col(soup,table):
        title_list = soup.select('.title')
        value_list = soup.select('.value')

        try:
            page_2_value.company_about_list[table[table.link == url].index[0]] = \
            soup.select('.company-about p span')[0].text.strip()
        except:
            pass
        try:
            page_2_value.company_address_list[table[table.link == url].index[0]] = \
            soup.select('.company-address')[0].text.strip()
        except:
            pass
        for i in range(len(title_list)):
            try:
                page_2_value.brands_searching_col_dist[title_list[i].text.strip()][
                    table[table.link == url].index[0]] = value_list[i].text.strip()
            except:
                pass

    def find_distillery_col(url, soup, table):

        title_list = soup.select('.title')
        value_list = soup.select('.value')
        try:
            page_2_value.company_about_list[table[table.link == url].index[0]] = soup.select('.company-about p span')[0].text.strip()
        except IndexError:
            #print("company timeline has gone...."+url)
            pass

        page_2_value.company_address_list[table[table.link == url].index[0]] = soup.select('.company-address')[0].text.strip()

        for i in range(len(title_list)):

            try:
                if title_list[i].text.strip() == 'Specialists':
                    specialists_dict = {}
                    for avatar in soup.select('.specialists li'):
                        specialists_dict[avatar.a['href']] = avatar.a.text.strip()
                        page_2_value.distillery_searching_col_dist['Specialists'][
                            table[table.link == url].index[0]] = specialists_dict
                else:
                    page_2_value.distillery_searching_col_dist[title_list[i].text.strip()][
                        table[table.link == url].index[0]] = value_list[i].text.strip()
            except:
                pass
    async with sema:
        async with ClientSession(trust_env=True, connector=TCPConnector(ssl=False)) as session:
            # install pyopenssl[pip install pyOpenSSL]
            # if uninstall openssl then, connection error about port 443
            async with session.get(url[:url.rfind(('/'))]+'/about') as response:


                r = await response.read()

                soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')
                if mode == 'brand':
                    find_brand_col(soup, table)
                elif mode == 'distillery':
                    find_distillery_col(url, soup, table)


async def main(link,loop,table,mode):
        semaphore = asyncio.Semaphore(100)
        fts = [asyncio.ensure_future(getpage(u, semaphore,loop, table, mode)) for u in link]
        await tqdm_asyncio.gather(*fts)
def initserilized_value(mode):
    if mode =='brand':
        brand_table = pd.read_csv('brand.csv')

        reset_list_size(mode, brand_table)
        loop = asyncio.get_event_loop()
        loop.run_until_complete(main(brand_table.link,loop,brand_table, mode))
        loop.close

    elif mode == 'distillery':
        distillery_table = pd.read_csv('distillery.csv')
       # distillery_table = distillery_table[:10] #

        reset_list_size(mode, distillery_table)
       # print(page_2_value.company_address_list)

        loop = asyncio.get_event_loop()
        loop.run_until_complete(main(distillery_table.link,loop,distillery_table, mode))
        loop.close
        #print(page_2_value.Country_list)
def save_results (mode): #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery

    if mode == 'brand':
        results = pd.DataFrame(page_2_value.brands_to_df_dist)
        results.to_csv(mode + '_detail.csv')
        with open(mode + '_detail.json', 'w') as outfile:
            json.dump(page_2_value.brands_to_df_dist, outfile, indent=4)

    elif mode == 'distillery':
        results = pd.DataFrame(page_2_value.distillery_to_df_dict)

        results.to_csv(mode + '_detail.csv')
        with open(mode + '_detail.json', 'w') as outfile:
            json.dump(page_2_value.distillery_to_df_dict, outfile, indent=4)

        #results.to_sql()

def reset_list_size(mode, table):
    if mode == 'brand':
        for key in page_2_value.brands_searching_col_dist:

            page_2_value.brands_searching_col_dist.get(key).extend([None for i in range(len(table.link))])

    elif mode == 'distillery':
        for key in page_2_value.distillery_to_df_dict:
            page_2_value.distillery_to_df_dict.get(key).extend([None for i in range(len(table.link))])

def write_log(current_time, log_mode, mode = 'distillery'):
    def start():
        with open("log.txt", "a") as f:
            f.write('\nstart time : ' + str(current_time) + '\nmode : ' + mode+'\nlevel : page 2 [detail]')
        f.close()
    def end():
        with open("log.txt", "a") as f:

            f.write('\nfinish time : ' + str(current_time) + " : " + mode+'\nlevel : page 2 [detail]')
        f.close()

    if log_mode == 'start':
        start()
    elif log_mode == 'end':
        end()
