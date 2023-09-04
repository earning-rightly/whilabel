import uuid

import json
import pandas as pd
from apps.batches.wb_libs import wb_libs_func
import numpy as np
from datetime import datetime
from apps.batches.wb_libs.enums import BatchType

new_keys_list = ['company_about', 'company_address', 'closed', 'founded', 'owner'
    , 'spirit_stills', 'status','specialists','capacity_per_year','collection','wishlist',
                 'wb_ranking', 'wash_stills', 'website', 'views']  # 증류소 상세 정보에서 수집할 컬럼 리스트


def make_distillery_id(table: pd.Series) -> int:  # fusion 가능
    """
        make_distillery_id
            Args:
               table : 변경해야할 판다스 시리스(한 행)

            Note:
                link주소값에서 증류소 id 값을 추출하여 해당 값 반환
    """
    try:
        return table.link.split('/')[-2]  # 증류소 id 값 추출

    except IndexError:  # link값이 없는경우 null 반환
        return None


def trans_capacity_per_year(table: pd.Series) -> [int, str]:  # fusion 가능
    """
        trans_capacity_per_year
            Args:
               table : 변경해야할 판다스 시리스(한 행)

            Note:
                한해 생산량 65000 Liters로 표기 되어있어
                capacity_per_year : 65000, capacity_per_year_unit : Liters로 분리
    """
    try:
        split_data = table.capacity_per_year.split(' ')
        return split_data[0], split_data[1]  # capacity_per_year : 65000, capacity_per_year_unit : Liters로 분리

    except AttributeError:  # capacity_per_year 값이 없는경우
        return None, None  # null, null로 반환


def change_specialists_format(table: pd.Series) -> dict:
    """
        change_specialists_format
            Args:
               table : 변경해야할 판다스 시리스(한 행)

            Note:
                수집된 스페셜 리스트 포맷을 변환
    """
    try:
        specialists_dict = eval(table.specialists)  # 스페셜 리스트 형태 dict로 변환
        specialists_name = list(specialists_dict.keys())  # 스페셜 리스트 명 추출
        specialists_link = list(specialists_dict.values())  # 스페셜 리스트 링크 추출
        return {'specialist': specialists_name, 'specialist_link': specialists_link}  # 저장해야할 스페셜 리스트 포맷 반환

    except TypeError:  # 변환해야할 dict가 없을때
        return None  # null반환


def closed_change_datetime_form(table: pd.Series) -> datetime or None:
    datetime_format = "%d.%m.%Y"
    try:
        datetime_result = datetime.strptime(table.closed, datetime_format)
        return datetime_result.strftime("%Y-%m-%d")

    except TypeError:
        return None

    except ValueError:
        pass


def founded_change_datetime_form(table: pd.Series) -> datetime or None:
    datetime_format = "%d.%m.%Y"
    try:
        datetime_result = datetime.strptime(table.founded, datetime_format)
        return datetime_result.strftime("%Y-%m-%d")

    except TypeError:
        return None


def replace_extracted_data_with_wb_distillery_formmat(batchId : str = None) -> [list, dict]:
    """
        replace_extracted_data_with_wb_distillery_formmat

            Note:
                수집된 증류소 정보를 병합 및 전처리 를 진행하는 함수
    """
    # 수집된 파일 가져오기 : 파일 주소가 아닌 파라미터로 넘기는게 어떤지...?
    distillery_detail_data = pd.read_csv(f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{wb_libs_func.extract_time()[0]}/csv/detail/{BatchType.DISTILLERY_DETAIL.value}.csv')
    distillery_summary_data = pd.read_csv(f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{wb_libs_func.extract_time()[0]}/csv/pre/{BatchType.DISTILLERY_PRE.value}.csv')

    distillery_detail_data_remove_columns = distillery_detail_data.loc[:, new_keys_list]  # 불필요한 컬럼 제거
    result_df = pd.merge(distillery_summary_data,
                         distillery_detail_data_remove_columns,  # 증류소 (사전 + 상세) 병합 하기 사전 기준으로 합치기
                         how='left',
                         left_index=True,
                         right_index=True)
    result_df['wb_distillery_id'] = result_df.apply(make_distillery_id, axis=1)  # 증류소 id 처리
    result_df[['capacity_per_year', 'capacity_per_year_unit']] = result_df.apply(trans_capacity_per_year, axis=1,   result_type='expand')  # 한해 생산량 전처리
    result_df['closed'] = result_df.apply(closed_change_datetime_form, axis=1)  # 스페셜리스트 처리
    result_df['founded'] = result_df.apply(founded_change_datetime_form, axis=1)  # 스페셜리스트 처리
    result_df['specialists'] = result_df.apply(change_specialists_format, axis=1)  # 스페셜리스트 처리
    result_df['batchedAt'] = wb_libs_func.extract_time()[1]
    result_df['batchId'] = batchId

    result_df = result_df[['wb_distillery_id', 'distillery_name', 'whiskies', 'votes', 'rating', 'link',
                            'company_address', 'closed', 'country', 'founded','wash_stills','owner', 'spirit_stills', 'status',
                           'views', 'wb_ranking', 'website' ,'batchedAt','batchId']]

    result_df.rename(columns={'wb_distillery_id': 'wbId', 'distillery_name': 'name', 'whiskies': 'whiskyCount',
                              'votes': 'voteCount','link' : 'wbLink', 'website' : 'link','spirit_stills' : 'spiritStills',
                              'views' : 'viewCount','wb_ranking' :'wbRanking','wash_stills':'washStills','company_address' : 'address'}, inplace=True)

    result_df = result_df.replace({np.nan: None})  # json으로 저장하기 위해 np.nan -> null로 변환
    result_df_list = []
    for result_index in range(len(result_df)):
        result_df_list.append({
            'id': str(uuid.uuid5(uuid.NAMESPACE_URL, result_df.wbLink[result_index])), #네임 스페이스 UUID와 이름의 SHA-1 해시에서 UUID를 생성합니다.,
            'createdAt': wb_libs_func.extract_time()[1],
            'creator': None,
            'modifiedAt': wb_libs_func.extract_time()[1],
            'modifier': None,
            'name': result_df.name[result_index],
            'country': result_df.country[result_index],
            'link': result_df.link[result_index],
            'tasteFeature': None, #보류
            'wbId': result_df.wbId[result_index],
            'wbDistillery': json.loads(result_df.loc[result_index, :].to_json()),


        })
    return result_df_list, json.loads(result_df.to_json())


