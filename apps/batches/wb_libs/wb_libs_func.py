import json
import pandas as pd
from datetime import datetime
from pytz import timezone
from apps.batches.wb_libs import wb_libs_values
def write_log(current_time, log_mode, mode, level):
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
    def start():
        try:
            with open("log.txt", "a") as file:
                try:
                    file.write('\nstart time : ' + str(current_time) + '\nmode : '+ mode +'\nlevel : '+level)
                finally:
                    file.close()
        except IOError:
            print('Unable to create file on disk. \nmode : '+ mode +'\nlevel : '+level)

    def end():
        try:
            with open("log.txt", "a") as file:
                try:
                    file.write('\nfinish time : ' + str(current_time) + '\nmode : '+ mode +'\nlevel : '+level)
                finally:
                    file.close()
        except IOError:
            print('Unable to create file on disk. \nmode : '+ mode +'\nlevel : '+level)

    if log_mode == 'start':
        start()
    elif log_mode == 'end':
        end()

def save_results(result_dict, file_form):
    """
        save_results.
            Args:
                result_dict : 읽어올 파일명 ex)  'whisky_colloctor_detail.csv'
                file_form : 저장할 파일명 형식 ex) 'whisky_colloctor_detail'
            Note:
                수집을 통한 결과 파일을 저장하기 위한 함수
    """
    results = pd.DataFrame(result_dict)
    results.to_csv(file_form+'.csv',index=False)  #수집결과 csv로 저장
    try:
        with open(file_form+'.json', 'w') as outfile:   #수집결과 json으로 저장
            try:
                json.dump(result_dict, outfile, indent=4)
            finally:
                outfile.close()
    except IOError:
        print('Unable to create file on disk. file_form : '+file_form)

def reset_list_size(length, scrap_dict): #수정필요
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

def extract_time():
    """
            extract_time.
                Note:
                    write_log()에서 현재 시간을 확인위한 함수
        """
    date = datetime.now()
    current_time = date.replace(tzinfo=timezone(wb_libs_values.KST))   #타임존을 한국시간으로 설정
    current_time = current_time.strftime("%Y_%m_%d %H:%M:%S %p")       #표시 양식을 2023_08_11 14:14:31 PM으로 표시
    return current_time