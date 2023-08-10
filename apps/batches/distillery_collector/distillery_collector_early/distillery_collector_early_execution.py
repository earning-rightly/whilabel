from apps.batches.libs import libs_func
from apps.batches.distillery_collector.distillery_collector_early import distillery_collector_early_func
from apps.batches.distillery_collector.distillery_collector_early import distillery_collector_early_values

def dis_early_executions(mode = 'distillery', level = 'early'):
    """
       dis_early_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 증류소 초기정보 스케줄링 함수
    """
    print("start distillery_collector_early")
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='start', mode = mode, level = level)  #시작 로그 기록
    distillery_collector_early_func.scrap_distillery_collector_early()                                         #증류소 초기정보 수집 함수 호출
    libs_func.save_results(result_dict = distillery_collector_early_values.distillery_collec_early_result_dict, file_form = 'distillery_collector_early') #증류소 초기정보 저장 함수 호출
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='start', mode = mode, level = level)  #종료 로그 기록
    print("end distillery_collector_early")
