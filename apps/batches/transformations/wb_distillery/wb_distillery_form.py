import uuid

import json
import pandas as pd
from apps.batches.wb.common import wb_libs_func
import numpy as np
from datetime import datetime
from apps.batches.wb.common.enums import BatchType

new_keys_list = ['company_about', 'company_address', 'closed', 'founded', 'owner'
    , 'spirit_stills', 'status', 'specialists', 'capacity_per_year', 'collection', 'wishlist',
                 'wb_ranking', 'wash_stills', 'website', 'views']  # 증류소 상세 정보에서 수집할 컬럼 리스트


def extract_distillery_id(table: pd.Series) -> int or None:  # fusion 가능
    try:
        return table.link.split('/')[-2]  # 증류소 id 값 추출
    except IndexError:  # link값이 없는경우 null 반환
        return None


def divide_capacity_with_per_year_and_unit(table: pd.Series) -> [int, str]:  # fusion 가능
    try:
        split_data = table.capacity_per_year.split(' ')
        return split_data[0], split_data[1]  # capacity_per_year : 65000, capacity_per_year_unit : Liters로 분리
    except AttributeError:  # capacity_per_year 값이 없는경우
        return None, None  # null, null로 반환


def reformat_specialists(table: pd.Series) -> dict or None:
    try:
        specialists_dict = eval(table.specialists)  # 스페셜 리스트 형태 dict로 변환
        specialists_name = list(specialists_dict.keys())  # 스페셜 리스트 명 추출
        specialists_link = list(specialists_dict.values())  # 스페셜 리스트 링크 추출
        return {'specialist': specialists_name, 'specialist_link': specialists_link}  # 저장해야할 스페셜 리스트 포맷 반환

    except TypeError:  # 변환해야할 dict가 없을때
        return None  # null반환


def extract_closed_date(table: pd.Series) -> datetime or None:
    datetime_format = "%d.%m.%Y"
    try:
        datetime_result = datetime.strptime(table.closed, datetime_format)
        return datetime_result.strftime("%Y-%m-%d")
    except TypeError:
        return None
    except ValueError:
        pass


def extract_founded_date(table: pd.Series) -> datetime or None:
    datetime_format = "%d.%m.%Y"
    try:
        datetime_result = datetime.strptime(table.founded, datetime_format)
        return datetime_result.strftime("%Y-%m-%d")
    except TypeError:
        return None


def read_raw_csv_files() -> [pd.DataFrame, pd.DataFrame]:
    current_date = wb_libs_func.get_current_date()
    distillery_detail_data = pd.read_csv(
        f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{current_date}/csv/detail/{BatchType.DISTILLERY_DETAIL.value}.csv')
    distillery_summary_data = pd.read_csv(
        f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{current_date}/csv/pre/{BatchType.DISTILLERY_PRE.value}.csv')
    return [distillery_detail_data, distillery_summary_data]


def transform_raw_to_wb_distillery(batch_id: str = None) -> [list, dict]:
    """
        transform_raw_to_wb_distillery
            Note:
                수집된 증류소 정보를 병합 및 전처리 를 진행하는 함수
    """
    # 수집된 파일 가져오기 : 파일 주소가 아닌 파라미터로 넘기는게 어떤지...?
    [distillery_detail_data, distillery_summary_data] = read_raw_csv_files()

    distillery_detail_data_remove_columns = distillery_detail_data.loc[:, new_keys_list]  # 불필요한 컬럼 제거

    current_datetime = wb_libs_func.get_current_datetime()

    result_df = pd.merge(distillery_summary_data,
                         distillery_detail_data_remove_columns,  # 증류소 (사전 + 상세) 병합 하기 사전 기준으로 합치기
                         how='left',
                         left_index=True,
                         right_index=True)
    result_df['wb_distillery_id'] = result_df.apply(extract_distillery_id, axis=1)  # 증류소 id 처리
    result_df[['capacity_per_year', 'capacity_per_year_unit']] = result_df.apply(divide_capacity_with_per_year_and_unit,
                                                                                 axis=1,
                                                                                 result_type='expand')  # 한해 생산량 전처리
    result_df['closed'] = result_df.apply(extract_closed_date, axis=1)  # 스페셜리스트 처리
    result_df['founded'] = result_df.apply(extract_founded_date, axis=1)  # 스페셜리스트 처리
    result_df['specialists'] = result_df.apply(reformat_specialists, axis=1)  # 스페셜리스트 처리
    result_df['batchedAt'] = current_datetime
    result_df['batchId'] = batch_id

    result_df = result_df[
        [
            'wb_distillery_id',
            'distillery_name',
            'whiskies',
            'votes',
            'rating',
            'link',
            'company_address',
            'closed',
            'country',
            'founded',
            'wash_stills',
            'owner',
            'spirit_stills',
            'status',
            'views',
            'wb_ranking',
            'website',
            'batchedAt',
            'batchId'
        ]
    ]

    result_df.rename(
        columns={
            'wb_distillery_id': 'wbId',
            'distillery_name': 'name',
            'whiskies': 'whiskyCount',
            'votes': 'voteCount',
            'link': 'wbLink',
            'website': 'link',
            'spirit_stills': 'spiritStills',
            'views': 'viewCount',
            'wb_ranking': 'wbRanking',
            'wash_stills': 'washStills',
            'company_address': 'address'
        },
        inplace=True
    )

    result_df = result_df.replace({np.nan: None})  # json으로 저장하기 위해 np.nan -> null로 변환
    result_df_list = []
    for result_index in range(len(result_df)):
        result_df_list.append({
            'id': str(uuid.uuid5(uuid.NAMESPACE_URL, result_df.wbLink[result_index])),
            # 네임 스페이스 UUID와 이름의 SHA-1 해시에서 UUID를 생성합니다.
            'createdAt': current_datetime,
            'creator': None,
            'modifiedAt': current_datetime,
            'modifier': None,
            'name': result_df.name[result_index],
            'country': result_df.country[result_index],
            'link': result_df.link[result_index],
            'tasteFeature': None,  # 보류
            'wbId': result_df.wbId[result_index],
            'wbDistillery': json.loads(result_df.loc[result_index, :].to_json()),
        })
    return result_df_list, json.loads(result_df.to_json())
