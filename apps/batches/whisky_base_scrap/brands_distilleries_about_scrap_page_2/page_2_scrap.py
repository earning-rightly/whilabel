import sys,os
sys.path.append((os.path.abspath(os.path.dirname(__file__))))
import page_2_func
import page_2_value
from datetime import datetime
from pytz import timezone
import logging
import traceback

logging.basicConfig(filename='./test.log', level=logging.ERROR)
def extract_time():
    date = datetime.now()
    current_time = date.replace(tzinfo=timezone(page_2_value.KST))
    current_time = current_time.strftime("%Y_%m_%d %H:%M:%S %p")
    return current_time
def undifine_page_2_detail(mode = 'distillery'):  #mode allows you to choose between distilleries and brands to collect { mode : distillery, brand} * default = distillery

    print("start srap_page_2 [detail]")
#try:
    page_2_func.write_log(current_time=extract_time(), mode=mode, log_mode='start')
    page_2_func.initserilized_value(mode)
    page_2_func.save_results(mode=mode)
    page_2_func.write_log(current_time=extract_time(),mode = mode, log_mode= 'end')
   # except Exception:
    #    logging.error(traceback.format_exc())
    print("end srap_page_2 [detail]")
