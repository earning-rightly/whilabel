from apps.batches.wb_libs.enums import CollectionName
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
import timeit

from google.cloud.firestore_v1 import FieldFilter

def save_to_firebase(collection_name: CollectionName, data: list, query_field: str, update_field: str):
    """
        save_to_firebase.
            Args:
               collection_name : collection_name (위스키, 증류소, 브랜드 등...)
               data : 저장해야할 데이터 입니다.
               query_field : 업데이트 시 쿼리 할 필드
               update_field : 업데이트 할 필드
            Note:
                fire-base/fire-store에 데이터 를 적재하기 위한 코드 입니다.
    """

    start = timeit.default_timer()  # 시작 시간 기록

    connect_app()

    db = firestore.client()  # firesotore client 생성

    for doc in data:
        query = db.collection(collection_name.value).where(filter=FieldFilter(query_field, '==', doc[query_field])) #wbID로 쿼리 검색
        results = query.get()
        if results == []:  #값이 없을 경우 신규추가
            db.collection(collection_name.value).document(doc[query_field]).set(doc)

        else:   #값이 있을경우
            doc_ref = db.collection(collection_name.value).document(doc[query_field])
            doc_ref.update({update_field: doc[update_field]}) # 특정 필드 업데이트

    stop = timeit.default_timer()  # 종료 시간 기록

    # TODO: logger 로 대체
    print(collection_name.value + "data load to fire store total time taken : " + str(stop - start))  # 총 걸린 시간 출력 (종료 시간 - 시작 시간)

def connect_app():
    cred = credentials.Certificate('whilabel-firebase-adminsdk-wpf10-c0d0c95e63.json')  # sdk키 호출
    if not firebase_admin._apps:  # sdk 키를 가지고  project_id와 같이 firebase_admin연결
        firebase_admin.initialize_app(credential=cred,
                                      options={'projectId': 'whilabel'})
    else:  # 이미 firebase에 연결이 되어있는 경우 get_app을 통해 admin생성
        firebase_admin.get_app()

def extract_to_firebase(collection_name: CollectionName) -> dict:
    """
        extract_to_firebase.
            Args:
               mode : 데이터를 추출해야할 위치 주소 값입니다 (위스키, 증류소, 브랜드 등...)

            Note:
                fire-base/fire-store에 데이터를 가져오기위한 함수

            Return:
                dict
    """
    start = timeit.default_timer()  # 시작 시간 기록

    connect_app()

    db = firestore.client()  # firesotore client 생성
    query = db.collection(collection_name.value)


    stop = timeit.default_timer()  # 종료 시간 기록
    print(collection_name.value + " data load to fire store total time taken : " + str(stop - start))  # 총 걸린 시간 출력 (종료 시간 - 시작 시간)

    for doc in query.stream():
        return doc.to_dict()