from typing import List, Union, Any

import pandas as pd
from batches.wb_libs import wb_libs_func
import numpy as np
from datetime import datetime

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


def replace_extracted_data_with_wb_distillery_formmat() -> list[Union[list[Union[str, Any]], Any]]:
    """
        replace_extracted_data_with_wb_distillery_formmat

            Note:
                수집된 증류소 정보를 병합 및 전처리 를 진행하는 함수
    """
    # 수집된 파일 가져오기 : 파일 주소가 아닌 파라미터로 넘기는게 어떤지...?
    distillery_detail_data = pd.read_csv(
        "/Users/choejong-won/PycharmProjects/whiskey_search/batches/results/" + wb_libs_func.extract_time()[
            0] + '/csv/detail/wb_bottler_collector_detail.csv')
    distillery_summary_data = pd.read_csv(
        "/Users/choejong-won/PycharmProjects/whiskey_search/batches/results/" + wb_libs_func.extract_time()[
            0] + '/csv/pre/wb_bottler_collector_pre.csv')

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
    result_df['batchId'] = 'wb_distillery'
    '''
    result_df = result_df[['wb_distillery_id', 'distillery_name', 'website', 'country', 'company_address',
                           'batchedAt', 'batchId', 'whiskies', 'votes', 'rating', 'link', 'closed', 'founded',
                           'owner', 'spirit_stills', 'status', 'views', 'wb_ranking', 'wash_stills']]  # 병합된 데이터 프레임에서 불필요한컬럼제거
    '''
    # 제거 대상 specialists,capacity_per_year,company_about,collection,wishlist

    result_df = result_df[['wb_distillery_id', 'distillery_name', 'whiskies', 'votes', 'rating', 'link', 'company_about',
         'company_address', 'capacity_per_year', 'capacity_per_year_unit', 'closed', 'collection', 'country', 'founded',
         'owner', 'specialists'
            , 'spirit_stills', 'status', 'views', 'wb_ranking', 'website', 'wishlist']]

    '''
    result_df.columns = ['wb_id', 'name', 'link', 'country', 'address', 'batched_at', 'batch_id',
                         'whisky_count', 'vote_count', 'rating', 'wb_link', 'closed', 'founded', 'owner',
                         'spirit_stills', 'status', 'view_count', 'wb_ranking', 'wash_stills']
    '''
    result_df = result_df.replace({np.nan: None})  # json으로 저장하기 위해 np.nan -> null로 변환
    return result_df.to_json()


'''json
['wb_distillery_id', 'distillery_name', 'whiskies', 'votes', 'rating', 'link', 'company_about',
         'company_address', 'capacity_per_year', 'capacity_per_year_unit', 'closed', 'collection', 'country', 'founded',
         'owner', 'specialists'
            , 'spirit_stills', 'status', 'views', 'wb_ranking', 'website', 'wishlist']

{
	"wb_distillery": {  // 증류소 상세정보 테이블
        add"distillery_id"     : int,                 // wb 증류소 id - 90642
		0"distillery_name"   : string,              // 위스키 이름 - Aberlour
		0"whiskies"          : int,                 // 위스키 갯수 - 1325
		0"votes"             : int,                 // 투표 수 - 55
    	0"rating"            : float,               // 투표 점수 - 23.4
    	0"link"              : String,              // wb 증류소 페이지 url - https://www.whiskybase.com/whiskies/distillery/90642
		0"company_about"     : string,              // 증류소 정보 - The distillery Aberlour has been found 1879 ...
		0"company_address"   : stirng,              // 증류소 주소 - AB3 9PJ Aberlour, Banffshire Speyside
		0"capacity_per_year" :string,               // 연간 생산량 3500000 Liters
		?"closed"            : ymdDateString,       // Close 된 날짜(존재하는 경우) - 230802
		"collection"        : int,                 // 뭔지 모르겠음.. - 57034
		0"country"           : string,              // 나라 - Scotland
		?"founded"           : date,                // 증류소 설립일 - 01.01.1879
		0"owner"             : string,              // 증류소 주인 - Pernod Ricard
		"specialists" : {
			"specialist"      : string,             // 추천한 wb 스페셜리스트 이름 - Norbert
			"specialist_link" : stirng              // 추천한 wb 스페셜리스트 url - https://www.whiskybase.com/profile/norbs
        },
		0"spirit_stills"     : int,                  // 증류 횟수 - 2
		0"status"            : string,               // 상태 - Active Unknown Mothballed Closed Silent
		0"views"             : int,                  // 노출 수 - 176085
		0"wb_ranking"        : char or string,       // wb 랭크 - A to G
		0"wash_stills"       : int,                  // 증류 횟수 - 2
		0"website"           : string,               // 증류소 공식 url - aberlour.com
        0"wishlist"          : int,                  // 위시리스트에 담긴 수 - 3
	},
'''
