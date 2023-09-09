from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_distillery_collector.wb_distillery_collector_detail import wb_distillery_collector_detail_func
from apps.batches.wb_distillery_collector.wb_distillery_collector_detail.wb_distillery_collector_detail_values import \
    distillery_collect_detail_scrap as detail_scrap
from apps.batches.transformations.wb_distillery.wb_distillery_form import \
    replace_extracted_data_with_wb_distillery_formmat
from apps.batches.wb_libs.enums import CollectionName, BatchType, BatchExecution
from apps.batches.wb_libs.lib_firebase import save_to_firebase
from apps.batches.wb_libs.constants import detail_field_map


def distillery_detail_executions(batch_type: BatchType, batch_execution: BatchExecution):
    """
        distillery_detail_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 증류소 상세정보 스케줄링 함수
    """

    scrap_dict = wb_libs_func.initialize_dict(detail_field_map['wb_distillery_collect_detail'])

    current_date = wb_libs_func.get_current_date()

    wb_distillery_collector_detail_func.collect(batch_type.DISTILLERY_PRE.value, current_date,
                                                scrap_dict)  # 증류소 상세정보 수집 함수 호출
    wb_distillery_collector_detail_func.collect(batch_type.DISTILLERY_PRE.value, current_date,
                                                scrap_dict)  # 증류소 상세정보 수집 함수 호출

    # save as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, batch_type.value)

    transform_result_list, transform_result_dict = (replace_extracted_data_with_wb_distillery_formmat
                                                    (batchId=batch_execution.value))

    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, batch_type.value)

    save_to_firebase(CollectionName.DISTILLERY, transform_result_list, 'wbId', 'wbDistillery')