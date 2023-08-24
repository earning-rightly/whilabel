keys_list = ['whiskey_name','whiskybase_id','category','distillery','bottler','bottled','strength','size','label','market','added_on','calculated_age','casknumber', 'barcode','casktype',
             'bottling_serie','number_of_bottles','vintage','bottled_for','stated_age','bottle_code','votes-rating-current','block_price','tag_name','photo',
             'overall_rating','votes']                 # 위스키 상세정보 수집할 컬럼 딕셔너리 선언
whisky_collect_detail_scrap = dict.fromkeys(keys_list) #위스키 상세정보 수집할 컬럼 딕셔너리 선언

for key in keys_list:
    whisky_collect_detail_scrap[key] = []             # 딕셔너리 키 에대한 벨류 값 입력