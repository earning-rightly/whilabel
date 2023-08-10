from batches.brand_collector.brand_collector_detail import brand_collector_detail_values
from batches.libs import libs_func
from batches.brand_collector.brand_collector_detail import brand_collector_detail_func

def brand_detail_executions(mode = 'brand', level = 'detail'):  #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    """
    brand_detail_executions.
        Args:
            mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
        Note:
            scrap_main 에서 브랜드 상세정보 스케줄링 함수
    """
    print("start brand_collector_early")
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='start', mode = mode, level = level) #시작 로그 기록
    brand_collector_detail_func.async_execution()                                                            #브랜드 상세정보 수집 함수 호출
    libs_func.save_results(result_dict = brand_collector_detail_values.brand_collec_detail_result_dict,file_form = 'brand_collector_detail') #브랜드 상세정보 저장 함수 호출
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode= 'end', mode = mode, level = level) #종료 로그 기록
    print("end brand_collector_early")
