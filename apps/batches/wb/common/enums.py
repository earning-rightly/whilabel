from enum import Enum

# BatchType 열거형 클래스 정의
class BatchType(Enum):
    BRAND_PRE = 'BRAND_PRE'  # 브랜드 사전 정보
    BRAND_DETAIL = 'BRAND_DETAIL'  # 브랜드 상세 정보
    BRAND = 'BRAND'  # 브랜드

    BRAND_WHISKY_LINK = 'BRAND_WHISKY_LINK'  # 브랜드 위스키 링크
    BRAND_WHISKY_DETAIL = 'BRAND_WHISKY_DETAIL'  # 브랜드 위스키 상세 정보

    DISTILLERY = 'DISTILLERY'  # 증류소
    DISTILLERY_PRE = 'DISTILLERY_PRE'  # 증류소 사전 정보
    DISTILLERY_DETAIL = 'DISTILLERY_DETAIL'  # 증류소 상세 정보

    DISTILLERY_WHISKY_LINK = 'DISTILLERY_WHISKY_LINK'  # 증류소 위스키 링크
    DISTILLERY_WHISKY_DETAIL = 'DISTILLERY_WHISKY_DETAIL'  # 증류소 위스키 상세 정보

    BOTTLER_PRE = 'BOTTLER_PRE'  # 보틀러 사전 정보
    BOTTLER_DETAIL = 'BOTTLER_DETAIL'  # 보틀러 상세 정보
    BOTTLER = 'BOTTLER'  # 보플러

    BOTTER_WHISKY_LINK = 'BOTTER_WHISKY_LINK'  # 보틀러 위스키 링크
    BOTTER_WHISKY_DETAIL = 'BOTTER_WHISKY_DETAIL'  # 보틀러 위스키 상세 정보

    WHISKY = 'WHISKY'  # 위스키

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
