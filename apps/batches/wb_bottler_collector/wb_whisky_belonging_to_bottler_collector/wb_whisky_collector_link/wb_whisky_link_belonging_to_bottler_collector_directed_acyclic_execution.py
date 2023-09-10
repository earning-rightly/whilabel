from apps.batches.wb_whisky_collector.wb_whisky_collector_link.wb_whisky_collector_link_values import \
    whisky_collect_link_scrap as link_scrap
from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_whisky_collector.wb_whisky_collector_link import wb_whisky_collector_link_apply_func
from apps.batches.wb_libs.enums import BatchType
def whisky_link_bottler_collector_executions(batch_type : BatchType):
    """
       whisky_link_bottler_collector_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 위스키 링크  스케줄링 함수
    """

    current_date = wb_libs_func.get_current_date()

    wb_whisky_collector_link_apply_func.collect(batch_type=BatchType.BOTTER_PRE.value,
                                                current_date=current_date)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(link_scrap)
    result_df = wb_libs_func.remove_duplicated_link(result_df) # 위스키 링크 중복 수집 문제 임시방편 해결
    csv_path = f'results/{current_date}/csv/link/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    result_json = json.loads(link_scrap.to_json())
    json_path = f'results/{current_date}/json/link/'
    wb_libs_func.save_to_json(result_json, json_path, batch_type.value)