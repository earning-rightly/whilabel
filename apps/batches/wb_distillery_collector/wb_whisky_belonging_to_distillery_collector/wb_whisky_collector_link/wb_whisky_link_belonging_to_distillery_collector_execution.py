from apps.batches.wb_whisky_collector.wb_whisky_collector_link import wb_whisky_collector_link_func
from apps.batches.wb_whisky_collector.wb_whisky_collector_link.wb_whisky_collector_link_values import whisky_collect_link_scrap as link_scrap
from apps.batches.wb_libs import wb_libs_func

def whisky_link_distillery_collector_executions(mode = 'distillery', level = 'link'):
    """
       whisky_link_distillery_collector_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 위스키 링크  스케줄링 함수
    """
    print("start whisky_link_belonging_to_brand_collector")
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='start', mode=mode, level=level)      #시작 로그 기록
    wb_whisky_collector_link_func.collect(mode)                                                                     #위스키 링크 수집 함수 호출
    wb_libs_func.save_results(result_dict = link_scrap, file_form ='wb_distillery_whisky_collector_link')           #위스키 링크 저장 함수 호출
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='end', mode = mode, level = level)    #종료 로그 기록
    print("end whisky_link_belonging_to_distillery_collector")