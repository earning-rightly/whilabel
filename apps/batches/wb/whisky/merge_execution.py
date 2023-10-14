from apps.batches.wb.whisky.merge_process import merged_whisky_data_preprocess
from apps.batches.wb.common.enums import BatchType, CollectionName
from apps.batches.libs.lib_firebase.firebase_funcs import save_to_firebase
from apps.batches.wb.common import wb_libs_func


def merged_whisky_executions():
    """
        distillery_detail_executions.
            Args:
            Note:
                scrap_main 에서 증류소 상세정보 스케줄링 함수
    """

    current_date = wb_libs_func.get_current_date()

    transform_result_list, transform_result_dict = merged_whisky_data_preprocess()

    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.WHISKY_MERGE.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.WHISKY_MERGE.value)

    save_to_firebase(CollectionName.WHISKY, transform_result_list, 'wbId', 'wbWhisky')