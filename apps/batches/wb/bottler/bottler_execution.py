from apps.batches.wb.bottler import bottler_detail_collector, bottler_pre_collector
from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.bottler.transform import transform_raw_to_wb_bottler
from apps.batches.wb.common.enums import BatchType, CollectionName, LogMode, BatchExecution
from apps.batches.libs.lib_firebase.firebase_funcs import save_to_firebase
from apps.batches.wb.common.constants import field_map, link_map
from apps.batches.wb.common.wb_libs_func import write_log


def bottler_execution(batch_id: BatchExecution):
    """
    bottler_execution
        Notes:
            보틀러 데이터 수집 및 처리 실행 함수입니다.
    """
    current_date = wb_libs_func.get_current_date()
    current_datetime = wb_libs_func.get_current_datetime()

    '''
    보틀러 사전 정보 수집
    '''
    write_log(current_date, current_datetime, LogMode.START.value, BatchType.BOTTLER_PRE.value, batch_id.value)
    # 사전 정보 수집을 위한 빈 딕셔너리 초기화
    pre_scrap_dict = wb_libs_func.initialize_dict(field_map['wb_bottler_collect_pre'])

    # 증류소 사전 정보 수집 함수 호출
    bottler_pre_collector.collect_bottler_pre(pre_scrap_dict, link_map['bottler'])

    # 결과를 CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(pre_scrap_dict)
    csv_path = f'results/{current_date}/csv/pre/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER_PRE.value)

    # 결과를 JSON 파일로 저장
    json_path = f'results/{current_date}/json/pre/'
    wb_libs_func.save_to_json(pre_scrap_dict, json_path, BatchType.BOTTLER_PRE.value)
    write_log(current_date, current_datetime, LogMode.END.value, BatchType.BOTTLER_PRE.value, batch_id.value)

    '''
    보틀러 상세 정보 수집
    '''
    write_log(current_date, current_datetime, LogMode.START.value, BatchType.BOTTLER_DETAIL.value, batch_id.value)
    # 상세 정보 수집을 위한 빈 딕셔너리 초기화
    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_bottler_collect_detail'])

    current_date = wb_libs_func.get_current_date()

    # 증류소 상세 정보 수집 함수 호출
    bottler_detail_collector.collect_bottler_detail(current_date, scrap_dict)

    # 결과를 CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER_DETAIL.value)

    # 결과를 JSON 파일로 저장
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.BOTTLER_DETAIL.value)

    '''
    가공 후 로컬 파일에 저장 + 파이어베이스 저장
    '''
    # 데이터 변환 함수를 사용하여 데이터 가공
    transform_result_list, transform_result_dict = transform_raw_to_wb_bottler(BatchType.BOTTLER.value)

    # 가공된 데이터를 CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BOTTLER.value)

    # 가공된 데이터를 JSON 파일로 저장
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.BOTTLER.value)

    write_log(current_date, current_datetime, LogMode.END.value, BatchType.BOTTLER_DETAIL.value, batch_id.value)
    # Firebase에 데이터 저장
    save_to_firebase(CollectionName.BOTTLER, transform_result_list, 'wbId', 'wbBottler')
