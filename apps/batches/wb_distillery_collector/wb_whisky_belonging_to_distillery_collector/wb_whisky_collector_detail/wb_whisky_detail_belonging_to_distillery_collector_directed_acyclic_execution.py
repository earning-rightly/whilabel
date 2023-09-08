from apps.batches.wb_whisky_collector.wb_whisky_collector_detail import wb_whisky_collector_detail_func
from apps.batches.wb_libs import wb_libs_func
from apps.batches.transformations.wb_whisky.wb_whisky_pre_form import replace_extracted_data_with_wb_whisky_format
from apps.batches.wb_libs.enums import BatchType,BatchExecution
from apps.batches.wb_libs.constants import detail_field_map

def whisky_detail_distillery_collector_executions(batch_type : BatchType, batch_id : BatchExecution, scrap_dict: dict):
    """
        whisky_detail_distillery_collector_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 위스키 상세정보 스케줄링 함수
    """
    scrap_dict = wb_libs_func.initialize_dict(detail_field_map['wb_whisky_collect_detail'])

    current_date = wb_libs_func.get_current_date()

    wb_whisky_collector_detail_func.collect(BatchType.DISTILLERY_WHISKY_LINK.value, current_date, scrap_dict)
    
    # save as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, batch_type.value)

    transform_result_dict = replace_extracted_data_with_wb_whisky_format(extract_data=scrap_dict,batchId=batch_id.value)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, batch_type.value)
