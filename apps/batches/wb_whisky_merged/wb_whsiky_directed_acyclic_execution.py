from apps.batches.transformations.wb_whisky.wb_whisky_form import merged_whisky_data_preprocess
from apps.batches.wb_libs.enums import BatchType, CollectionName, BatchExecution
from apps.batches.wb_libs.lib_firebase import save_to_firebase
from apps.batches.wb_libs import wb_libs_func

def merged_whisky_executions(batch_type: BatchType):
    """
        distillery_detail_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 증류소 상세정보 스케줄링 함수
    """

    current_date = wb_libs_func.get_current_date()

    transform_result_list, transform_result_dict = merged_whisky_data_preprocess()

    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, batch_type.value)

    save_to_firebase(CollectionName.WHISKY, transform_result_list, 'wbId', 'wbWhisky')