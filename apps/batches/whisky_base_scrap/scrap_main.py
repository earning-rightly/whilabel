import time
from apscheduler.schedulers.background import BackgroundScheduler

from brands_distilleries_scrap_page_1.page_1_scrap import undifine_page_1
from brands_distilleries_whisky_link_scrap_page_2.whisky_link_scrap import undifine_page_2_whisky_link
from brands_distilleries_about_scrap_page_2.page_2_scrap import undifine_page_2_detail
from page_3.page_3_scrap import undifine_page_3
sched = BackgroundScheduler()
#sched.add_job(undifine_page_1,'cron',day = 10 ,hour = 16 ,minute = 21,id="undifine_page_1",timezone='Asia/Seoul',args=['brand'])
#sched.add_job(undifine_page_1,'interval', seconds=5,id="undifine_page_1",timezone='Asia/Seoul',args=['brand'])
#undifine_page_1()
#undifine_page_1(mode='brand')

#undifine_page_2_detail()
#undifine_page_2_detail(mode='brand')

undifine_page_2_whisky_link(mode='brand')
#undifine_page_2_whisky_link()


#undifine_page_3(mode='brand')
#undifine_page_3(mode='brand')

#시간체크하기
#전체파일 수집 전체 재수집
#전체파일 보고 전처리 혹은 테이블 분리하기


#           brand     :   dis  [time]
#page 1     0 [8sec]      0 [5sec]
#page 2     0 [8min]      0 x
#page 2 lk  0       0
#page 3     ?       ?
print("pre_process start")
sched.start()

while True:
    print("pre_process doing")
    time.sleep(1)