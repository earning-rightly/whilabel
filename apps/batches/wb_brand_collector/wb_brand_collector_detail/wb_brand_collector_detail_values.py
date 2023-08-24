
keys_list = ['country','website','region']           #브랜드 상세 정보에서 수집할 컬럼 리스트

brand_collect_detail_scrap = dict.fromkeys(keys_list) #브랜드 상세 정보에서 수집할 컬럼 리스트

for key in keys_list:                                #딕셔너리 키별 값(value) 초기화
   brand_collect_detail_scrap[key] = []
