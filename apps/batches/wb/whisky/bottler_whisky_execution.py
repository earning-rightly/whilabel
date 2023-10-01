from apps.batches.transformations.wb_whisky.wb_whisky_pre_form import replace_extracted_data_with_wb_whisky_format
from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.constants import field_map
from apps.batches.wb.common.enums import BatchType
from apps.batches.wb_whisky_collector.wb_whisky_collector_detail import wb_whisky_collector_detail_func
from apps.batches.wb_whisky_collector.wb_whisky_collector_link import wb_whisky_collector_link_apply_func


def bottler_whisky_execution():
    """
    bottler_whisky_execution
        Args:
        Notes:
            보틀러 위스키 수집 및 처리 실행 함수입니다.
    """
    current_date = wb_libs_func.get_current_date()

    """
    보틀러 위스키 링크 수집
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_whisky_link'])

    wb_whisky_collector_link_apply_func.collect(batch_type=BatchType.BOTTLER_WHISKY_LINK.value,
                                                current_date=current_date, whisky_link_scrap=scrap_dict)

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    result_df = wb_libs_func.remove_duplicated_link(result_df)  # 위스키 링크 중복 수집 문제 임시방편 해결
    csv_path = f'results/{current_date}/csv/link/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER_WHISKY_LINK.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/link/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.BOTTLER_WHISKY_LINK.value)

    """
    보틀러 위스키 상세 정보 수집
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_whisky_collect_detail'])

    wb_whisky_collector_detail_func.collect(BatchType.BOTTLER_WHISKY_LINK.value, current_date, scrap_dict)

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER_WHISKY_DETAIL.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.BOTTLER_WHISKY_DETAIL.value)

    # 추출된 데이터를 WB 위스키 형식으로 대체
    transform_result_dict = replace_extracted_data_with_wb_whisky_format(batchId=BatchType.BOTTLER_WHISKY.value,
                                                                         extract_data=scrap_dict)

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER_WHISKY.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.BOTTLER_WHISKY.value)
