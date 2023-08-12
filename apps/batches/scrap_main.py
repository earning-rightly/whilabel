import time
from apscheduler.schedulers.background import BackgroundScheduler

#브랜드, 증류소 사전 정보 수집
from apps.batches.wb_brand_collector.wb_brand_collector_pre.wb_brand_collector_pre_execution import brand_pre_executions
from apps.batches.wb_distillery_collector.wb_distillery_collector_pre.wb_distillery_collector_pre_execution import distillery_pre_executions

#브랜드, 증류소 상세정보 수집
from apps.batches.wb_brand_collector.wb_brand_collector_detail.wb_brand_collector_detail_execution import brand_detail_executions
from apps.batches.wb_distillery_collector.wb_distillery_collector_detail.wb_distillery_collector_detail_execution import distillery_detail_executions

#위스키 링크 수집
from apps.batches.wb_distillery_collector.wb_whisky_belonging_to_distillery_collector.wb_whisky_collector_link.wb_whisky_link_belonging_to_distillery_collector_execution import whisky_link_distillery_collector_executions
from apps.batches.wb_brand_collector.wb_whisky_belonging_to_brand_collector.wb_whisky_collector_link.wb_whisky_link_belonging_to_brand_collector_execution import whisky_link_brand_collector_executions
#위스키 상세정보 수집
from apps.batches.wb_brand_collector.wb_whisky_belonging_to_brand_collector.wb_whisky_collector_detail.wb_whisky_detail_belonging_to_brand_collector_execution import whisky_detail_brand_collector_executions
from apps.batches.wb_distillery_collector.wb_whisky_belonging_to_distillery_collector.wb_whisky_collector_detail.wb_whisky_detail_belonging_to_distillery_collector_execution import whisky_detail_distillery_collector_executions


sched = BackgroundScheduler()

#스케줄링 거는 방법 ex)
sched.add_job(brand_pre_executions,'cron',day = 10 ,hour = 16 ,minute = 21,id="undifine_page_1",timezone='Asia/Seoul',args=['brand'])
sched.add_job(brand_pre_executions,'interval', seconds=5,id="undifine_page_1",timezone='Asia/Seoul',args=['brand'])

#브랜드, 증류소 사전 정보 수집
brand_pre_executions()
distillery_pre_executions()

#브랜드, 증류소 상세정보 수집
brand_detail_executions()
distillery_detail_executions()

#위스키 링크 수집
whisky_link_brand_collector_executions()
whisky_link_distillery_collector_executions()

#위스키 상세정보 수집
whisky_detail_brand_collector_executions()
whisky_detail_distillery_collector_executions()

print("pre_process start")
sched.start()   #스케줄링 시작

while True:
    #print("pre_process doing")
    time.sleep(1)