from apps.batches.wb.brand import brand_detail_collector, brand_pre_collector
from apps.batches.wb.brand.transform import transform_raw_to_wb_brand
from apps.batches.wb.common.enums import BatchType, CollectionName, BatchExecution
from apps.batches.libs.lib_firebase.firebase_funcs import save_to_firebase
from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.common.constants import field_map, link_map


def brand_execution():
    """
        brand_execution.
            Note:
                브랜드 데이터 수집 및 처리 실행 함수입니다.
    """
    current_date = wb_libs_func.get_current_date()

    '''
    브랜드 사전 정보 수집
    '''
    # 사전 정보 수집을 위한 빈 딕셔너리 초기화
    pre_scrap_dict = wb_libs_func.initialize_dict(field_map['wb_brand_collect_pre'])

    # 브랜 사전 정보 수집 함수 호출
    brand_pre_collector.collect_brand_pre(pre_scrap_dict, link_map['brand'])  # 증류소 사전정보 수집 함수 호출

    # 결과를 CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(pre_scrap_dict)
    csv_path = f'results/{current_date}/csv/pre/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BRAND_PRE.value)

    # 결과를 JSON 파일로 저장
    json_path = f'results/{current_date}/json/pre/'
    wb_libs_func.save_to_json(pre_scrap_dict, json_path, BatchType.BRAND_PRE.value)

    '''
    브랜드 상세 정보 수집
    '''
    # 상세 정보 수집을 위한 빈 딕셔너리 초기화
    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_brand_collect_detail'])

    # 브랜드 상세 정보 수집 함수 호출
    brand_detail_collector.collect_brand_detail(current_date, scrap_dict)  # 브랜드 상세정보 수집 함수 호출

    # 결과를 CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BRAND_DETAIL.value)

    # 결과를 JSON 파일로 저장
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.BRAND_DETAIL.value)

    '''
    가공 후 로컬 파일에 저장 + 파이어베이스 저장
    '''
    # 데이터 변환 함수를 사용하여 데이터 가공
    transform_result_list, transform_result_dict = transform_raw_to_wb_brand(BatchType.BRAND.value)

    # 가공된 데이터를 CSV 파일로 저장
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.BRAND.value)

    # 가공된 데이터를 JSON 파일로 저장
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.BRAND.value)

    # Firebase에 데이터 저장
    save_to_firebase(CollectionName.BRAND, transform_result_list, 'wbId', 'wbBrand')
