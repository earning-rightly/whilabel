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
from apps.appsbatches.wb_distillery_collector.wb_whisky_belonging_to_distillery_collector.wb_whisky_collector_detail.wb_whisky_detail_belonging_to_distillery_collector_execution import whisky_detail_distillery_collector_executions


scheduler = BackgroundScheduler()

scheduler.start()
