from apps.batches.wb_whisky_collector.wb_whisky_collector_link import wb_whisky_collector_link_func
from apps.batches.wb_whisky_collector.wb_whisky_collector_link.wb_whisky_collector_link_values import \
    whisky_collect_link_scrap as link_scrap
from apps.batches.wb_libs import wb_libs_func


def whisky_link_bottler_collector_executions(mode='bottler', level='link'):
    """
       whisky_link_bottler_collector_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 위스키 링크  스케줄링 함수
    """

    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),
                           log_mode='start',
                           mode=mode+'_whisky',
                           level=level)  # 시작 로그 기록
    wb_whisky_collector_link_func.collect(mode=mode,
                                          current_date=wb_libs_func.extract_time()[0])  # 위스키 링크 수집 함수 호출
    wb_libs_func.save_resconvert_csv_to_json(current_date=wb_libs_func.extract_time()[0],
                                             result_dict=link_scrap,
                                             dir_path='link/',
                                             file_form='wb_bottler_whisky_collector_link')  # 위스키 링크 저장 함수 호출
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),
                           log_mode='end',
                           mode=mode+'_whisky',
                           level=level)  # 종료 로그 기록

