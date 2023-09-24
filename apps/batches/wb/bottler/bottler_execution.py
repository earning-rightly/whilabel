from apps.batches.wb.bottler import bottler_detail_collector, bottler_pre_collector
from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.bottler.transform import transform_raw_to_wb_bottler
from apps.batches.wb.common.enums import BatchType, CollectionName, BatchExecution
from apps.batches.libs.lib_firebase.firebase_funcs import save_to_firebase
from apps.batches.wb.common.constants import field_map, link_map


def bottler_execution():
    """
        bottler_execution.
            Args:
            Note:
                scrap_main 에서 보틀러 상세정보 스케줄링 함수
    """
    current_date = wb_libs_func.get_current_date()

    '''
    보틀러 사전 정보 수집
    '''
    pre_scrap_dict = wb_libs_func.initialize_dict(field_map['wb_bottler_collect_pre'])

    bottler_pre_collector.collect_bottler_pre(pre_scrap_dict, link_map['bottler'])  # 증류소 사전정보 수집 함수 호출

    # save as csv file
    result_df = wb_libs_func.convert_to_df(pre_scrap_dict)
    csv_path = f'results/{current_date}/csv/pre/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER_PRE.value)

    # save as json file
    json_path = f'results/{current_date}/json/pre/'
    wb_libs_func.save_to_json(pre_scrap_dict, json_path, BatchType.BOTTLER_PRE.value)

    '''
    bottler 상세 정보 수집
    '''
    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_bottler_collect_detail'])

    current_date = wb_libs_func.get_current_date()

    bottler_detail_collector.collect_bottler_detail(current_date, scrap_dict)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER_DETAIL.value)

    # save as json file
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.BOTTLER_DETAIL.value)

    '''
    가공 후 로컬 파일에 저장 + 파이어베이스 저장
    '''
    transform_result_list, transform_result_dict = transform_raw_to_wb_bottler(BatchType.BOTTLER.value)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.BOTTLER.value)

    save_to_firebase(CollectionName.BOTTLER, transform_result_list, 'wbId', 'wbBottler')