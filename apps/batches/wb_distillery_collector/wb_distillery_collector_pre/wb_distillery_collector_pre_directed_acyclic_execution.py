from apps.batches.wb_distillery_collector.wb_distillery_collector_pre import wb_distillery_collector_pre_func
from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.enums import BatchType
from apps.batches.wb.common.constants import field_map
from apps.batches.wb.common.constants import link_map


def distillery_pre_executions(batch_type : BatchType):
    """
       distillery_pre_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 증류소 사전 정보 스케줄링 함수
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_distillery_collect_pre'])

    wb_distillery_collector_pre_func.collect(scrap_dict,  link_map['distillery'])  # 증류소 사전정보 수집 함수 호출

    current_date = wb_libs_func.get_current_date()

    # save as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/pre/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/pre/'
    wb_libs_func.save_to_json(scrap_dict, json_path, batch_type.value)