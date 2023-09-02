from enum import Enum

class BatchType(Enum):
    BRAND_PRE = 'BRAND_PRE'
    BRAND_DETAIL = 'BRAND_DETAIL'
    BRAND_WHISKY_LINK = 'BRAND_WHISKY_LINK'
    BRAND_WHISKY_DETAIL = 'BRAND_WHISKY_DETAIL'
    DISTILLERY_PRE = 'DISTILLERY_PRE'
    DISTILLERY_DETAIL = 'DISTILLERY_DETAIL'
    DISTILLERY_WHISKY_LINK = 'DISTILLERY_WHISKY_LINK'
    DISTILLERY_WHISKY_DETAIL = 'DISTILLERY_WHISKY_DETAIL'
    # TODO: Bottler Batch 추가

class CollectionName(Enum):
    WHISKY = 'whisky'
    DISTILLERY = 'distillery'
    BRAND = 'brand'
    # TODO: Bottler Collection 추가