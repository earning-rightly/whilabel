import pandas as pd
import numpy as np
from apps.batches.wb_libs import wb_libs_func
import json
import uuid
from apps.batches.wb_libs.enums import BatchType

new_keys_list = ['website', 'region']  # 증류소 상세 정보에서 수집할 컬럼 리스트


def make_brand_id(table: pd.Series) -> int:  # fusion 가능
    """
        make_brand_id
            Args:
               table : 변경해야할 판다스 시리스(한 행)

            Note:
                link주소값에서 브랜드 id 값을 추출하여 해당 값 반환
    """
    try:
        return table.link.split('/')[-2]  # 브랜드 id 값 추출

    except IndexError:  # link값이 없는경우 null 반환
        return None

def replace_extracted_data_with_wb_brand_formmat(batchId : str = None) -> [list, dict]:
    """
        replace_extracted_data_with_wb_brand_formmat

            Note:
                수집된 브랜드 정보를 병합 및 전처리 를 진행하는 함수
    """
    # 수집된 파일 가져오기 : 파일 주소가 아닌 파라미터로 넘기는게 어떤지...?
    brand_detail_data = pd.read_csv(f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{wb_libs_func.extract_time()[0]}/csv/detail/{BatchType.BRAND_DETAIL.value}.csv')
    brand_summary_data = pd.read_csv(f'/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results/{wb_libs_func.extract_time()[0]}/csv/pre/{BatchType.BRAND_PRE.value}.csv')

    brand_detail_data_remove_columns = brand_detail_data.loc[:, new_keys_list]  # 불필요한 컬럼 제거
    result_df = pd.merge(brand_summary_data, brand_detail_data_remove_columns,  # 브랜드 (사전 + 상세) 병합 하기 사전 기준으로 합치기
                         how='left',
                         left_index=True,
                         right_index=True)

    result_df['wb_brand_id'] = result_df.apply(make_brand_id, axis=1)  # 브랜드 id 처리
    result_df['batchedAt'] = wb_libs_func.extract_time()[1]
    result_df['batchId'] = batchId
    result_df = result_df[['wb_brand_id', 'brand_name', 'country', 'website', 'whiskies', 'votes', 'rating',
                           'link','batchedAt','batchId']]  # 병합된 데이터 프레임에서 불필요한컬럼제거

    result_df.rename(columns={'wb_brand_id': 'wbId', 'brand_name': 'name', 'whiskies': 'whiskyCount',
                                'votes': 'voteCount','link' : 'wbLink', 'website' : 'link'}, inplace=True)

    result_df = result_df.replace({np.nan: None})  # json으로 저장하기 위해 np.nan -> null로 변환
    result_df_list = []
    for result_index in range(len(result_df)):
        result_df_list.append({
        'id': str(uuid.uuid5(uuid.NAMESPACE_URL, result_df.wbLink[result_index])), #네임 스페이스 UUID와 이름의 SHA-1 해시에서 UUID를 생성합니다.,
        'createdAt' : wb_libs_func.extract_time()[1],
        'creator' : None,
        'modifiedAt' : wb_libs_func.extract_time()[1],
        'modifier' : None,
        'name' : result_df.name[result_index],
        'country' : result_df.country[result_index],
        'link' : result_df.link[result_index],
        'wbId': result_df.wbId[result_index],
        'wbBrand' : json.loads(result_df.loc[result_index,:].to_json())
    })
    return result_df_list, json.loads(result_df.to_json())