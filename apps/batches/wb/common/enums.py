from enum import Enum

# BatchType 열거형 클래스 정의
class BatchType(Enum):
    BRAND_PRE = 'BRAND_PRE'  # 브랜드 사전 정보
    BRAND_DETAIL = 'BRAND_DETAIL'  # 브랜드 상세 정보
    BRAND = 'BRAND'  # 최종 컬랙션에 들어가는 브랜드 정보
    BRAND_WHISKY = 'BRAND_WHISKY'

    BRAND_WHISKY_LINK = 'BRAND_WHISKY_LINK'  # 브랜드 위스키 링크
    BRAND_WHISKY_DETAIL = 'BRAND_WHISKY_DETAIL'  # 브랜드 위스키 상세 정보

    DISTILLERY = 'DISTILLERY'  # 최종 컬랙션에 들어가는 증류소 정보
    DISTILLERY_PRE = 'DISTILLERY_PRE'  # 증류소 사전 정보
    DISTILLERY_DETAIL = 'DISTILLERY_DETAIL'  # 증류소 상세 정보

    DISTILLERY_WHISKY_LINK = 'DISTILLERY_WHISKY_LINK'  # 증류소 위스키 링크
    DISTILLERY_WHISKY_DETAIL = 'DISTILLERY_WHISKY_DETAIL'  # 증류소 위스키 상세 정보
    DISTILLERY_WHISKY = 'DISTILLERY_WHISKY'

    BOTTLER_PRE = 'BOTTLER_PRE'  # 보틀러 사전 정보
    BOTTLER_DETAIL = 'BOTTLER_DETAIL'  # 보틀러 상세 정보
    BOTTLER = 'BOTTLER'  # 최종 컬랙션에 들어가는 보틀러 정보

    BOTTLER_WHISKY_LINK = 'BOTTLER_WHISKY_LINK'  # 보틀러 위스키 링크
    BOTTLER_WHISKY_DETAIL = 'BOTTLER_WHISKY_DETAIL'  # 보틀러 위스키 상세 정보
    BOTTLER_WHISKY = 'BOTTLER_WHISKY'

    WHISKY_MERGE = 'WHISKY_MERGE'
    WHISKY = 'WHISKY'  # 최종 컬랙션에 들어가는 위스키 정보

# CollectionName 열거형 클래스 정의
class CollectionName(Enum):
    WHISKY = 'whisky'  # 위스키 컬렉션
    DISTILLERY = 'distillery'  # 증류소 컬렉션
    BRAND = 'brand'  # 브랜드 컬렉션
    BOTTLER = 'bottler'  # 보틀러 컬렉션
    WHISKY_CATEGORY = 'whisky_category'  # 위스키 카테고리 컬렉션
    TASTETAG = 'taste_tag'  # taste 태그 컬렉션

# BatchExecution 열거형 클래스 정의
class BatchExecution(Enum):
    PRETEST = 'pre_test'  # 사전 테스트
    DAILY = 'daily'  # 평소
    ERRORTEST = 'error_test'  # 오류 테스트
