from apps.batches.wb_distillery_collector.wb_distillery_collector_pre import wb_distillery_collector_pre_func
from apps.batches.wb_distillery_collector.wb_distillery_collector_pre.wb_distillery_collector_pre_values import distillery_summary_collect_data as pre_scrap
from apps.batches.wb_libs import wb_libs_func
def distillery_pre_executions(mode = 'distillery', level = 'early'):
    """
       distillery_pre_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 증류소 사전 정보 스케줄링 함수
    """
    print("start wb_distillery_collector_pre")
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='start', mode = mode, level = level)  #시작 로그 기록
    wb_distillery_collector_pre_func.collect()                                                                      #증류소 사전정보 수집 함수 호출
    wb_libs_func.save_resconvert_csv_to_json(result_dict = pre_scrap, file_form ='wb_distillery_collector_pre')                    #증류소 사전정보 저장 함수 호출
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='start', mode = mode, level = level)  #종료 로그 기록
    print("end wb_distillery_collector_pre")
