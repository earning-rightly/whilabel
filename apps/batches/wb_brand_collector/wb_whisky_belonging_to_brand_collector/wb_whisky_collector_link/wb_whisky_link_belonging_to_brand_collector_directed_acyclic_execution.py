from apps.batches.wb.common import wb_libs_func
from apps.batches.wb_whisky_collector.wb_whisky_collector_link import wb_whisky_collector_link_apply_func
from apps.batches.wb.common.enums import BatchType
from apps.batches.wb.common.constants import field_map


def whisky_link_brand_collector_executions(batch_type : BatchType):  # mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    """
       whisky_link_brand_collector_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 위스키 링크  스케줄링 함수
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_whisky_link'])

    current_date = wb_libs_func.get_current_date()

    wb_whisky_collector_link_apply_func.collect(batch_type=BatchType.BRAND_PRE.value,
                                                current_date=current_date,whisky_link_scrap=scrap_dict)  # 위스키 링크 수집 함수 호출

    # save as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    result_df = wb_libs_func.remove_duplicated_link(result_df) # 위스키 링크 중복 수집 문제 임시방편 해결
    csv_path = f'results/{current_date}/csv/link/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/link/'
    wb_libs_func.save_to_json(scrap_dict, json_path, batch_type.value)