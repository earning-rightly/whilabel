import pandas
import pandas as pd
import numpy as np
from apps.batches.wb.common import wb_libs_func
import json
import uuid
from apps.batches.wb.common.enums import BatchType


def extract_brand_id(table: pd.Series) -> int or None:  # fusion 가능
    try:
        return table.link.split('/')[-2]  # 브랜드 id 값 추출
    except IndexError:  # link값이 없는경우 null 반환
        return None


def read_raw_csv_files() -> [pd.DataFrame, pd.DataFrame]:
    current_date = wb_libs_func.get_current_date()
    brand_detail_data = pd.read_csv(
        f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{current_date}/csv/detail/{BatchType.BRAND_DETAIL.value}.csv'
    )
    brand_summary_data = pd.read_csv(
        f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{current_date}/csv/pre/{BatchType.BRAND_PRE.value}.csv'
    )
    return brand_detail_data, brand_summary_data


def filter_unused_fields(df: pandas.DataFrame) -> pd.DataFrame:
    # 브랜드 상세 정보에서 수집할 컬럼 리스트
    field_list = [
        'website',
        'region'
    ]
    return df.loc[:, field_list]


def transform_raw_to_wb_brand(batch_id: str = None) -> [list, dict]:
    """
        replace_extracted_data_with_wb_brand_formmat

            Note:
                수집된 브랜드 정보를 병합 및 전처리 를 진행하는 함수
    """
    # 수집된 파일 가져오기 : 파일 주소가 아닌 파라미터로 넘기는게 어떤지...?
    brand_detail_data, brand_summary_data = read_raw_csv_files()

    current_datetime = wb_libs_func.get_current_datetime()

    # 브랜드 (사전 + 상세) 병합 하기 사전 기준으로 합치기
    result_df = pd.merge(
        brand_summary_data,
        filter_unused_fields(brand_detail_data),
        how='left',
        left_index=True,
        right_index=True)

    result_df['wb_brand_id'] = result_df.apply(extract_brand_id, axis=1)  # 브랜드 id 처리
    result_df['batchedAt'] = current_datetime
    result_df['batchId'] = batch_id
    # 병합된 데이터 프레임에서 불필요한컬럼제거
    result_df = result_df[
        [
            'wb_brand_id',
            'brand_name',
            'country',
            'website',
            'whiskies',
            'votes',
            'rating',
            'link',
            'batchedAt',
            'batchId'
        ]
    ]

    result_df.rename(
        columns={
            'wb_brand_id': 'wbId',
            'brand_name': 'name',
            'whiskies': 'whiskyCount',
            'votes': 'voteCount',
            'link': 'wbLink',
            'website': 'link'},
        inplace=True
    )

    result_df = result_df.replace({np.nan: None})  # json으로 저장하기 위해 np.nan -> null로 변환
    result_df_list = []
    for result_index in range(len(result_df)):
        result_df_list.append({
            'id': str(uuid.uuid5(uuid.NAMESPACE_URL, result_df.wbLink[result_index])),
            # 네임 스페이스 UUID와 이름의 SHA-1 해시에서 UUID를 생성합니다.,
            'createdAt': current_datetime,
            'creator': None,
            'modifiedAt': current_datetime,
            'modifier': None,
            'name': result_df.name[result_index],
            'country': result_df.country[result_index],
            'link': result_df.link[result_index],
            'wbId': result_df.wbId[result_index],
            'wbBrand': json.loads(result_df.loc[result_index, :].to_json())
        })

    return result_df_list, json.loads(result_df.to_json())
