keys_list = ['company_about', 'company_address', 'closed', 'collection', 'country', 'founded','abbreviation',
             'rating', 'specialists', 'status', 'vote', 'votes', 'wb_ranking', 'website', 'whiskies',
             'views']  # 증류소 상세 정보에서 수집할 컬럼 리스트

bottler_collect_detail_scrap = dict.fromkeys(keys_list)  # 증류소 상세 정보에서 수집할 컬럼 리스트

for key in keys_list:  # 증류소 키별 값(value) 초기화
    bottler_collect_detail_scrap[key] = []
