from apps.batches.wb_whisky_collector.wb_whisky_collector_detail import wb_whisky_collector_detail_func
from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_whisky_collector.wb_whisky_collector_detail.wb_whisky_collector_detail_values import whisky_collect_detail_scrap as whisky_detail_scrap


def whisky_detail_brand_collector_executions(mode = 'brand', level ='detail'):
    """
        whisky_detail_brand_collector_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 위스키 상세정보 스케줄링 함수
    """
    print("start whisky_detail_belonging_to_brand_collector")
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), mode = mode, log_mode='start', level = level)  #시작 로그 기록
    wb_whisky_collector_detail_func.collect(mode)                                                                   #브랜드 상세정보 수집 함수 호출
    wb_libs_func.save_results(result_dict = whisky_detail_scrap, file_form='wb_brand_whisky_collector_detail')      #브랜드 상세정보 저장 함수 호출
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), mode = mode, log_mode='end', level = level)    #종료 로그 기록
    print("end whisky_detail_belonging_to_brand_collector")
