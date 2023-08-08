distillery_name_list = []          #증류소명 리스트
country_list = []                  #나라명 리스트
whiskies_list = []                 #위스키갯수 리스트
votes_list = []                    #투표수 리스트
rating_list = []                   #투표 평균점수 리스트
link_list = []                     #증류소 링크 리스트
wb_rank_list = []                  #whisky base 랭크

KST = 'Asia/Seoul'                 #timezone 설정

distillery_collec_early_scrap_dict = {         #증류소 초기정보 수집 딕셔너리
    'distillery_name' : distillery_name_list,
    'country' : country_list,
    'whiskies' : whiskies_list,
    'votes' : votes_list,
    'rating' : rating_list,
    'link' : link_list
}

distillery_collec_early_url_dict = {           # 위스키 베이스 증류소 카테고리 주소 딕셔너리
    'distillery' :'https://www.whiskybase.com/whiskies/distilleries'
}

