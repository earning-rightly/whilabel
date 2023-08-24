from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_distillery_collector.wb_distillery_collector_detail import wb_distillery_collector_detail_func
from apps.batches.wb_distillery_collector.wb_distillery_collector_detail.wb_distillery_collector_detail_values import distillery_collect_detail_scrap as detail_scrap

def distillery_detail_executions(mode = 'distillery', level = 'detail'):
    """
        distillery_detail_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 증류소 상세정보 스케줄링 함수
    """
    print("start wb_distillery_collector_detail")
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='start', mode = mode, level = level) #시작 로그 기록
    wb_distillery_collector_detail_func.collect()                                                                  #증류소 상세정보 수집 함수 호출
    wb_libs_func.save_resconvert_csv_to_json(result_dict = detail_scrap, file_form ='wb_distillery_collector_detail')             #증류소 상세정보 저장 함수 호출
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='end', mode = mode, level = level)   #종료 로그 기록
    print("end wb_distillery_collector_detail")
