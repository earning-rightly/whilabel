import asyncio
from bs4 import BeautifulSoup
import pandas as pd
import page_3_value
import json
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession
from aiohttp import TCPConnector


async def getpage(url, sema,loop,table):
    async with sema:
        async with sema:
            async with ClientSession(trust_env=True, connector=TCPConnector(ssl=False)) as session:
                async with session.get(url) as response:
                    r = await response.read()

                    soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')
                    if soup.select('.col-sm-offset-3 col-sm-6 site-error') != []:#해당 위스키 페이지가 사라짐 #ex) : https://www.whiskybase.com/whiskies/whisky/170176/aberfeldy-1996-ca
                        print(soup.select('.col-sm-offset-3 col-sm-6 site-error'))
                        print(url)
                        pass
                    else:
                        page_3_value.whiskey_name_list.append(soup.select('.name header h1')[0].text.strip())


                        # print(whiskey_name_list)
                        # 위스키별 정보 사이트에선 태그구분(클래스명, 아이디명)등으로 구분없이 dt로 되어있어 딕셔너리를 사용하여 키 매칭하여 해당 값을 리스트에 저장
                        dt_list = soup.select('dt')  # 딕셔너리에 대한 key 매칭을 위해 수집
                        dd_list = soup.select('dd')  # 캐에대한 value값

                        for i in range(len(dt_list)):
                            if dt_list[i].text.strip() == 'Overall rating' or dt_list[i].text.strip() == 'votes' or dt_list[
                                i].text.strip() == 'vote':  # 변경필요 == -> !=으로
                                pass
                            else:

                                if dt_list[i].text.strip() == 'Distilleries' or dt_list[i].text.strip() == 'Distillery':
                                    dis_dict = {}
                                    for link in dd_list[i].div:
                                        if link.text.strip() != ',':

                                            dis_dict[link.text.strip()] = link['href']
                                            page_3_value.searching_col_dist["Distillery"][
                                        table[table.whikie_link == url].index[0]] = dis_dict


                                else:
                                    page_3_value.searching_col_dist[dt_list[i].text.strip()][
                                        table[table.whikie_link == url].index[0]] = dd_list[i].text.strip()





                        try:
                            page_3_value.over_rating_list[table[table.whikie_link == url].index[0]] = \
                            soup.select('dd.votes-rating')[
                               0].text.strip()  # 딕셔너리에 넣지않은이유는 vote투표수가 여러개일때와 한개일때의 dt태그명이 다른점과 같은 데이터가 2번 추출된다든점에서 따로 진행
                        except:
                            print(url)

                        page_3_value.votes_list[table[table.whikie_link == url].index[0]] = \
                        soup.select('dd.votes-count')[0].text.strip()
                        if soup.select('.photo')[0][
                            'href'] != 'https://static.whiskybase.com/storage/whiskies/default/big.png?v4':
                            page_3_value.photo_list[table[table.whikie_link == url].index[0]] = soup.select('.photo')[0][
                                'href']
                        try:
                            page_3_value.block_price_list[table[table.whikie_link == url].index[0]] = \
                            soup.select('.block-price')[0].text.strip().split('\n')[1]
                        except:
                            pass
                        real_tag_list = []
                        tag_list = soup.select('.tag-name')
                        for tag in tag_list:
                            real_tag_list.append(tag.text.strip())
                        real_tast_num = []
                        tast_list = soup.select('.btn-tastingtag')
                        for tast in tast_list:
                            real_tast_num.append(tast['data-num'])
                        page_3_value.taste_dict_list[table[table.whikie_link == url].index[0]] = dictionary = dict(
                            zip(real_tag_list, real_tast_num))


async def main(link,loop,table):
        semaphore = asyncio.Semaphore(100)
        fts = [asyncio.ensure_future(getpage(u, semaphore,loop,table)) for u in link]
        await tqdm_asyncio.gather(*fts)

def initserilized_value(mode):
    if mode =='brand':
        table = pd.read_csv('brand_whisky_link.csv')
        table = table[:100]
        reset_list_size(table)

    elif mode == 'distillery':
        table = pd.read_csv('distillery_whisky_link.csv')
        table = table[:100]
        reset_list_size(table)

    loop = asyncio.get_event_loop()
    loop.run_until_complete(main(table.whikie_link, loop,table))
    loop.close


def reset_list_size(table):
    page_3_value.over_rating_list.extend([None for i in range(len(table.whikie_link))])
    page_3_value.votes_list.extend([None for i in range(len(table.whikie_link))])
    page_3_value.votes_rating_current.extend([None for i in range(len(table.whikie_link))])
    page_3_value.photo_list.extend([None for i in range(len(table.whikie_link))])
    for key in page_3_value.searching_col_dist:
        page_3_value.searching_col_dist.get(key).extend([None for i in range(len(table.whikie_link))])


def save_results (mode): #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery

    if mode == 'brand':
        for key in page_3_value.whisky_data_to_df.keys():
            print('key : ' + key)
            print('valeu length : '  + str(len(page_3_value.whisky_data_to_df[key])))
        results = pd.DataFrame(page_3_value.whisky_data_to_df)
        results.to_csv(mode + '_whisky_data.csv')
        with open(mode + '_whisky_data.json', 'w') as outfile:
            json.dump(page_3_value.whisky_data_to_df, outfile, indent=4)

    elif mode == 'distillery':
        for key in page_3_value.whisky_data_to_df.keys():
            print('key : ' + key)
            print('valeu length : ' + str(len(page_3_value.whisky_data_to_df[key])))
        results = pd.DataFrame(page_3_value.whisky_data_to_df)
        results.to_csv(mode + '_whisky_data.csv')
        with open(mode + '_whisky_data.json', 'w') as outfile:
            json.dump(page_3_value.whisky_data_to_df, outfile, indent=4)

        #results.to_sql()



def write_log(current_time, log_mode, mode = 'distillery'):
    def start():
        with open("log.txt", "a") as f:
            f.write('\nstart time : ' + str(current_time) + '\nmode : ' + mode+'\nlevel : page 3')
        f.close()
    def end():
        with open("log.txt", "a") as f:

            f.write('\nfinish time : ' + str(current_time) + " : " + mode+'\nlevel : page 3')
        f.close()

    if log_mode == 'start':
        start()
    elif log_mode == 'end':
        end()
