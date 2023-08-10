from apps.batches.whisky_collector.whisky_collector_link import whisky_collector_link_func
from apps.batches.whisky_collector.whisky_collector_link import whisky_collector_link_values
from apps.batches.libs import libs_func

def whisky_link_distillery_collector_executions(mode = 'distillery', level = 'link'):  #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    """
       whisky_link_distillery_collector_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 위스키 링크  스케줄링 함수
    """
    print("start whisky_belonging_to_distillery_collector")
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='start', mode = mode, level = level) #시작 로그 기록
    whisky_collector_link_func.initserilized_value()                                                         #위스키 링크 수집 함수 호출
    libs_func.save_results(result_dict = whisky_collector_link_values.whisky_collec_link_scrap_dict, file_form = 'distillery_whisky_link')#위스키 링크 저장
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='start', mode = mode, level = level) #종료 로그 기록
    print("end whisky_belonging_to_distillery_collector")