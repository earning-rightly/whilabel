from apps.batches.wb_brand_collector.wb_brand_collector_detail import wb_brand_collector_detail_func
from apps.batches.wb_brand_collector.wb_brand_collector_detail.wb_brand_collector_detail_values import \
    brand_collect_detail_scrap as detail_scrap
from apps.batches.wb_libs import wb_libs_func
from apps.batches.transformations.wb_brand.wb_brand_form import replace_extracted_data_with_wb_brand_formmat


def brand_detail_executions(mode='brand',level='detail'):
    """
        brand_detail_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 브랜드 상세정보 스케줄링 함수
    """

    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),
                           log_mode='start', mode=mode,
                           level=level)  # 시작 로그 기록
    wb_brand_collector_detail_func.collect(current_date = wb_libs_func.extract_time()[0])  # 브랜드 상세정보 수집 함수 호출
    wb_libs_func.save_resconvert_csv_to_json(current_date=wb_libs_func.extract_time()[0],
                                             result_dict=detail_scrap,
                                             dir_path='detail/',
                                             file_form='wb_brand_collector_detail')  # 브랜드 상세정보 저장 함수 호출
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),
                           log_mode='end', mode=mode,
                           level=level)  # 종료 로그 기록
    transform_result_list, transform_result_dict = replace_extracted_data_with_wb_brand_formmat()  # 수집된 브랜드 정보 전처리
    wb_libs_func.save_resconvert_csv_to_json(current_date=wb_libs_func.extract_time()[0],
                                             # 전처리된 데이터를 csv, json, fire store에 저장
                                             result_dict=transform_result_dict,
                                             dir_path='transformation/',
                                             file_form='wb_brand',
                                             transform_to_fire_bose = transform_result_list,
                                             update_key = 'wbBrand',
                                             data_load_to_fire_base_bool=False)  # True )  # True에경우 fire store에 저장


