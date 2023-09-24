import time
from apscheduler.schedulers.background import BackgroundScheduler

# 브랜드, 증류소, bottler 상세정보 수집
from apps.batches.wb.brand.brand_execution import brand_execution
from apps.batches.wb.distillery.distillery_execution import distillery_execution
from apps.batches.wb.bottler.bottler_execution import bottler_execution

# 브랜드, 증류소, bottler 위스키 링크 수집
from apps.batches.wb_distillery_collector.wb_whisky_belonging_to_distillery_collector.wb_whisky_collector_link.wb_whisky_link_belonging_to_distillery_collector_directed_acyclic_execution import \
    whisky_link_distillery_collector_executions
from apps.batches.wb_brand_collector.wb_whisky_belonging_to_brand_collector.wb_whisky_collector_link.wb_whisky_link_belonging_to_brand_collector_directed_acyclic_execution import \
    whisky_link_brand_collector_executions
from apps.batches.wb_bottler_collector.wb_whisky_belonging_to_bottler_collector.wb_whisky_collector_link.wb_whisky_link_belonging_to_bottler_collector_directed_acyclic_execution import \
    whisky_link_bottler_collector_executions

# 브랜드, 증류소, bottler 위스키 상세정보 수집
from apps.batches.wb_brand_collector.wb_whisky_belonging_to_brand_collector.wb_whisky_collector_detail.wb_whisky_detail_belonging_to_brand_collector_directed_acyclic_execution import \
    whisky_detail_brand_collector_executions
from apps.batches.wb_distillery_collector.wb_whisky_belonging_to_distillery_collector.wb_whisky_collector_detail.wb_whisky_detail_belonging_to_distillery_collector_directed_acyclic_execution import \
    whisky_detail_distillery_collector_executions
from apps.batches.wb_bottler_collector.wb_whisky_belonging_to_bottler_collector.wb_whisky_collector_detail.wb_whisky_detail_belonging_to_bottler_collector_directed_acyclic_execution import \
    whisky_detail_bottler_collector_executions

from apps.batches.wb.common.enums import BatchExecution, BatchType

scheduler = BackgroundScheduler()

batch_day = {'brand_day': 31, 'distillery_day': 1, 'bottler_day': 2}  # 배치 날짜 딕셔너리 선언

scheduler.add_job(
    brand_execution,
    'cron',
    day=batch_day['brand_day'],
    hour=16,
    minute=12,
    id="brand_detail_executions",
    timezone='Asia/Seoul'
)
scheduler.add_job(
    whisky_link_brand_collector_executions,
    'cron',
    day=batch_day['brand_day'],
    hour=18,
    minute=40,
    id="whisky_link_brand_collector_executions",
    timezone='Asia/Seoul',
    kwargs={'batch_type': BatchType.BRAND_WHISKY_LINK}
)
scheduler.add_job(
    whisky_detail_brand_collector_executions,
    'cron',
    day=batch_day['brand_day'],
    hour=23,
    minute=30,
    id="whisky_detail_brand_collector_executions",
    timezone='Asia/Seoul',
    kwargs={'batch_type': BatchType.BRAND_WHISKY_DETAIL, 'batch_id': BatchExecution.PRETEST}
)

scheduler.add_job(
    distillery_execution,
    'cron',
    day=batch_day['distillery_day'],
    hour=17,
    minute=59,
    id="distillery_detail_execution",
    timezone='Asia/Seoul'
)
scheduler.add_job(
    whisky_link_distillery_collector_executions,
    'cron',
    day=batch_day['distillery_day'],
    hour=20,
    minute=0,
    id="whisky_link_distillery_collector_executions",
    timezone='Asia/Seoul',
    kwargs={'batch_type': BatchType.DISTILLERY_WHISKY_LINK}
)
scheduler.add_job(
    whisky_detail_distillery_collector_executions,
    'cron',
    day=batch_day['distillery_day'],
    hour=23,
    minute=59,
    id="whisky_detail_distillery_collector_executions",
    timezone='Asia/Seoul',
    kwargs={'batch_type': BatchType.DISTILLERY_WHISKY_DETAIL, 'batch_id': BatchExecution.PRETEST}
)

scheduler.add_job(
    bottler_execution,
    'cron',
    day=batch_day['bottler_day'],
    hour=17,
    minute=59,
    id="bottler_detail_executions",
    timezone='Asia/Seoul'
)

scheduler.add_job(
    whisky_link_bottler_collector_executions,
    'cron',
    day=batch_day['bottler_day'],
    hour=20,
    minute=0,
    id="whisky_link_bottler_collector_executions",
    timezone='Asia/Seoul',
    kwargs={'batch_type': BatchType.BOTTER_WHISKY_LINK}
)
scheduler.add_job(
    whisky_detail_bottler_collector_executions,
    'cron',
    day=batch_day['bottler_day'],
    hour=23,
    minute=59,
    id="whisky_detail_bottler_collector_executions", timezone='Asia/Seoul',
    kwargs={'batch_type': BatchType.BOTTER_WHISKY_DETAIL, 'batch_id': BatchExecution.PRETEST}
)

scheduler.start()

while True:
    time.sleep(1)
