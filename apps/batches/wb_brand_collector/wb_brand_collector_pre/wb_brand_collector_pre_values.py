keys_list = ['brand_name','country','whiskies','votes','rating','link','wb_rank'] #브랜드 사전 정보에서 수집할 컬럼 리스트

brand_collect_pre_scrap = dict.fromkeys(keys_list)                      #브랜드 사전 정보에서 수집할 컬럼 딕셔너리 선언

for key in keys_list:                                                   #딕셔너리 키별 값(value) 초기화
    brand_collect_pre_scrap[key] = []

brand_collect_pre_url = {                                               # 위스키 베이스 브랜드 카테고리 주소 딕셔너리
    'brand' : 'https://www.whiskybase.com/whiskies/brands'
}

