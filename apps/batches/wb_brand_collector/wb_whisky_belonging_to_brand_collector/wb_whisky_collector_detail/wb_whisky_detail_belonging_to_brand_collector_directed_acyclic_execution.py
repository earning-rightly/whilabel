from apps.batches.wb_whisky_collector.wb_whisky_collector_detail import wb_whisky_collector_detail_func
from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_whisky_collector.wb_whisky_collector_detail.wb_whisky_collector_detail_values import \
    whisky_collect_detail_scrap as whisky_detail_scrap
from apps.batches.transformations.wb_whisky.wb_whisky_form import replace_extracted_data_with_wb_whisky_formmat


def whisky_detail_brand_collector_executions(mode : str ='brand', level : str ='detail'):
    """
        whisky_detail_brand_collector_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 위스키 상세정보 스케줄링 함수
    """

    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),
                           mode=mode+'_whisky',
                           log_mode='start'
                           ,level=level)  # 시작 로그 기록
    wb_whisky_collector_detail_func.collect(
        mode=mode,
        current_date=wb_libs_func.extract_time()[0])  # 브랜드 상세정보 수집 함수 호출
    wb_libs_func.save_resconvert_csv_to_json(
        current_date=wb_libs_func.extract_time()[0],
        result_dict=whisky_detail_scrap,
        dir_path='detail/',
        file_form='wb_brand_whisky_collector_detail')  # 브랜드 상세정보 저장 함수 호출
    wb_libs_func.write_log(
        current_time=wb_libs_func.extract_time(),
        mode=mode+'_whisky',
        log_mode='end',
        level=level)  # 종료 로그 기록
    transform_result_list, transform_result_dict = replace_extracted_data_with_wb_whisky_formmat(
        extract_data= whisky_detail_scrap)

    wb_libs_func.save_resconvert_csv_to_json(current_date=wb_libs_func.extract_time()[0],
                                             result_dict=transform_result_dict,
                                             dir_path='transformation/',
                                             file_form='wb_' + mode + '_whiky',
                                             transform_to_fire_bose=transform_result_list,
                                             update_key='brand_whisky',#?
                                              data_load_to_fire_base_bool=False)  # True)  # 브랜드 사전정보 저장 함수 호출

