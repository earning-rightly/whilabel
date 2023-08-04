# Batch Design

## Pipeline Infra Setting
Side Project -> Spark, ML X

1. Local PC (Intell Mac i9)
    - 원본 데이터를 저장한다면
        - 저장 크기의 한계
            - 외장하드 연결 (512GB 짜리 있긴 함)
                - 외장하드에 주기적 백업
            - 버저닝 주기를 설정 -> 오래된 파일 제거
                - 각각의 데이터에 관해서 원하는 할당량 ex. 위스키는 100G만 허용
            - 데이터 압축 -> 데이터 형식 / 타입에 따라 압축 방식이 달라짐 -> 아직은 필요
        - 데이터 안정성
            - Remote 연결을 통해서 주기적 동기화 (replication)
            - 외장하드에 주기적 백업
            - Cloud에 백업
        - 연결 문제
            - API 호출 Firebase token -> 최종 데이터만 전달
        - 개발하는 환경과 실행하는 환경이 다름
            - git을 통해서 동기화
            - setting 용 자동화 코드
2. GCP -> 20만원 (DB -> cost 너무 높음) k8s -> mysql -> PV Replication
    - volume1 1, 3, 7 -> 4, 5
    - volume2 2, 4 -> 5, 3
    - volume3 5, 6 -> 1, 2, 7
3. Firebase -> FireStorage
    - key-value storage
    - value -> 내부 쿼리가 가능
    - mongoDB 와 비슷하나 추가로 Join 제공
        - if mongo
            1. user 정보를 가져옴
            2. user id 로 whisky_archive 검색
                - whisky 정보가 whisky_archive에 embedding
                - whisky 리스트를 다 긁어서 서버에서 조합해
        - if firestorage
            1. user 정보를 가져옴
            2. user id 로 whisky_archive 를 검색하면서 whisky를 join 해옴
    ```json
    {
        "user" : {
            "jongwon" : {
                "id" : 232433223
                "age" : 26,
                "region" : "korea"
            }
        }
    },
    {
        "whisky_archive" : {
            232433223: [
                {
                    "argbeg ten" : argbeg_ten_pk,
                    "note": {
                        "lemon, sweet, ..."
                    }
                }
            ]
            
        }
    },
    {
        "whisky" : {
            argbeg_ten_pk: {
                "name" : "argbeg ten",
                "age" : "2010",

            }
        }
    }
    ```

## Skillset

### Workflow Management
- Crontab (tiny cron)
- Airflow Local(DAG 작성)
- Jenkins -> Spring 환경에서 많이 씀
- Spring Batch를 쓴다면 Spring Batch에 맡길수도 있음
- 다른거 써보고 싶은게 있으면 알아오기

### Base Platform
- Vanilla Python (request library)
- Pandas
- BS4
- Selenium
- ~~Spark~~
- Spring Batch
- Dask

## Pipeline structure

- 어떻게 퀄리티 좋은 데이터를 뽑아낼거냐
    - 어떻게 pk와 내부 필드들을 구성할지 (relation ship)
    - 어떻게 중복을 제거할지 (중복제거 기준)
    - 어떤 데이터를 저품질로 제거할지
- 각 태스크를 어떻게 구성하고 배치할지 (DAG 구성)
- 작업 주기는 어떻게 할지

## add workflow Management
- Crontab (apscheduler<https://apscheduler.readthedocs.io/en/3.x/userguide.html>)
