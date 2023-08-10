from apps.batches.whisky_collector.whisky_collector_detail import whisky_collector_detail_func
from apps.batches.libs import libs_func
from apps.batches.whisky_collector.whisky_collector_detail import whisky_collector_detail_values


def whisky_detail_brand_collector_executions(mode='distillery',level='detail'):
    """
       whisky_detail_brand_collector_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 위스키 링크  스케줄링 함수
    """
    print("start whisky_detail_belonging_to_distillery_collector")
    libs_func.write_log(current_time=libs_func.extract_time(), mode=mode, log_mode='start', level=level)  #시작 로그 기록
    whisky_collector_detail_func.initserilized_value(mode)                                                 #위스키 상세정보 수집 함수 호출
    libs_func.save_results(result_dict=whisky_collector_detail_values.whisky_collec_detail_result_dict, file_form='_whisky_collector_detail')  #위스키 상세정보 저장
    libs_func.write_log(current_time=libs_func.extract_time(), mode=mode, log_mode='end', level=level)    #시작 로그 기록
    print("end whisky_detail_belonging_to_distillery_collector")
