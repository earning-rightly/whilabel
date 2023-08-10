from apps.batches.libs import libs_func
from apps.batches.distillery_collector.distillery_collector_detail import distillery_collector_detail_func
from apps.batches.distillery_collector.distillery_collector_detail import distillery_collector_detail_values

def dis_detail_executions(mode = 'distillery', level = 'detail'):  #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    """
    dis_detail_executions.
        Args:
            mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
        Note:
            scrap_main 에서 증류소 상세정보 스케줄링 함수
    """
    print("start distillery_collector_detail")
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='start', mode = mode, level = level) #시작 로그 기록
    distillery_collector_detail_func.async_execution()                                                       #증류소 상세정보 수집 함수 호출
    libs_func.save_results(result_dict = distillery_collector_detail_values.distillery_collec_detail_result_dict,file_form = 'distillery_collector_detail') #증류소 상세정보 저장 함수 호출
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='end', mode = mode, level = level)   #종료 로그 기록
    print("end distillery_collector_detail")
