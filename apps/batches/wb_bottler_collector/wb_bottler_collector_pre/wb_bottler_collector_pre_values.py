keys_list = ['bottler_name', 'country', 'whiskies', 'votes', 'rating', 'link']  # 브랜드 초기 정보에서 수집할 컬럼 리스트

bottler_summary_collect_data = dict.fromkeys(keys_list)  # 브랜드 초기 정보에서 수집할 컬럼 딕셔너리 선언

for key in keys_list:  # 딕셔너리 키별 값(value) 초기화
    bottler_summary_collect_data[key] = []

bottler_summary_collect_url = {  # 위스키 베이스 증류소 카테고리 주소 딕셔너리
    'bottler': 'https://www.whiskybase.com/whiskies/bottlers'
}
