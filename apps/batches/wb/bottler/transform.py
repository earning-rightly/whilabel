import pandas as pd
import numpy as np
from datetime import datetime
import json
import uuid
from apps.batches.wb.common.enums import BatchType
from apps.batches.wb.common import wb_libs_func


def extract_bottler_id(table: pd.Series) -> int or None:
    """
    extract_bottler_id
        Args:
            table: pandas.Series
                데이터가 담긴 pandas Series 객체
        Returns:
            int or None:
                증류소 ID를 추출하거나, 없을 경우 None 반환
        Notes:
            증류소 ID 값을 추출하는 함수
    """
    try:
        return table.link.split('/')[-2]  # 증류소 id 값 추출
    except IndexError:  # link값이 없는 경우 None 반환
        return None


def reformat_specialists(table: pd.Series) -> dict or None:
    """
    reformat_specialists
        Args:
            table: pandas.Series
                데이터가 담긴 pandas Series 객체
        Returns:
            dict or None:
                스페셜 리스트를 변환한 딕셔너리를 반환하거나, 없을 경우 None 반환
        Notes:
            스페셜 리스트를 딕셔너리로 변환하는 함수
    """
    try:
        specialists_dict = eval(table.specialists)  # 스페셜 리스트를 형태를 dict로 변환
        specialists_name = list(specialists_dict.keys())  # 스페셜 리스트 명 추출
        specialists_link = list(specialists_dict.values())  # 스페셜 리스트 링크 추출
        return {'specialist': specialists_name, 'specialist_link': specialists_link}  # 저장해야할 스페셜 리스트 포맷 반환

    except TypeError:  # 변환해야할 dict가 없을때
        return None  # None 반환


def extract_closed_date(table: pd.Series) -> datetime or None:
    """
    extract_closed_date
        Args:
            table: pandas.Series
                데이터가 담긴 pandas Series 객체
        Returns:
            datetime or None:
                날짜 값을 추출하거나, 없을 경우 None 반환
        Notes:
            날짜 값을 추출하고 포맷을 변경하여 반환하는 함수
    """
    datetime_format = "%d.%m.%Y"
    try:
        datetime_result = datetime.strptime(table.closed, datetime_format)
        return datetime_result.strftime("%Y-%m-%d")
    except TypeError:
        return None


def extract_founded_date(table: pd.Series) -> datetime or None:
    """
    extract_founded_date
        Args:
            table: pandas.Series
                데이터가 담긴 pandas Series 객체
        Returns:
            datetime or None:
                날짜 값을 추출하거나, 없을 경우 None 반환
        Notes:
            날짜 값을 추출하고 포맷을 변경하여 반환하는 함수
    """
    datetime_format = "%d.%m.%Y"
    try:
        datetime_result = datetime.strptime(table.founded, datetime_format)
        return datetime_result.strftime("%Y-%m-%d")
    except TypeError:
        return None


def divide_capacity_with_per_year_and_unit(table: pd.Series) -> [int, str]:
    """
    divide_capacity_with_per_year_and_unit
        Args:
            table: pandas.Series
                데이터가 담긴 pandas Series 객체
        Returns:
            [int, str]:
                용량과 단위를 나눈 값을 반환
        Notes:
            capacity_per_year 값을 용량과 단위로 분리하여 반환하는 함수
    """
    try:
        # capacity_per_year : 65000, capacity_per_year_unit : Liters로 분리
        split_data = table.capacity_per_year.split(' ')
        return split_data[0], split_data[1]

    except AttributeError:  # capacity_per_year 값이 없는 경우
        return None, None  # None, None로 반환


def read_raw_csv_file() -> [pd.DataFrame, pd.DataFrame]:
    current_date = wb_libs_func.get_current_date()
    bottler_detail_data = pd.read_csv(
        f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{current_date}/csv/detail/{BatchType.BOTTLER_DETAIL.value}.csv'
    )
    bottler_summary_data = pd.read_csv(
        f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{current_date}/csv/pre/{BatchType.BOTTLER_PRE.value}.csv'
    )
    return bottler_detail_data, bottler_summary_data


def filter_unused_fields(df: pd.DataFrame) -> pd.DataFrame:
    # 보틀러 상세 정보에서 수집할 컬럼 리스트
    field_list = [
        'company_about',
        'company_address',
        'closed',
        'collection',
        'founded',
        'abbreviation',
        'specialists',
        'status',
        'wb_ranking',
        'website',
        'views'
    ]
    return df.loc[:, field_list]


def transform_raw_to_wb_bottler(batch_id: str = None) -> [list, dict]:
    # 수집된 파일 가져오기 : 파일 주소가 아닌 파라미터로 넘기는게 어떤지...?
    bottler_detail_data, bottler_summary_data = read_raw_csv_file()

    current_datetime = wb_libs_func.get_current_datetime()

    # 보틀러 (사전 + 상세) 병합 하기 사전 기준으로 합치기
    result_df = pd.merge(
        bottler_summary_data,
        filter_unused_fields(bottler_detail_data),
        how='left',
        left_index=True,
        right_index=True
    )
    result_df['wb_bottler_id'] = result_df.apply(extract_bottler_id, axis=1)  # 보틀러 id 처리
    result_df['specialists'] = result_df.apply(reformat_specialists, axis=1)  # 스페셜리스트 처리
    result_df['closed'] = result_df.apply(extract_closed_date, axis=1)
    result_df['founded'] = result_df.apply(extract_founded_date, axis=1)
    result_df['batchedAt'] = current_datetime
    result_df['batchId'] = batch_id

    result_df = result_df[
        [
            'wb_bottler_id',
            'bottler_name',
            'whiskies',
            'votes',
            'rating',
            'link',
            'company_address',
            'closed',
            'country',
            'founded',
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
            'wb_bottler_id': 'wbId',
            'bottler_name': 'name',
            'whiskies': 'whiskyCount',
            'votes': 'voteCount',
            'link': 'wbLink',
            'website': 'link',
            'views': 'viewCount',
            'wb_ranking': 'wbRanking',
            'company_address': 'address'
        },
        inplace=True
    )

    result_df = result_df.replace({np.nan: None})  # json으로 저장하기 위해 np.nan -> null로 변환
    result_df_list = []
    for result_index in range(len(result_df)):
        result_df_list.append({
            # 네임 스페이스 UUID와 이름의 SHA-1 해시에서 UUID를 생성합니다.
            'id': str(uuid.uuid5(uuid.NAMESPACE_URL, result_df.wbLink[result_index])),
            'createdAt': current_datetime,
            'creator': None,
            'modifiedAt': current_datetime,
            'modifier': None,
            'name': result_df.name[result_index],
            'country': result_df.country[result_index],
            'link': result_df.link[result_index],
            'wbId': result_df.wbId[result_index],
            'wbBottler': json.loads(result_df.loc[result_index, :].to_json()),
        })

    return result_df_list, json.loads(result_df.to_json())
