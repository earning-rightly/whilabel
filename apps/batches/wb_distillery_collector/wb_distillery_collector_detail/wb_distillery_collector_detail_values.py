
keys_list = ['company_about', 'company_address', 'capacity_per_year', 'closed', 'collection', 'country', 'founded', 'owner', 'rating','specialists', 'spirit_stills', 'status',
             'Views','vote', 'votes', 'wb_ranking', 'wash_stills', 'website', 'whiskies', 'wishlist', 'region']  #증류소 상세 정보에서 수집할 컬럼 리스트

distillery_collect_detail_scrap = dict.fromkeys(keys_list)  #증류소 상세 정보에서 수집할 컬럼 리스트

for key in keys_list:                                      #증류소 키별 값(value) 초기화
   distillery_collect_detail_scrap[key] = []


