import pandas as pd
import numpy as np
import json
from apps.batches.wb.common.enums import BatchType
import uuid
import os


def merged_whisky_data_preprocess() -> [list, dict]:
    """
        replace_extracted_data_with_wb_whisky_formmat

            Note:
                수집된 bottler 정보를 병합 및 전처리 를 진행하는 함수

            Returns:
                [list, dict]
    """
    pd.set_option('mode.chained_assignment', None)  # <==== 경고를 끈다

    dir = '/Users/choejong-won/PycharmProjects/whilabel/apps/batches/results'

    files = os.listdir(dir)

    whisky_table = []
    for file in reversed(files):
        if len(whisky_table) != 3:
            try:
                whisky_table.append(pd.read_csv(f'results/{file}/csv/transformation/{BatchType.BOTTLER_WHISKY_DETAIL.value}.csv'))

            except FileNotFoundError:
                pass

            try:
                whisky_table.append(pd.read_csv(f'results/{file}/csv/transformation/{BatchType.BRAND_WHISKY_DETAIL.value}.csv'))

            except FileNotFoundError:
                pass

            try:
                whisky_table.append(pd.read_csv(f'results/{file}/csv/transformation/{BatchType.DISTILLERY_WHISKY_DETAIL.value}.csv'))

            except FileNotFoundError:
                pass

        elif len(whisky_table) == 3:
            break

    whisky_data = pd.concat(whisky_table, ignore_index=True)
    whisky_data = whisky_data.replace({np.nan: None})
    whisky_data_pre_process_transform_barcoode = whisky_data[whisky_data.barcode.isna() == False]
    barcode_list = list(set(list(whisky_data_pre_process_transform_barcoode.barcode)))

    for barcode in barcode_list:
        if len(whisky_data_pre_process_transform_barcoode[
                   whisky_data_pre_process_transform_barcoode.barcode == barcode]) > 1:  # 바코드가 겹치는 경우가 여러개인경우
            extract_data = whisky_data_pre_process_transform_barcoode[
                whisky_data_pre_process_transform_barcoode.barcode == barcode]

            if len(extract_data[extract_data.voteCount == extract_data.voteCount.max()].index) > 1:  # 가장 큰 경우가 1개이상인경우
                whisky_data_pre_process_transform_barcoode.drop(
                    extract_data[extract_data.index != extract_data.voteCount.max()].index[0], axis=0, inplace=True)

            elif len(extract_data[extract_data.voteCount == extract_data.voteCount.max()].index) == 1:
                whisky_data_pre_process_transform_barcoode.drop(
                    extract_data[extract_data.index != extract_data.voteCount.max()].index[0], axis=0, inplace=True)
            else:  # votes가 집계가 안된거는경우?
                pass

    result_df_list = []   #fire store에 저장하기 위해 각 로우별로 json화 시켜 라스트에 저장

    whisky_data_pre_process_transform_barcoode = whisky_data_pre_process_transform_barcoode.astype({'wbID': 'str'})
    whisky_data_pre_process_transform_barcoode.reset_index(drop=True,inplace=True)
    for result_index in range(len(whisky_data_pre_process_transform_barcoode)):
        result_df_list.append({
            'id': str(uuid.uuid5(uuid.NAMESPACE_URL, whisky_data_pre_process_transform_barcoode.wbLink[result_index])),
            'createdAt': None,
            'creator': None,
            'modifiedAt': None,
            'modifier': None,
            'wbId': whisky_data_pre_process_transform_barcoode.wbID[result_index],
            'name': whisky_data_pre_process_transform_barcoode.name[result_index],
            'wbWhisky': json.loads(whisky_data_pre_process_transform_barcoode.loc[result_index, :].to_json())
        })

    return result_df_list, json.loads(whisky_data_pre_process_transform_barcoode.to_json())  #[파이어베이스 저장포맷,  (csv, json) 저장포맷]