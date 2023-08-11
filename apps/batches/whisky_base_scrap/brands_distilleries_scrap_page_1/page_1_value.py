
distillery_name_list = []          #증류소명 리스트
country_list = []                  #나라명 리스트
whiskies_list = []                 #위스키갯수 리스트
votes_list = []                    #투표수 리스트
rating_list = []                   #투표 평균점수 리스트
link_list = []                     #증류소 링크 리스트
wb_rank_list = []
KST = 'Asia/Seoul' #timezone setting

data = {
    'distillery_name' : distillery_name_list,
    'country' : country_list,
    'whiskies' : whiskies_list,
    'votes' : votes_list,
    'rating' : rating_list,
    'link' : link_list
}

page_1_url_dict = {
    'distillery' :'https://www.whiskybase.com/whiskies/distilleries',
    'brand' : 'https://www.whiskybase.com/whiskies/brands'
}

