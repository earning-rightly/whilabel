import time  # 시간 관련 모듈을 가져옵니다.
from apscheduler.schedulers.background import BackgroundScheduler  # 백그라운드 스케줄러를 가져옵니다.

# brand 정보 수집
from apps.batches.wb.brand.brand_execution import brand_execution
from apps.batches.wb.brand.whisky.whisky_execution import whisky_execution as brand_whisky_execution

from apps.batches.wb.common.enums import BatchExecution, BatchType  # 열거형 상수를 가져옵니다.

# 백그라운드 스케줄러 객체를 생성
scheduler = BackgroundScheduler()

batch_day = {'brand_day': 2}  # 배치 날짜를 설정하는 딕셔너리를 선언합니다.

scheduler.add_job(
    brand_execution,  # 실행할 함수
    'cron',  # 스케줄러 유형 (cron 방식)
    day=batch_day['brand_day'],  # 실행 일자 (배치 날짜 딕셔너리에서 가져옴)
    hour=17,  # 실행 시간 (17시)
    minute=59,  # 실행 분 (59분)
    id="brand_detail_executions",  # 스케줄러 식별자
    timezone='Asia/Seoul'  # 시간대 설정 (서울 시간대)
)

# 'brand_whisky_execution' 함수를 'cron' 스케줄러에 추가합니다.
scheduler.add_job(
    brand_whisky_execution,  # 실행할 함수
    'cron',  # 스케줄러 유형 (cron 방식)
    day=batch_day['brand_day'],  # 실행 일자 (배치 날짜 딕셔너리에서 가져옴)
    hour=20,  # 실행 시간 (20시)
    minute=0,  # 실행 분 (0분)
    id="whisky_brand_executions",  # 스케줄러 식별자
    timezone='Asia/Seoul',  # 시간대 설정 (서울 시간대)
    kwargs={'batch_id': BatchExecution.PRETEST}  # 키워드 인수 설정
)

scheduler.start()  # 스케줄러를 시작합니다.

while True:
    time.sleep(1)  # 무한 루프에서 1초마다 대기합니다.
