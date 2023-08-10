company_about_list = []             #증류소 관련 정보 리스트
company_address_list = []           #증류소 주소 정보 리스트
Capacity_per_year_list = []           #?
Closed_list = []        #증류소 상태 정보 리스트?
Collection_list = []    #증류소 주소 정보 리스트
Country_list = []       #증류소 나라 정보 리스트
Founded_list = []       #증류소 창립날짜 정보 리스트
Owner_list = []         #증류소 소유자정보 리스트
Rating_list = []        #증류소 평점 정보 리스트
Specialists_list = []   #증류소 관련정보 리스트
Spirit_stills_list = [] #?
Status_list = []        #증류소 상태 정보 리스트?
Views_list = []         #방문 횟수 리스트
Vote_list = []          #투표수 리스트(트표수가 하나일때)
Votes_list = []         #투표수 리스트(트표수가 복수일때)
WB_Ranking_list = []    #whisky base 랭크 리스트
Wash_stills_list = []   #?
Website_list = []       #증류소 홈페이지 리스트
Whiskies_list = []      #?
Wishlist_list=[]        #?
Region_list = []           #증류소 지역 정보 리스트

distillery_collec_detail_scrap_dict = {   #수집할 리스트를 딕셔너리(json)형식으로 변환
'Capacity per year' :Capacity_per_year_list,
 'Closed': Closed_list,
 'Collection' : Collection_list,
 'Country' : Country_list,#
 'Founded' : Founded_list,
 'Owner' : Owner_list,
 'Rating' : Rating_list,#
 'Specialists' : Specialists_list,#
 'Spirit stills' : Spirit_stills_list,
 'Status' : Status_list,#
 'Views' : Views_list,#
 'Vote' : Vote_list,#
 'Votes' : Votes_list,#
 'WB Ranking' : WB_Ranking_list,#
 'Wash stills' : Wash_stills_list,
 'Website' : Website_list,
 'Whiskies' : Whiskies_list,#
 'Wishlist' : Wishlist_list}#


distillery_collec_detail_result_dict = {   #저장할 리스트를 딕셔너리(json)형식으로 변환
'company-about' : company_about_list,
'company-address' : company_address_list,
'Capacity per year' :Capacity_per_year_list,
 'Closed': Closed_list,
 'Collection' : Collection_list,
 'Country' : Country_list,#
 'Founded' : Founded_list,
 'Owner' : Owner_list,
 'Rating' : Rating_list,#
 'Specialists' : Specialists_list,#
 'Spirit stills' : Spirit_stills_list,
 'Status' : Status_list,#
 'Views' : Views_list,#
 'Vote' : Vote_list,#
 'Votes' : Votes_list,#
 'WB Ranking' : WB_Ranking_list,#
 'Wash stills' : Wash_stills_list,
 'Website' : Website_list,
 'Whiskies' : Whiskies_list,#
 'Wishlist' : Wishlist_list,
 'Region' : Region_list}##