from apps.batches.wb_brand_collector.wb_brand_collector_detail import wb_brand_collector_detail_func
from apps.batches.wb_brand_collector.wb_brand_collector_detail.wb_brand_collector_detail_values import brand_collect_detail_scrap as detail_scrap
from apps.batches.wb_libs import wb_libs_func


def brand_detail_executions(mode = 'brand', level = 'detail'):  #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    """
        brand_detail_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 브랜드 상세정보 스케줄링 함수
    """
    print("start wb_brand_collector_detail")
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='start', mode = mode, level = level) #시작 로그 기록
    wb_brand_collector_detail_func.collect()                                                                       #브랜드 상세정보 수집 함수 호출
    wb_libs_func.save_resconvert_csv_to_json(result_dict = detail_scrap, file_form ='wb_brand_collector_detail')                  #브랜드 상세정보 저장 함수 호출
    wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='end', mode = mode, level = level)   #종료 로그 기록
    print("end wb_brand_collector_detail")
