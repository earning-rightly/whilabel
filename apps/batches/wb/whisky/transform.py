import pandas as pd
import numpy as np
import json
from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.enums import BatchType


def extract_whisky_id(table: pd.Series) -> int or None:  # fusion 가능
    if table.link is None:
        return None

    return table.link.split('/')[-2]


def extract_whisky_name(table: pd.Series) -> str or None:
    if table.whisky_name is None:
        return None

    # 위스키 이름에서 탭 또는 빈칸제거
    return table.whisky_name.replace('\n', '').replace('\t', '')


def extract_taste_tags(table: pd.Series, allowed_taste_tags: list) -> dict or None:
    if table.tag_name is None:
        return None

    tags = [(name, vote) for name, vote in table.tag_name if name in allowed_taste_tags]
    return {
        'taste_tag': [tag[0] for tag in tags],
        'votecount': [tag[1] for tag in tags]
    }  # 저장해야할 taste tags 포맷 반환


def extract_distillery_information(table: pd.Series) -> dict or None:
    if table.distillery is None:
        return None

    distillery_name_list = list(table.distillery.keys())
    distillery_link_list = list(table.distillery.values())
    distillery_id_list = []
    for link in distillery_link_list:
        distillery_id_list.append(link.split('/')[-2])
    return {
        'distillery_id': distillery_id_list,
        'distillery_name': distillery_name_list,
        'distillery_link': distillery_link_list
    }


def extract_block_price(table: pd.Series) -> dict or None:
    try:
        price_list = table.block_price.split(' ')
        return {'unit': price_list[0], 'price': price_list[1]}
    except AttributeError:
        return None


def extract_bottled_year(table: pd.Series) -> str or None:
    try:
        if 4 < len(table.bottled):
            return table.bottled.split('.')[-1]
        else:
            return table.bottled
    except TypeError:
        return None


def extract_vintage_year(table: pd.Series) -> str or None:
    try:
        if 4 < len(table.vintage):
            return table.vintage.split('.')[-1]
        else:
            return table.vintage
    except AttributeError:
        return None
    except TypeError:
        return None


def extract_strength(table: pd.Series) -> float or None:
    try:
        return table.strength.split('%')[0]
    except TypeError:
        return None
    except AttributeError:
        # proof 계산법 미국식 100 proof = 50 %
        if 'proof' in str(table.strength):
            return float(table.strength.split(' ')[0]) * 0.5
        # gradi 이태리 표현 '도수'
        elif 'gradi' in str(table.strength):
            return table.strength.split(' ')[0]
        else:
            return None


def extract_overall_rate(table: pd.Series) -> float or None:
    try:
        return float(table.overall_rating.split('/')[0])
    except TypeError:
        return None
    except AttributeError:
        return None


def parse_price_fields(table: pd.Series) -> [str, str] or [None, None]:
    if table.price_information is None:
        return None, None

    return table.price_information['unit'], table.price_information['price']


def parse_distillery_fields(table: pd.Series) -> [str, str] or [None, None]:
    if table.distillery_information is None:
        return None, None

    return table.distillery_information['distillery_id'], table.distillery_information['distillery_name']


def transform_raw_to_wb_whisky(extract_data: dict, batch_type: BatchType) -> json:
    # SettingWithCopyWarning:
    pd.set_option('mode.chained_assignment', None)  # <==== 경고를 끈다

    whisky_data = pd.DataFrame.from_dict(data=extract_data, orient='columns')

    whisky_data.to_csv("test_whisky.csv")

    whisky_data['whisky_name'] = whisky_data.apply(extract_whisky_name, axis=1)
    whisky_data['wb_whisky_id'] = whisky_data.apply(extract_whisky_id, axis=1)
    whisky_data['distillery_information'] = whisky_data.apply(extract_distillery_information, axis=1)
    whisky_data['bottled_year'] = whisky_data.apply(extract_bottled_year, axis=1)

    whisky_data['strength'] = whisky_data.apply(extract_strength, axis=1)
    whisky_data['vintage_year'] = whisky_data.apply(extract_vintage_year, axis=1)
    whisky_data['price_information'] = whisky_data.apply(extract_block_price, axis=1)
    whisky_data['overall_rating'] = whisky_data.apply(extract_overall_rate, axis=1)
    whisky_data[['price_unit', 'price']] = whisky_data.apply(parse_price_fields, axis=1, result_type='expand')
    whisky_data[['distillery_id', 'distillery_name']] = whisky_data.apply(parse_distillery_fields, axis=1,
                                                                          result_type='expand')
    whisky_data['batchedAt'] = wb_libs_func.get_current_datetime()
    whisky_data['batchId'] = batch_type.value

    whisky_data = whisky_data[
        [
            'wb_whisky_id',
            'whisky_name',
            'distillery_id',
            'distillery_name',
            'category',
            'bottler',
            'bottled_year',
            'strength',
            'size',
            'label',
            'market',
            'added_on',
            'calculated_age',
            'casknumber',
            'barcode',
            'casktype',
            'bottling_serie',
            'number_of_bottles',
            'vintage_year',
            'stated_age',
            'bottle_code',
            'price',
            'price_unit',
            'photo',
            'overall_rating',
            'votes',
            'link'
        ]
    ]

    whisky_data.rename(
        columns={
            'wb_whisky_id': 'wbID',
            'whisky_name': 'name',
            'distillery_id': 'wbDistilleryId',
            'bottle_code': 'bottleCode',
            'distillery_name': 'distilleryName',
            'casknumber': 'cask_number',
            'price_unit': 'priceUnit',
            'bottled_year': 'bottledYear',
            'casktype': 'cask_type',
            'photo': 'image_url',
            'overall_rating': 'rating',
            'votes': 'voteCount',
            'link': 'wbLink'
        },
        inplace=True
    )

    whisky_data = whisky_data.replace({np.nan: None})
    whisky_data_pre_process_transform_barcode = whisky_data[whisky_data.barcode.isna() == False]
    barcode_list = list(set(list(whisky_data_pre_process_transform_barcode.barcode)))
    for barcode in barcode_list:
        if len(whisky_data_pre_process_transform_barcode[
                   whisky_data_pre_process_transform_barcode.barcode == barcode]) > 1:  # 바코드가 겹치는 경우가 여러개인경우
            extract_data = whisky_data_pre_process_transform_barcode[
                whisky_data_pre_process_transform_barcode.barcode == barcode]
            if len(extract_data[extract_data.voteCount == extract_data.voteCount.max()].index) > 1:  # 가장 큰 경우가 1개이상인경우
                whisky_data_pre_process_transform_barcode.drop(
                    extract_data[extract_data.index != extract_data.voteCount.max()].index[0], axis=0, inplace=True)
            elif len(extract_data[extract_data.voteCount == extract_data.voteCount.max()].index) == 1:
                whisky_data_pre_process_transform_barcode.drop(
                    extract_data[extract_data.index != extract_data.voteCount.max()].index[0], axis=0, inplace=True)
            else:  # votes가 집계가 안된거는경우?
                print(extract_data)
    return json.loads(whisky_data_pre_process_transform_barcode.to_json())
