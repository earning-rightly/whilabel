from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.distillery import distillery_detail_collector, distillery_pre_collector
from apps.batches.wb.distillery.transform import transform_raw_to_wb_distillery
from apps.batches.wb.common.enums import CollectionName, BatchType
from apps.batches.libs.lib_firebase.firebase_funcs import save_to_firebase
from apps.batches.wb.common.constants import field_map
from apps.batches.wb.common.constants import link_map


def distillery_execution():
    """
        distillery_detail_execution.
            Note:
                scrap_main 에서 증류소 상세정보 스케줄링 함수
    """
    current_date = wb_libs_func.get_current_date()

    '''
    증류소 사전 정보 수집
    '''
    pre_scrap_dict = wb_libs_func.initialize_dict(field_map['wb_distillery_collect_pre'])

    distillery_pre_collector.collect_distillery_pre(pre_scrap_dict, link_map['distillery'])  # 증류소 사전정보 수집 함수 호출

    # save raw pre data as csv file
    result_df = wb_libs_func.convert_to_df(pre_scrap_dict)
    csv_path = f'results/{current_date}/csv/pre/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.DISTILLERY_PRE.value)

    # save raw pre data as json file
    json_path = f'results/{current_date}/json/pre/'
    wb_libs_func.save_to_json(pre_scrap_dict, json_path, BatchType.DISTILLERY_PRE.value)

    '''
    증류소 상세 정보 수집
    '''
    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_distillery_collect_detail'])

    distillery_detail_collector.collect_distillery_detail(BatchType.DISTILLERY_DETAIL.value, current_date, scrap_dict)

    # save raw detail data as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.DISTILLERY_DETAIL.value)

    # save raw detail data as json file
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, BatchType.DISTILLERY_DETAIL.value)

    '''
    가공 후 로컬 파일에 저장 + 파이어베이스 저장
    '''
    transform_result_list, transform_result_dict = transform_raw_to_wb_distillery(BatchType.DISTILLERY.value)

    # save detail data as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, BatchType.DISTILLERY.value)

    # save detail data as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, BatchType.DISTILLERY.value)

    save_to_firebase(CollectionName.DISTILLERY, transform_result_list, 'wbId', 'wbDistillery')
