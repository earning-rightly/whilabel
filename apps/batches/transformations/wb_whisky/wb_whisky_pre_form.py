import uuid

import pandas as pd
import numpy as np
import json
from apps.batches.wb_libs.enums import CollectionName
from apps.batches.wb_libs.lib_firebase import extract_to_firebase
from apps.batches.wb_libs import wb_libs_func


def make_whisky_id(table: pd.Series) -> int:  # fusion 가능
    """
        make_whisky_id
            Args:
               table : 변경해야할 판다스 시리스(한 행)

            Note:
                link주소값에서 위스키 id 값을 추출하여 해당 값 반환
    """
    if type(table.link) != type(None):
        return table.link.split('/')[-2]  # 위스키 id 값 추출
    else:
        print(table.link)
        return None


def remove_void_space_whiksy_name(table):
    """
       remove_void_space_whiksy_name
           Args:
              table : 변경해야할 판다스 시리스(한 행)

           Note:
               수집된 위스키 이름에서 빈칸 제거
   """
    if type(table.whisky_name) != type(None):
        return table.whisky_name.replace('\n', '').replace('\t', '')  # 위스키 이름에서 탭 또는 빈칸제거
    else:
        return None


def make_taste_tags(table, fire_store_tage_tag):
    """
       make_taste_tags
           Args:
              table : 변경해야할 판다스 시리스(한 행)

           Note:
               수집된 위스키 taste tags 형태변환
   """
    if type(table.tag_name) != type(None):
        taste_tags = table.tag_name  # taste tags 형태 dict로 변환
        taste_tag_name_list = list(taste_tags.keys())  # taste tags  명 추출
        taste_tag_vote_list = list(taste_tags.values())  # taste tags 링크 추출
        pre_process_taste_tag_name_list = []
        pre_process_taste_tag_vote_list = []
        for index, tag_name in enumerate(taste_tag_name_list):
            find_key = fire_store_tage_tag.get(tag_name) or 'nope'
            if find_key != 'nope':
                pre_process_taste_tag_name_list.append(find_key)
                pre_process_taste_tag_vote_list.append(taste_tag_vote_list[index])
        return {'taste_tag': pre_process_taste_tag_name_list, 'votecount': pre_process_taste_tag_vote_list}  # 저장해야할 taste tags 포맷 반환
    else:
        return None



def make_distillery_information(table):
    """
          make_distillery_information
              Args:
                 table : 변경해야할 판다스 시리스(한 행)

              Note:
                수집된 위스키에 대한 증류소 정보를 저장
      """

    if type(table.distillery) != type(None):

        distillery_name_list = list(table.distillery.keys())
        distillery_link_list = list(table.distillery.values())
        distillery_id_list = []
        for link in distillery_link_list:
            distillery_id_list.append(link.split('/')[-2])
        return {'distillery_id': distillery_id_list, 'distillery_name': distillery_name_list,
                'distillery_link': distillery_link_list}

    else:
        return None



def remake_size(table):
    if type(table.size) != type(None):
        try:
            return table.size.split(' ml')
        except:
            print(table.size,table.name)

    else:
        return None

def remake_block_price(table):
    try:
        price_list = table.block_price.split(' ')
        return {'unit': price_list[0], 'price': price_list[1]}
    except AttributeError:
        return None


def make_bottled_year(table):
    try:
        if 4 < len(table.bottled):
            return table.bottled.split('.')[-1]
        else:
            return table.bottled
    except TypeError:
        return None


def make_vintage_year(table):
    try:
        if 4 < len(table.vintage):
            return table.vintage.split('.')[-1]
        else:
            return table.vintage
    except AttributeError:
        return None
    except TypeError:
        return None

def remake_strength(table):
    try:
        return table.strength.split('%')[0]

    except TypeError:
        return None
    except AttributeError:
        if 'proof' in str(table.strength):
            return float(table.strength.split(' ')[0]) * 0.5  # proof 계산법 미국식 100 proof = 50 %

        elif 'gradi' in str(table.strength):
            return table.strength.split(' ')[0]                # gradi 이태리 표현 '도수'
        else:
            return None

def remake_overall_rate(table):
    try:
        return float(table.overall_rating.split('/')[0])

    except TypeError:
        return None
    except AttributeError:
        return None

def price_information_resize(table):
    if table.price_information is not None:
        unit = None
        price = None

        for key, value in dict(table.price_information).items():
            if key == 'unit':
                unit = value
            elif key == 'price':
                price = value
        return unit,price

    else:
        return None, None
def distillery_information_resize(table):
    if table.distillery_information is not None:
        distillery_id = None
        distillery_name = None

        for key, value in dict(table.distillery_information).items():
            if key == 'distillery_id':
                distillery_id = value
            elif key == 'distillery_name':
                distillery_name = value
        return distillery_id,distillery_name

    else:
        return None, None

def replace_extracted_data_with_wb_whisky_format(extract_data: dict, batchId : str = None) -> json:

    #SettingWithCopyWarning:
    pd.set_option('mode.chained_assignment', None)  # <==== 경고를 끈다

    whisky_data = pd.DataFrame.from_dict(data=extract_data, orient='columns')
    whisky_data.to_csv("test_whisky.csv")
    whisky_data['whisky_name'] = whisky_data.apply(remove_void_space_whiksy_name, axis=1)
    whisky_data['wb_whisky_id'] = whisky_data.apply(make_whisky_id, axis=1)
    whisky_data['distillery_information'] = whisky_data.apply(make_distillery_information, axis=1)
    whisky_data['bottled_year'] = whisky_data.apply(make_bottled_year, axis=1)


    whisky_data['strength'] = whisky_data.apply(remake_strength, axis=1)
    whisky_data['vintage_year'] = whisky_data.apply(make_vintage_year, axis=1)
    whisky_data['price_information'] = whisky_data.apply(remake_block_price, axis=1)
    whisky_data['overall_rating'] = whisky_data.apply(remake_overall_rate, axis=1)
    whisky_data[['price_unit','price']] = whisky_data.apply(price_information_resize, axis=1,result_type='expand')
    whisky_data[['distillery_id', 'distillery_name']] = whisky_data.apply(distillery_information_resize, axis=1, result_type='expand')
    whisky_data['batchedAt'] = wb_libs_func.get_current_datetime()
    whisky_data['batchId'] = batchId

    whisky_data = whisky_data[
        ['wb_whisky_id', 'whisky_name', 'distillery_id','distillery_name', 'category', 'bottler', 'bottled_year', 'strength',
         'size', 'label', 'market'
            , 'added_on', 'calculated_age', 'casknumber', 'barcode', 'casktype', 'bottling_serie'
            , 'number_of_bottles', 'vintage_year', 'stated_age', 'bottle_code', 'price','price_unit', 'photo', 'overall_rating', 'votes','link']]

    whisky_data.rename(columns={'wb_whisky_id' : 'wbID','whisky_name':'name','distillery_id':'wbDistilleryId','bottle_code' : 'bottleCode',
                                'distillery_name' : 'distilleryName','casknumber': 'cask_number', 'price_unit' : 'priceUnit','bottled_year' : 'bottledYear',
                                'casktype': 'cask_type','photo' : 'image_url','overall_rating' : 'rating','votes' : 'voteCount','link':'wbLink'}, inplace=True)

    whisky_data = whisky_data.replace({np.nan: None})
    whisky_data_pre_process_transform_barcoode = whisky_data[whisky_data.barcode.isna() == False]
    barcode_list = list(set(list(whisky_data_pre_process_transform_barcoode.barcode)))
    for barcode in barcode_list:
        if len(whisky_data_pre_process_transform_barcoode[
                   whisky_data_pre_process_transform_barcoode.barcode == barcode]) > 1:  # 바코드가 겹치는 경우가 여러개인경우
            extract_data = whisky_data_pre_process_transform_barcoode[whisky_data_pre_process_transform_barcoode.barcode == barcode]
            if len(extract_data[extract_data.voteCount == extract_data.voteCount.max()].index) > 1:  # 가장 큰 경우가 1개이상인경우
                whisky_data_pre_process_transform_barcoode.drop(
                    extract_data[extract_data.index != extract_data.voteCount.max()].index[0], axis=0, inplace=True)
            elif len(extract_data[extract_data.voteCount == extract_data.voteCount.max()].index) == 1:
                whisky_data_pre_process_transform_barcoode.drop(
                    extract_data[extract_data.index != extract_data.voteCount.max()].index[0], axis=0, inplace=True)
            else:  # votes가 집계가 안된거는경우?
                print(extract_data)
    return json.loads(whisky_data_pre_process_transform_barcoode.to_json())