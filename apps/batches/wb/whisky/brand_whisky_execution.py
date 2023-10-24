from apps.batches.wb.whisky.transform import transform_raw_to_wb_whisky
from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.constants import field_map
from apps.batches.wb.common.enums import BatchType
from apps.batches.wb.whisky import whisky_link_collector, whisky_detail_collector


def brand_whisky_execution():
    """
    brand_whisky_execution
        Args:
        Notes:
            브랜드 위스키 수집 및 처리 실행 함수입니다.
    """
    current_date = wb_libs_func.get_current_date()

    """
    브랜드 위스키 링크 수집
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_whisky_link'])

    whisky_link_collector.collect_whisky_link(batch_type=BatchType.BRAND_WHISKY_LINK,
                                              current_date=current_date, whisky_link_scrap=scrap_dict)

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    result_df = wb_libs_func.remove_duplicated_link(result_df)  # 위스키 링크 중복 수집 문제 임시방편 해결
    csv_path = f'results/{current_date}/csv/link/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BRAND_WHISKY_LINK.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/link/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.BRAND_WHISKY_LINK.value)

    """
    보틀러 위스키 상세 정보 수집
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_whisky_collect_detail'])

    whisky_detail_collector.collect_whisky_detail(BatchType.BRAND_WHISKY_DETAIL, current_date, scrap_dict)

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BRAND_WHISKY_DETAIL.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.BRAND_WHISKY_DETAIL.value)

    """
    브랜드 위스키 최종 데이터 가공 및 저장
    """

    # 추출된 데이터를 WB 위스키 형식으로 대체
    transform_result_dict = transform_raw_to_wb_whisky(batch_type=BatchType.BRAND_WHISKY.value,
                                                       extract_data=scrap_dict)

    # CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BRAND_WHISKY.value)

    # JSON 파일로 저장
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.BRAND_WHISKY.value)