from apps.batches.wb_brand_collector.wb_brand_collector_pre import wb_brand_collector_pre_func
from apps.batches.wb_brand_collector.wb_brand_collector_pre.wb_brand_collector_pre_values import \
    brand_summary_collect_data as pre_scrap
from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_libs.enums import BatchType
def brand_pre_executions(batch_type : BatchType):
    """
       brand_pre_executions.
           Args:
               mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
               detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
           Note:
               scrap_main 에서 브랜드 사전 정보 스케줄링 함수
    """

    wb_brand_collector_pre_func.collect()  # 브랜드 사전정보 수집 함수 호출

    current_date = wb_libs_func.get_current_date()

    # save as csv file
    result_df = wb_libs_func.convert_to_df(pre_scrap)
    csv_path = f'results/{current_date}/csv/pre/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/pre/'
    wb_libs_func.save_to_json(pre_scrap, json_path, batch_type.value)