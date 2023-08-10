import sys,os
sys.path.append((os.path.abspath(os.path.dirname(__file__)))) # 상위폴더위치로 이동
print(os.getcwd())
import brand_collector_early_func
import brand_collector_early_values
from apps.batches.libs import libs_func

def brand_early_executions(mode = 'brand', level = 'early'):  #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    """
       brand_early_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 브랜드 상세정보 스케줄링 함수
    """
    print("start brand_collector_early")
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='start', mode = mode, level = level) #시작 로그 기록
    brand_collector_early_func.extract_distillery_collector_early()                                          #브랜드 초기정보 수집 함수 호출
    libs_func.save_results(result_dict = brand_collector_early_values.brand_collec_early_result_dict,file_form = 'brand_collector_early')  #브랜드 초기정보 수집 함수 호출
    libs_func.write_log(current_time=libs_func.extract_time(), log_mode='end', mode = mode, level = level)   #브랜드 초기정보 수집 함수 호출
    print("end brand_collector_early")
