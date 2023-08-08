import asyncio

import aiohttp
from bs4 import BeautifulSoup
import pandas as pd
import nest_asyncio
import whisky_link_scrap_value
import json
nest_asyncio.apply()
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession
from aiohttp import TCPConnector
async def getpage(url, sema, loop):
    async with sema:
        async with ClientSession(trust_env=True,  connector= TCPConnector(ssl=False)) as session:

            try:
                async with session.get(url,ssl = False )as response:
                    r = await response.read()
            except:
                await asyncio.sleep(5.0)
                async with session.get(url, ssl=False) as response:
                    r = await response.read()

            soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')
            photo_list = soup.select(".photo.buttons")
            link = soup.select(".clickable")
            for i in range(len(photo_list)):  # 위스키 사진기준으로 위스키 갯수를 파악후 반복문으로 링크 수집

             # clickable이라는 클래명을 가진 태그에서 위스키 링크 추출하여  whikie_link 리스트에 저장
                whisky_link_scrap_value.whikie_link_list.append(link[i]['href'])

async def main(link,loop):
        semaphore = asyncio.Semaphore(100)
        fts = [asyncio.ensure_future(getpage(u, semaphore,loop)) for u in link]
        await tqdm_asyncio.gather(*fts)
def initserilized_value(mode):
    if mode =='brand':
        table = pd.read_csv('brand.csv')



    elif mode == 'distillery':
        table = pd.read_csv('distillery.csv')
    print('loop start')
    print(mode)
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main(table.link, loop))
    loop.close

def save_results (mode): #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery

    results = pd.DataFrame(whisky_link_scrap_value.data)
    results.to_csv(mode + '_whisky_link.csv')
    with open(mode + '_whisky_link.json', 'w') as outfile:
        json.dump(whisky_link_scrap_value.data, outfile, indent=4)


def write_log(current_time, log_mode, mode = 'distillery'):
    def start():
        with open("log.txt", "a") as f:
            f.write('\nstart time : ' + str(current_time) + '\nmode : ' + mode+'\nlevel : page 2 [whisky_link]')
        f.close()
    def end():
        with open("log.txt", "a") as f:

            f.write('\nfinish time : ' + str(current_time) + " : " + mode+'\nlevel : page 2 [whisky_link]')
        f.close()

    if log_mode == 'start':
        start()
    elif log_mode == 'end':
        end()
