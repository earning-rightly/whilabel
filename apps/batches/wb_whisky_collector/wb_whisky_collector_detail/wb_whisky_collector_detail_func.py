import asyncio
from bs4 import BeautifulSoup
import pandas as pd
from batches.wb_whisky_collector.wb_whisky_collector_detail.wb_whisky_collector_detail_values import whisky_collect_detail_scrap as whisky_detail_scrap
from tqdm.asyncio import tqdm_asyncio
from aiohttp import ClientSession, TCPConnector
from batches.wb_libs import wb_libs_func

#scrap_whisky_collector_detail try, except 수정필요
async def scrap_whisky_collector_detail(url, sema,loop, url_index):
    async with sema:
        async with ClientSession(trust_env=True, connector=TCPConnector(ssl=False)) as session:
            await asyncio.sleep(5)  # 세션 차단을 방지하기위한 3초 딜레이
            async with session.get(url,ssl = False) as response:

                r = await response.read()

                soup = await loop.run_in_executor(None, BeautifulSoup, r, 'lxml')
                if soup.select('.col-sm-offset-3.col-sm-6.site-error') != []:#해당 위스키 페이지가 사라짐 #ex) : https://www.whiskybase.com/whiskies/whisky/170176/aberfeldy-1996-ca

                    pass
                else: #위스키 사이트가 active일때

                    whisky_detail_scrap['whiskey_name'][url_index] = soup.select('.name header h1')[0].text.strip()  #위스키 이름 추출

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
                                        whisky_detail_scrap["distillery"][url_index] = dis_dict
                            else:

                                whisky_detail_scrap[dt_list[i].text.strip().lower().replace(' ','_')][url_index] = dd_list[i].text.strip()

                    whisky_detail_scrap['overall_rating'][url_index] = soup.select('dd.votes-rating')[
                           0].text.strip()  # 딕셔너리에 넣지않은이유는 vote투표수가 여러개일때와 한개일때의 dt태그명이 다른점과 같은 데이터가 2번 추출된다든점에서 따로 진행
                    whisky_detail_scrap['votes'][url_index] = soup.select('dd.votes-count')[0].text.strip()

                    if soup.select('.photo')[0][
                        'href'] != 'https://static.whiskybase.com/storage/whiskies/default/big.png?v4':
                        whisky_detail_scrap['photo'][url_index] = soup.select('.photo')[0]['href']
                    try:
                        whisky_detail_scrap['block_price'][url_index] = soup.select('.block-price')[0].text.strip().split('\n')[1]
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
                    whisky_detail_scrap['tag_name'][url_index] = dictionary = dict(
                        zip(real_tag_list, real_tast_num))


async def extract_whisky_detail_collector_async(link,loop):
    semaphore = asyncio.Semaphore(10)
    fts = [asyncio.ensure_future(scrap_whisky_collector_detail(u, semaphore,loop,url_index= url_index)) for url_index, u in enumerate(link)]
    await tqdm_asyncio.gather(*fts)

def collect(mode):
    table = pd.read_csv('wb_'+mode+'_whisky_collector_link.csv')
    table = table[:10]
    wb_libs_func.reset_list_size(len(table), whisky_detail_scrap)
    loop = asyncio.get_event_loop()
    loop.run_until_complete(extract_whisky_detail_collector_async(table.whisky_link, loop))
    loop.close