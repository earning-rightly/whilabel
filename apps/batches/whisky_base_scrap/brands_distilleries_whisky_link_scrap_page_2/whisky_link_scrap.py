import sys,os
sys.path.append((os.path.abspath(os.path.dirname(__file__)))) # 상위폴더위치로 이동
print(os.getcwd())
import whisky_link_scrap_value
import whisky_link_scrap_func
from datetime import datetime
from pytz import timezone
def extract_time():
    date = datetime.now()
    current_time = date.replace(tzinfo=timezone(whisky_link_scrap_value.KST))
    current_time = current_time.strftime("%Y_%m_%d %H:%M:%S %p")
    return current_time
def undifine_page_2_whisky_link(mode = 'distillery'):  #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery
    print("start srap_page_2 [whisky_link]")
    whisky_link_scrap_func.write_log(current_time=extract_time(), mode=mode, log_mode='start')

    whisky_link_scrap_func.initserilized_value(mode)
    whisky_link_scrap_func.save_results(mode=mode)
    whisky_link_scrap_func.write_log(current_time=extract_time(),mode = mode, log_mode= 'end')
    print("end srap_page_2 [whisky_link]")
