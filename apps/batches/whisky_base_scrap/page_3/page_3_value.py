KST = 'Asia/Seoul' #timezone setting


whiskey_name_list  = []
whiskey_base_id_list = []
category_list = []
distillery_list = []
bottler_list = []
bottled_list = []
strength_list = []
size_list = []
label_list = []
market_list = []
added_on_list = []
calculated_age_list = []
casknumber_list = []
barcode_list = []
casktype_list = []
bottleing_serie_list = []
number_of_bottles_list = []
vintage_list = []
bottled_for_list = []
over_rating_list = []
votes_list = []
Stated_Age_list = []
Bottle_code_list = []
photo_list =  []
votes_rating_current = []
block_price_list = []
tag_name_list = []
taste_dict_list = []

searching_col_dist = {'Whiskybase ID' : whiskey_base_id_list,
'Category' : category_list,
'Distillery' : distillery_list,
'Bottler' : bottler_list,
'Bottled' : bottled_list,
'Strength' : strength_list,
'Size' : size_list,
'Label' : label_list,
'Market' : market_list,
'Added on' : added_on_list,
'Calculated age' : calculated_age_list,
'Casknumber' : casknumber_list,
'Barcode' : barcode_list,
'Casktype' :casktype_list,
'Bottling serie' : bottleing_serie_list,
'Number of bottles' : number_of_bottles_list,
'Vintage' : vintage_list,
'Bottled for' : bottled_for_list,
'Stated Age' : Stated_Age_list,
'Bottle code' : Bottle_code_list,
#'votes-rating-current' : votes_rating_current,
'block-price' : block_price_list,
'tag-name' : tag_name_list,
'taste_dict' : taste_dict_list}
#'Overall rating' : over_rating_list,
#'votes' : votes_list         }

whisky_data_to_df = {'Whiskybase ID' : whiskey_base_id_list,
'Category' : category_list,
'Distillery' : distillery_list,
'Bottler' : bottler_list,
'Bottled' : bottled_list,
'Strength' : strength_list,
'Size' : size_list,
'Label' : label_list,
'Market' : market_list,
'Added on' : added_on_list,
'Calculated age' : calculated_age_list,
'Casknumber' : casknumber_list,
'Barcode' : barcode_list,
'Casktype' :casktype_list,
'Bottling serie' : bottleing_serie_list,
'Number of bottles' : number_of_bottles_list,
'Vintage' : vintage_list,
'Bottled for' : bottled_for_list,
'Stated Age' : Stated_Age_list,
'Bottle code' : Bottle_code_list,
'votes-rating-current' : votes_rating_current,
'block-price' : block_price_list,
'tag-name' : tag_name_list,
 'photo' : photo_list ,
'taste_rank' : taste_dict_list,
'Overall rating' : over_rating_list,
'votes' : votes_list}