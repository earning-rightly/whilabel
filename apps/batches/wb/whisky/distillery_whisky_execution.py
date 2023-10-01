from apps.batches.wb_whisky_collector.wb_whisky_collector_detail import wb_whisky_collector_detail_func
from apps.batches.wb.common import wb_libs_func
from apps.batches.transformations.wb_whisky.wb_whisky_pre_form import replace_extracted_data_with_wb_whisky_format
from apps.batches.wb.common.enums import BatchType, BatchExecution
from apps.batches.wb.common.constants import field_map


def distillery_whisky_execution():
    """
        whisky_detail_distillery_collector_executions.
            Args:
            Note:
                증류소 위스키 수집 및 처리 실행 함수입니다.
    """
    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_whisky_collect_detail'])

    current_date = wb_libs_func.get_current_date()

    """
    증류소 위스키 상세 정보 수집
    """

    wb_whisky_collector_detail_func.collect(BatchType.DISTILLERY_WHISKY_LINK.value, current_date, scrap_dict)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.DISTILLERY_WHISKY_DETAIL.value)

    # save as json file
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.DISTILLERY_WHISKY_DETAIL.value)

    transform_result_dict = replace_extracted_data_with_wb_whisky_format(extract_data=scrap_dict,
                                                                         batchId=BatchType.DISTILLERY_WHISKY.value)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.DISTILLERY_WHISKY.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.DISTILLERY_WHISKY.value)
