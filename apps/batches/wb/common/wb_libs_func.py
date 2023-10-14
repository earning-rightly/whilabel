import json
import pandas as pd
from datetime import datetime
from pytz import timezone
import os
import logging

from apps.batches.wb.common import constants

logger = None  # 전역 로거


def setup_logger(log_filename: str) -> logging:
    # 디렉터리가 없는 경우 생성
    log_directory = os.path.dirname(log_filename)
    if not os.path.exists(log_directory):
        os.makedirs(log_directory)

    logger = logging.getLogger(__name__)
    logger.setLevel(logging.DEBUG)

    # 로그 포맷 설정
    formatter = logging.Formatter('%(asctime)s : %(message)s')

    # 파일 핸들러 설정
    file_handler = logging.FileHandler(log_filename)
    file_handler.setLevel(logging.DEBUG)
    file_handler.setFormatter(formatter)

    # 로거에 핸들러 추가
    logger.addHandler(file_handler)

    return logger


def write_log(current_date: str, current_datetime: str, log_mode: str, batch_type: str, batch_ex: str):
    global logger

    log_filename = f"log/{current_date}_log.txt"

    if logger is None:
        logger = setup_logger(log_filename)

    log_message = f'{log_mode} time : {current_datetime}\nbatch_type : {batch_type}\nbatch_execution : {batch_ex}'
    logger.info(log_message)


def convert_to_df(obj: object) -> pd.DataFrame:
    try:
        return pd.DataFrame(obj)
    except ValueError:
        return pd.read_json(obj)


def remove_duplicated_link(df: pd.DataFrame) -> pd.DataFrame:
    return df[df.whisky_link.duplicated() == False]  # 위스키 링크 중복 수집 문제 임시방편 해결


def save_to_csv(df: pd.DataFrame, path: str, file_name: str):
    try:
        df.to_csv(f'{path}{file_name}.csv', index=False)
    except OSError:
        os.makedirs(path)
        df.to_csv(f'{path}{file_name}.csv', index=False)


def save_to_json(obj: object, path: str, file_name: str):
    try:
        outfile = open(f'{path}{file_name}.json', 'w')
        json.dump(obj, outfile, indent=4)
    except FileNotFoundError:
        os.makedirs(path)
        outfile = open(f'{path}{file_name}.json', 'w')
        json.dump(obj, outfile, indent=4)


def reset_list_size(length: int, scrap_dict: dict):
    """
            reset_list_size.
                Args:
                    length : 초기화해야할 크기 ex) 123
                    scrap_dict : 수집할(초기화해야할) 형식의 딕셔너리 가져오기
                Note:
                    수집을 위해 사전에 수집해야할 크기에 맞게 변수의 크기를 수정하기 위한 함수
        """
    for key in scrap_dict.keys():
        scrap_dict.get(key).extend([None for i in range(length)])


def get_current_date() -> str:
    return datetime.now().replace(tzinfo=timezone(constants.KST)).strftime("%Y_%m_%d")


def get_current_datetime() -> str:
    return datetime.now().replace(tzinfo=timezone(constants.KST)).strftime("%Y_%m_%d %H:%M:%S %p")


def initialize_dict(key_list: list, ) -> dict:
    # AttributeError: 'NoneType' object has no attribute 'append'
    # None -> [] 수정.
    return {key: [] for key in key_list}
