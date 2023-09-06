from apps.batches.wb_bottler_collector.wb_bottler_collector_pre import wb_bottler_collector_pre_func
from apps.batches.wb_bottler_collector.wb_bottler_collector_pre.wb_bottler_collector_pre_values import \
    bottler_summary_collect_data as pre_scrap
from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_libs.enums import BatchType

def bottler_pre_executions(batch_type : BatchType):
    """
       bottler_pre_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 bottler 사전 정보 스케줄링 함수
    """
    #wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),log_mode='start',mode=mode,level=level)  # 시작 로그 기록
    wb_bottler_collector_pre_func.collect()  # 증류소 사전정보 수집 함수 호출

    current_date = wb_libs_func.get_current_date()

    # save as csv file
    result_df = wb_libs_func.convert_to_df(pre_scrap)
    csv_path = f'results/{current_date}/csv/pre/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/pre/'
    wb_libs_func.save_to_json(pre_scrap, json_path, batch_type.value)
    
    #wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),log_mode='end', mode=mode,level=level)  # 종료 로그 기록

