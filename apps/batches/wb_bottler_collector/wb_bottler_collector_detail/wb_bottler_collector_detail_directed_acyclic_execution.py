from apps.batches.wb.common import wb_libs_func
from apps.batches.wb_bottler_collector.wb_bottler_collector_detail import wb_bottler_collector_detail_func
from apps.batches.transformations.wb_bottler.wb_bottler_form import \
    replace_extracted_data_with_wb_bottler_formmat
from apps.batches.wb.common.enums import BatchType, CollectionName, BatchExecution
from apps.batches.libs.lib_firebase.firebase_funcs import save_to_firebase
from apps.batches.wb.common.constants import field_map


def bottler_detail_executions(batch_type: BatchType, batch_execution: BatchExecution):
    """
        distillery_detail_executions.
            Args:
            Note:
                scrap_main 에서 증류소 상세정보 스케줄링 함수
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_bottler_collect_detail'])

    current_date = wb_libs_func.get_current_date()

    wb_bottler_collector_detail_func.collect(BatchType.BOTTER_PRE.value, current_date,
                                             scrap_dict)  # 증류소 상세정보 수집 함수 호출

    # save as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, batch_type.value)

    transform_result_list, transform_result_dict = replace_extracted_data_with_wb_bottler_formmat(
        batchId=batch_execution.value)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, batch_type.value)

    save_to_firebase(CollectionName.BOTTLER, transform_result_list, 'wbId', 'wbBottler')