import sys,os
sys.path.append((os.path.abspath(os.path.dirname(__file__)))) # 상위폴더위치로 이동
print(os.getcwd())
import page_1_func
import page_1_value
from datetime import datetime
from pytz import timezone

def extract_time():
    date = datetime.now()
    current_time = date.replace(tzinfo=timezone(page_1_value.KST))
    current_time = current_time.strftime("%Y_%m_%d %H:%M:%S %p")
    return current_time
def undifine_page_1(mode = 'distillery'):  #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    print("start undifine_page_1")
    if mode in page_1_value.page_1_url_dict.keys():
        page_1_func.write_log(current_time=extract_time(),mode = mode, log_mode= 'start')

        page_1_func.scrap_page_1(mode= mode)
        page_1_func.save_results(mode= mode)
        page_1_func.write_log(current_time=extract_time(),mode = mode, log_mode= 'end')
        print("end undifine_page_1")
    else:
        print("Check the mode value")