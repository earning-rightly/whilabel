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
            - git을 통해서 동기화 (현재 단계에서 고려 x)
            - setting 용 자동화 코드 (현재 단계에서 고려 x)
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
(* 수집단계여서 전처리 단계때 다시 수정필요.)  

- 어떻게 퀄리티 좋은 데이터를 뽑아낼거냐  
    - 어떻게 pk와 내부 필드들을 구성할지 (relation ship)  
      |제목|내용|설명|  
    |------|---|---|  
    |테스트1|테스트2|테스트3|  
    |테스트1|테스트2|테스트3|  
    |테스트1|테스트2|테스트3|  
          
    - 어떻게 중복을 제거할지 (중복제거 기준)  
      1. whisky_base_id 기준  
        * whisky_base_id를 안가지고 있는 위스키가 너무많음.  
    - 어떤 데이터를 저품질로 제거할지  
      1. whisky or (distilleries, brands) name 이름에 유니코드(로마문자)가 들어가 있어 제거 or 전처리가 필요  
      2. 주소체계 정규화 필요 (나라별 주소 체계와 데이터 형태가 상의함    
        * ['Grace Kellystraat 211325 HC  AlmereNetherlands', 'KigaliRwanda', '286 Bridge StCO 81657 VailUnited States']  
         '286 Bridge StCO 81657 VailUnited States' 로 검색시 검색 X  
         '286 Bridge St CO 81657 Vail United States'로 검색해야 나옴.  
         -> 중간에 br태그로 되어있어 해결가능.  
      3. 가격에대한 정규화.  
          * 위스키 가격이 현재 각 제조사 혹은 브랜드에 맞게 또는 작성자에 의해 단위가 정해짐.
            해당 가격 단위에 대한 정규화가 필요함

      
- 각 태스크를 어떻게 구성하고 배치할지 (DAG 구성)  
  * cron 으로 진행시 DAG 불필요.
  
- 작업 주기는 어떻게 할지  
  -> page_1(brands, distilleries)          : monthly  
  -> page_2 [about] (brands, distilleries) : monthly  
  -> page_2 [whisky link]                  : weekly or 2 weeks  
  -> page_3 (whisky about)                 : weekly  
  * page 3에 해당하는 위스키 정보는 추가및 소멸 또한 존재하여 필요시 소멸또한 진행필요.  


## add workflow Management
- Crontab ([apscheduler]<https://apscheduler.readthedocs.io/en/3.x/userguide.html>)

## add Base Paltform
- asyncio             : 비동기 처리
- cfscrape or aiohttp :  session을 통해 웹 연결
- BeautifulSoup       : 웹 태그 및 클래스명 검색 및 수집
- pandas              : 데이터 읽고 쓰기
- tqdm                : 비동기 및 순환 처리에 대한 처리율(백분율) 표시

