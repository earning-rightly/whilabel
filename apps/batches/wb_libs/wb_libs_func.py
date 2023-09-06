import json
import pandas as pd
from datetime import datetime
from pytz import timezone
import os

from apps.batches.wb_libs import constants

# def write_log(file_name: str, batch_type: BatchType, log_content: str):
#     """
#        write_log.
#            Args:
#                file_name: log file name
#                batch_type: batch type
#                log_content: log content
#            Note:
#                 log.txt파일에 함수 시작과 끝나는 시간을 기록하기 위한 함수
#     """
#     try:
#         file = open(file_name, 'a')
#         current_date_time: str = current_date_time()
#         print()
#         file.write(start_log)
#         file.close()
#     except Exception as err:
#         end_log ='\nstart time : ' + str(current_time[1]) + '\nmode : ' + mode + '\nlevel : ' + level
#         print(end_log)
#         file.write(end_log)
#         file.close()


# def current_date_time() -> str:  # ex)2023_08_16 20:18:33 PM
#     date = datetime.now()
#     current_time = date.replace(tzinfo=timezone(constants.KST))  # 타임존을 한국시간으로 설정
#     return current_time.strftime("%Y_%m_%d %H:%M:%S %p")  # 표시 양식을 2023_08_11 14:14:31 PM 으로 표시

# def current_date() -> str:
#     date = datetime.now()
#     current_time = date.replace(tzinfo=timezone(constants.KST))  # 타임존을 한국시간으로 설정
#     return current_time.strftime("%Y_%m_%d")             #표시 양식을 2023_08_11 으로 표시

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


def save_res_convert_csv_to_json(current_date: str, dir_path: str, result_dict: object, file_form: str):
    """
        save_results.
            Args:
                current_date : 저장된 날짜.
                dir_path : detail , pre , link 구분
                result_dict : 읽어올 파일명 ex)  'whisky_colloctor_detail.csv'
                file_form : 저장할 파일명 형식 ex) 'whisky_colloctor_detail'
            Note:
                수집을 통한 결과 파일을 저장하기 위한 함수
                :type result_dict: object
                :param results_dict_columns:
    """
    
    results = convert_to_df(result_dict)

    if dir_path == 'link/':
        results = remove_duplicated_link(results)

    try:
        results.to_csv('results/' + current_date + '/csv/' + dir_path + file_form + '.csv', index=False)  # 수집결과 csv로 저장

    except OSError:
        os.makedirs('./results/' + current_date + '/csv/' + dir_path)
        results.to_csv('results/' + current_date + '/csv/' + dir_path + file_form + '.csv', index=False)  # 수집결과 csv로 저장

    if dir_path == 'link/':
        result_dict = json.loads(results.to_json())#위스키 링크 중복 수집 문제 임시방편 해결
    try:
        outfile = open('results/' + current_date + '/json/' + dir_path + file_form + '.json', 'w')  # 수집결과 json으로 저장
        json.dump(result_dict, outfile, indent=4)

    except FileNotFoundError:
        os.makedirs('./results/' + current_date + '/json/' + dir_path)
        outfile = open('results/' + current_date + '/json/' + dir_path + file_form + '.json', 'w')  # 수집결과 json으로 저장
        json.dump(result_dict, outfile, indent=4)

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

def extract_time() -> tuple:  # ex)2023_08_16 20:18:33 PM
    """
        extract_time.
            Note:
                write_log()에서 현재 시간을 확인위한 함수
    """
    date = datetime.now()
    current_time = date.replace(tzinfo=timezone(constants.KST))  # 타임존을 한국시간으로 설정
    request_time = current_time.strftime("%Y_%m_%d %H:%M:%S %p")  # 표시 양식을 2023_08_11 14:14:31 PM 으로 표시
    request_date = current_time.strftime("%Y_%m_%d")             #표시 양식을 2023_08_11 으로 표시
    return request_date, request_time