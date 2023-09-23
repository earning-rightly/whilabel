from apps.batches.wb.common import wb_libs_func
from apps.batches.wb.distillery import distillery_collector
from apps.batches.wb.distillery.transform import transform_raw_to_wb_distillery
from apps.batches.wb.common.enums import CollectionName, BatchType
from apps.batches.libs.lib_firebase.firebase_funcs import save_to_firebase
from apps.batches.wb.common.constants import field_map


def distillery_detail_execution(batch_type: BatchType):
    """
        distillery_detail_execution.
            Args:
            Note:
                scrap_main 에서 증류소 상세정보 스케줄링 함수
    """

    scrap_dict = wb_libs_func.initialize_dict(field_map['wb_distillery_collect_detail'])

    current_date = wb_libs_func.get_current_date()

    # 증류소 상세정보 수집 함수 호출
    distillery_collector.collect_distillery_detail(batch_type.DISTILLERY_PRE.value, current_date, scrap_dict)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(scrap_dict)
    csv_path = f'results/{current_date}/csv/detail/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/detail/'
    wb_libs_func.save_to_json(scrap_dict, json_path, batch_type.value)

    # TODO: pre, detail 모두가 실행된 후 실행돼야하는 함수 -> 별도 분리 필요
    transform_result_list, transform_result_dict = transform_raw_to_wb_distillery(batch_type.value)

    # save as csv file
    result_df = wb_libs_func.convert_to_df(transform_result_dict)
    csv_path = f'results/{current_date}/csv/transformation/'
    wb_libs_func.save_to_csv(result_df, csv_path, batch_type.value)

    # save as json file
    json_path = f'results/{current_date}/json/transformation/'
    wb_libs_func.save_to_json(transform_result_dict, json_path, batch_type.value)

    save_to_firebase(CollectionName.DISTILLERY, transform_result_list, 'wbId', 'wbDistillery')
