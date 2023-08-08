
KST = 'Asia/Seoul' #timezone setting

company_about_list = []
company_address_list = []
Capacity_per_year_list = []
Closed_list = []
Collection_list = []
Country_list = []
Founded_list = []
Owner_list = []
Rating_list = []
Specialists_list = []
Spirit_stills_list = []
Status_list = []
Views_list = []
Vote_list = []
Votes_list = []
WB_Ranking_list = []
Wash_stills_list = []
Website_list = []
Whiskies_list = []
Wishlist_list=[]
Region_list = []

brands_searching_col_dist = {
 'Country' : Country_list,
 'Website' : Website_list,
 'Region' : Region_list
}

distillery_searching_col_dist = {
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


brands_to_df_dist = {
 'Country' : Country_list,
 'Website' : Website_list,
 'Region' : Region_list
}


distillery_to_df_dict = {
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