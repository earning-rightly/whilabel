import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import timeit

from google.cloud.firestore_v1 import FieldFilter


def data_load_to_fire_base(mode: str, raw_data: list,update_key : str):
    """
        data_load_to_fire_base.
            Args:
               mode : 저정해야할 위치 주소 값입니다 (위스키, 증류소, 브랜드 등...)
               raw_data : 저장해야할 데이터 입니다.
               update_key : 업데이트 해야할 컬럼

            Note:
                fire-base/fire-store에 데이터 를 적재하기 위한 코드 입니다.
    """
    start = timeit.default_timer()  # 시작 시간 기록

    cred = credentials.Certificate('whilabel-firebase-adminsdk-wpf10-c0d0c95e63.json')  # sdk키 호출
    if not firebase_admin._apps:  # sdk 키를 가지고  project_id와 같이 firebase_admin연결
        firebase_admin.initialize_app(credential=cred,
                                      options={'projectId': 'whilabel'})
    else:  # 이미 firebase에 연결이 되어있는 경우 get_app을 통해 admin생성
        firebase_admin.get_app()
    db = firestore.client()  # firesotore client 생성

    mode = mode.replace('wb_','')  # firestore 형태로 mode에서 wb_ 제거

    for data in raw_data:
        query = db.collection(mode).where(filter=FieldFilter('wbId', '==', data['wbId'])) #wbID로 쿼리 검색
        results = query.get()
        if results == []:  #값이 없을 경우 신규추가
            db.collection(mode).document(data['wbId']).set(data)

        else:   #값이 있을경우
            doc_ref = db.collection(mode).document(data['wbId'])
            doc_ref.update({                #update key 에 해당하는 컬럼만 업데이트
                update_key: data[update_key]})

    stop = timeit.default_timer()  # 종료 시간 기록
    print(mode + "data load to fire store total time taken : " + str(stop - start))  # 총 걸린 시간 출력 (종료 시간 - 시작 시간)



