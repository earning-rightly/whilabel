from batches.whisky_collector.whisky_collector_link import whisky_collector_link_func
from batches.whisky_collector.whisky_collector_link import whisky_collector_link_values
from batches.libs import libs_func

def whisky_link_brand_collector_executions(mode = 'brand', level = 'link'):
    """
       whisky_link_brand_collector_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 위스키 링크  스케줄링 함수
    """
    print("start whisky_link_belonging_to_brand_collector")
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='start', mode=mode, level=level)  #시작 로그 기록
    whisky_collector_link_func.initserilized_value(mode)                                                  #위스키 링크 수집 함수 호출
    libs_func.save_results(result_dict = whisky_collector_link_values.whisky_collec_link_scrap_dict, file_form = 'brand_whisky_collector_link')  #위스키 링크 수집 함수 호출
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='end', mode = mode, level = level) #위스키 링크 수집 함수 호출
    print("end whisky_link_belonging_to_brand_collector")                                                  #종료 로그 기록