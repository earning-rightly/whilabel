brand_name_list = []               #브랜드명 리스트
country_list = []                  #나라명 리스트
whiskies_list = []                 #위스키갯수 리스트
votes_list = []                    #투표수 리스트
rating_list = []                   #투표 평균점수 리스트
link_list = []                     #증류소 링크 리스트
wb_rank_list = []                  #whisky base 랭크

brnad_collec_early_scrap_dict = {         #수집할 리스트를 딕셔너리(json)형식으로 변환
    'distillery_name' : brand_name_list,
    'country' : country_list,
    'whiskies' : whiskies_list,
    'votes' : votes_list,
    'rating' : rating_list,
    'link' : link_list
}

brand_collec_early_result_dict = {         #저장할 리스트를 딕셔너리(json)형식으로 변환
    'distillery_name' : brand_name_list,
    'country' : country_list,
    'whiskies' : whiskies_list,
    'votes' : votes_list,
    'rating' : rating_list,
    'link' : link_list
}

brand_collec_early_url_dict = {           # 위스키 베이스 증류소 카테고리 주소 딕셔너리
    'brand' : 'https://www.whiskybase.com/whiskies/brands'
}

