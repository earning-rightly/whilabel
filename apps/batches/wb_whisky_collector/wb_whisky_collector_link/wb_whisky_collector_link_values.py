keys_list = ['whisky_link']                              #위스키 링크 수집할 컬럼 리스트

whisky_collect_link_scrap = dict.fromkeys(keys_list)     #위스키 링크 수집할 컬럼 딕셔너리 선언
for key in keys_list:
    whisky_collect_link_scrap[key] = []                  # 딕셔너리 키 에대한 벨류 값 입력

