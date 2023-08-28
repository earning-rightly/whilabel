from apps.batches.wb_bottler_collector.wb_bottler_collector_pre import wb_bottler_collector_pre_func
from apps.batches.wb_bottler_collector.wb_bottler_collector_pre.wb_bottler_collector_pre_values import \
    bottler_summary_collect_data as pre_scrap
from apps.batches.wb_libs import wb_libs_func


def bottler_pre_executions(mode='bottler', level='pre'):
    """
       distillery_pre_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 증류소 사전 정보 스케줄링 함수
    """
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),
                           log_mode='start',
                           mode=mode,
                           level=level)  # 시작 로그 기록
    wb_bottler_collector_pre_func.collect()  # 증류소 사전정보 수집 함수 호출
    wb_libs_func.save_resconvert_csv_to_json(current_date=wb_libs_func.extract_time()[0],
                                             result_dict=pre_scrap,
                                             dir_path='pre/',
                                             file_form='wb_bottler_collector_pre')  # 증류소 사전정보 저장 함수 호출
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),
                           log_mode='end',
                           mode=mode,
                           level=level)  # 종료 로그 기록

