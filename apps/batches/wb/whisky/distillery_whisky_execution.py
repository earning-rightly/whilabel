from apps.batches.wb_whisky_collector.wb_whisky_collector_detail import wb_whisky_collector_detail_func
from apps.batches.wb.common import wb_libs_func
from apps.batches.transformations.wb_whisky.wb_whisky_pre_form import replace_extracted_data_with_wb_whisky_format
from apps.batches.wb.common.enums import BatchType, BatchExecution
from apps.batches.wb.common.constants import field_map
from apps.batches.wb_whisky_collector.wb_whisky_collector_link import wb_whisky_collector_link_apply_func


def distillery_whisky_execution():
    """
        whisky_detail_distillery_collector_executions.
            Args:
            Note:
                증류소 위스키 수집 및 처리 실행 함수입니다.
    """

    current_date = wb_libs_func.get_current_date()

    """
    증류소 위스키 링크 수집
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_whisky_link'])


    wb_whisky_collector_link_apply_func.collect(batch_type=BatchType.DISTILLERY_WHISKY_LINK.value,
                                                current_date=current_date,
                                                whisky_link_scrap=scrap_dict)  # 위스키 링크 수집 함수 호출

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    result_df = wb_libs_func.remove_duplicated_link(result_df)  # 위스키 링크 중복 수집 문제 임시방편 해결
    csv_path = f'results/{current_date}/csv/link/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.DISTILLERY_WHISKY_LINK.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/link/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.DISTILLERY_WHISKY_LINK.value)

    """
    증류소 위스키 상세 정보 수집
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_whisky_collect_detail'])

    wb_whisky_collector_detail_func.collect(BatchType.DISTILLERY_WHISKY_LINK.value, current_date, scrap_dict)

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.DISTILLERY_WHISKY_DETAIL.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.DISTILLERY_WHISKY_DETAIL.value)

    transform_result_dict = replace_extracted_data_with_wb_whisky_format(extract_data=scrap_dict,
                                                                         batchId=BatchType.DISTILLERY_WHISKY.value)

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.DISTILLERY_WHISKY.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.DISTILLERY_WHISKY.value)
