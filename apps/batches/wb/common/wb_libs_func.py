import json
import pandas as pd
from datetime import datetime
from pytz import timezone
import os

from apps.batches.wb.common import constants


def write_log(current_time: tuple, log_mode: str, mode: str, level: str):
    """
       write_log.
           Args:
               current_time : 현재 시간 가져오기 extract_time()에서 추출
               log_mode : start, end를 통해 시작로그, 종료 로그 결정하기위해
               mode  : distillery, brand 키워드
               level : detail, pre, link 등 mode 밑에 하위 카테고리
           Note:
                log.txt파일에 함수 시작과 끝나는 시간을 기록하기 위한 함수
    """
    if log_mode == 'start':
        try:
            file = open("log/" + str(current_time[0]) + "_log.txt", "a")
            start_log = '\nstart time : ' + str(current_time[1]) + '\nmode : ' + mode + '\nlevel : ' + level
            print(start_log)
            file.write(start_log)
            file.close()

        except IOError:
            os.makedirs('log/')
            file = open("log/" + str(current_time[0]) + "_log.txt", "a")
            end_log ='\nstart time : ' + str(current_time[1]) + '\nmode : ' + mode + '\nlevel : ' + level
            print(end_log)
            file.write(end_log)
            file.close()

    elif log_mode == 'end':
        try:
            file = open("log/" + str(current_time[0]) + "_log.txt", "a")
            finish_log = '\nfinish time : ' + str(current_time[1]) + '\nmode : ' + mode + '\nlevel : ' + level
            print(finish_log)
            file.write(finish_log)
            file.close()

        except IOError:
            os.makedirs('log/')
            file = open("log/" + str(current_time[0]) + "_log.txt", "a")
            finish_log = '\nfinish time : ' + str(current_time[1]) + '\nmode : ' + mode + '\nlevel : ' + level
            print(finish_log)
            file.write(finish_log)
            file.close()


def convert_to_df(obj: object) -> pd.DataFrame:
    try:
        return pd.DataFrame(obj)
    except ValueError:
        return pd.read_json(obj)


def remove_duplicated_link(df: pd.DataFrame) -> pd.DataFrame:
    return df[df.whisky_link.duplicated()==False] #위스키 링크 중복 수집 문제 임시방편 해결


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



