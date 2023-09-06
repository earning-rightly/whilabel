from apps.batches.wb_libs import wb_libs_func
from apps.batches.wb_bottler_collector.wb_bottler_collector_detail import wb_bottler_collector_detail_func
from apps.batches.wb_bottler_collector.wb_bottler_collector_detail.wb_bottler_collector_detail_values import \
    bottler_collect_detail_scrap as detail_scrap
from apps.batches.transformations.wb_bottler.wb_bottler_form import \
    replace_extracted_data_with_wb_bottler_formmat
from apps.batches.wb_libs.enums import BatchType,CollectionName,BatchExecution
from apps.batches.wb_libs.lib_firebase import save_to_firebase

def bottler_detail_executions(batch_type : BatchType, batch_execution : BatchExecution):
    """
        distillery_detail_executions.
            Args:
                mode : mode값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
                detail : detail값을 받아, 하위 함수르 호출할때 현재 상태를 전달.
            Note:
                scrap_main 에서 증류소 상세정보 스케줄링 함수
    """

    #wb_libs_func.write_log(current_time=wb_libs_func.extract_time(),log_mode='start',mode=mode,level=level)  # 시작 로그 기록
    wb_bottler_collector_detail_func.collect(current_date=wb_libs_func.extract_time()[0])  # 증류소 상세정보 수집 함수 호출

    current_date = wb_libs_func.get_current_date()

    # save as csv file
    result_df = wb_libs_func.convert_to_df(detail_scrap)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(detail_scrap, json_path, batch_type.value)
    
    # wb_libs_func.write_log(current_time=wb_libs_func.extract_time(), log_mode='end', mode=mode, level=level)  # 종료 로그 기록
    
    transform_result_list, transform_result_dict = replace_extracted_data_with_wb_bottler_formmat(batchId=batch_execution.value)
    
    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, batch_type.value)

    save_to_firebase(CollectionName.BOTTLER, transform_result_list, 'wbId', 'wbBottler')

