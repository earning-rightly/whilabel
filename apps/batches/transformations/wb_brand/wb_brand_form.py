import pandas as pd
import numpy as np
from batches.wb_libs import wb_libs_func

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


def replace_extracted_data_with_wb_brand_formmat() -> dict:
    """
        replace_extracted_data_with_wb_brand_formmat

            Note:
                수집된 브랜드 정보를 병합 및 전처리 를 진행하는 함수
    """
    # 수집된 파일 가져오기 : 파일 주소가 아닌 파라미터로 넘기는게 어떤지...?
    brand_detail_data = pd.read_csv(
        "/Users/choejong-won/PycharmProjects/whiskey_search/batches/results/" + wb_libs_func.extract_time()[
            0] + '/csv/detail/wb_brand_collector_detail.csv')
    brand_summary_data = pd.read_csv(
        "/Users/choejong-won/PycharmProjects/whiskey_search/batches/results/" + wb_libs_func.extract_time()[
            0] + '/csv/pre/wb_brand_collector_pre.csv')

    brand_detail_data_remove_columns = brand_detail_data.loc[:, new_keys_list]  # 불필요한 컬럼 제거
    result_df = pd.merge(brand_summary_data, brand_detail_data_remove_columns,  # 브랜드 (사전 + 상세) 병합 하기 사전 기준으로 합치기
                         how='left',
                         left_index=True,
                         right_index=True)
    result_df['wb_brand_id'] = result_df.apply(make_brand_id, axis=1)  # 브랜드 id 처리
    result_df = result_df[['wb_brand_id', 'brand_name', 'country', 'website', 'region', 'whiskies', 'votes', 'rating',
                           'link']]  # 병합된 데이터 프레임에서 불필요한컬럼제거
    result_df = result_df.replace({np.nan: None})  # json으로 저장하기 위해 np.nan -> null로 변환

    return result_df.to_json()


'''json
"wb_brand": {  // 브랜드 상세정보 테이블
	{
        "wb_brand_id"       : int,                  // wb 브랜드 id - 81707
		"brand_name"        : string,               // 브랜드명 - Aberlour
		"country"           : string,               // 나라 - Scotland
 		"website"           : string,               // 브랜드 공식사이트 - aberlour.com
 		"region"            : string,               // 지역 - Lowlands
		"whiskies"          : int,                  // 위스키 수 - 3
		"votes"             : int,                  // 투표 수 - 143
		"rating"            : float,                // 점수 - 35.03
		"link"              : string                // wb 브랜드 url - https://www.whiskybase.com/whiskies/brand/81707
	},
'''
