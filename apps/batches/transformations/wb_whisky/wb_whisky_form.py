import pandas as pd
import numpy as np


def make_whisky_id(table: pd.Series) -> int:  # fusion 가능
    """
        make_whisky_id
            Args:
               table : 변경해야할 판다스 시리스(한 행)

            Note:
                link주소값에서 위스키 id 값을 추출하여 해당 값 반환
    """
    try:
        return table.link.split('/')[-2]  # 위스키 id 값 추출

    except IndexError:  # link값이 없는경우 null 반환
        return None


def remove_void_space_whiksy_name(table):
    """
       remove_void_space_whiksy_name
           Args:
              table : 변경해야할 판다스 시리스(한 행)

           Note:
               수집된 위스키 이름에서 빈칸 제거
   """
    try:
        return table.whisky_name.replace('\n', '').replace('\t', '')  # 위스키 이름에서 탭 또는 빈칸제거
    except AttributeError:  # 위스키 이름이 없는경우
        return None  # null 반환


def make_taste_tags(table):
    """
       make_taste_tags
           Args:
              table : 변경해야할 판다스 시리스(한 행)

           Note:
               수집된 위스키 taste tags 형태변환
   """
    try:
        taste_tags = eval(table.distillery)  # taste tags 형태 dict로 변환
        taste_tag_name_list = list(taste_tags.keys())  # taste tags  명 추출
        taste_tag_vote_list = list(taste_tags.values())  # taste tags 링크 추출
        return {'tag_name': taste_tag_name_list, 'taste_votes': taste_tag_vote_list}  # 저장해야할 taste tags 포맷 반환

    except TypeError:  # 변환해야할 dict가 없을때
        return None  # null반환


def make_distillery_information(table):
    """
          make_distillery_information
              Args:
                 table : 변경해야할 판다스 시리스(한 행)

              Note:
                수집된 위스키에 대한 증류소 정보를 저장
      """

    try:
        distillery_name_list = list(table.distillery.keys())
        distillery_link_list = list(table.distillery.values())
        distillery_id_list = []
        for link in distillery_link_list:
            distillery_id_list.append(link.split('/')[-2])
        return {'distillery_id': distillery_id_list, 'distillery_name': distillery_name_list,
                'distillery_link': distillery_link_list}
    except AttributeError:
        return None


def remake_size(table):
    try:
        return table.size.split(' ml')
    except AttributeError:
        return None


def remake_block_price(table):
    try:
        price_list = table.block_price.split(' ')
        return {'unit': price_list[0], 'price': price_list[1]}
    except AttributeError:
        return None


def make_bottled_year(table):
    try:
        if 4 < len(table.bottled):
            return table.bottled.split('.')[-1]
        else:
            return table.bottled
    except TypeError:
        return None


def make_vintage_year(table):
    try:
        if 4 < len(table.vintage):
            return table.vintage.split('.')[-1]
        else:
            return table.vintage
    except TypeError:
        return None


def remake_strength(table):
    try:
        return table.strength.split('%')[0]

    except TypeError:
        return None


def remake_overall_rate(table):
    return float(table.overall_rating.split('/')[0])


def replace_extracted_data_with_wb_whisky_formmat(extract_data: dict) -> dict:
    whisky_data = pd.DataFrame.from_dict(data=extract_data, orient='columns')

    whisky_data['whisky_name'] = whisky_data.apply(remove_void_space_whiksy_name, axis=1)
    whisky_data['wb_whisky_id'] = whisky_data.apply(make_whisky_id, axis=1)
    whisky_data['distillery_information'] = whisky_data.apply(make_distillery_information, axis=1)
    whisky_data['bottled_year'] = whisky_data.apply(make_bottled_year, axis=1)
    whisky_data['taste_tags'] = whisky_data.apply(make_taste_tags, axis=1)
    whisky_data['strength'] = whisky_data.apply(remake_strength, axis=1)
    whisky_data['size'] = whisky_data.apply(remake_size, axis=1)
    whisky_data['vintage_year'] = whisky_data.apply(make_vintage_year, axis=1)
    whisky_data['price_information'] = whisky_data.apply(remake_block_price, axis=1)
    whisky_data['overall_rating'] = whisky_data.apply(remake_overall_rate, axis=1)

    whisky_data = whisky_data[
        ['wb_whisky_id', 'whisky_name', 'distillery_information', 'category', 'bottler', 'bottled_year', 'strength',
         'size', 'label', 'market'
            , 'added_on', 'calculated_age', 'casknumber', 'barcode', 'casktype', 'bottling_serie'
            , 'number_of_bottles', 'vintage_year', 'stated_age', 'bottle_code', 'price_information', 'photo',
         'taste_tags', 'overall_rating', 'votes']]
    whisky_data.rename(columns={'casknumber': 'cask_number', 'casktype': 'cask_type'}, inplace=True)
    whisky_data = whisky_data.replace({np.nan: None})
    return result_df.to_json()

'''
	"wb_whisky" : { // 위스키 상세정보 (브랜드 수집결과 + 증류소 수집결과)
		"wb_whisky_id"        : string,             // wb 위스키 id - WB144157
		"category"            : string,             // 위스키 카테고리 - Blend / Single Malt
		"distillery_information" : {
            "distillery_id" : int,                  // 198
			"distillery_name" : string,             // Bushmills, Midleton
			"distillery_link" : string,             // https://www.whiskybase.com/whiskies/distillery/198
		},
		"bottler"             : string,             // Distillery Bottling
		"bottled"             : int,                // 2019
		"strength"            : string,             // 54.3 % Vol.
		"size"                : string,             // 700 ml
		"label"               : string,             // 2 Proof
		"market"              : string,             // United States       
		"added_on"            : string,             // 04 dec 2019 10:52 pm by DolcainWhiskey (*Embedded link not scrapped)
		"calculated_age"      : int,                // 
		"cask_number" 		  : int,                // 002010
		"barcode"             : int,                // 5011007006235
		"cask_type"            : string,             // Sauterne
		"bottling_serie"      : string,             // X
		"number_of_bottles"   : int,                // 120
		"vintage"             : int,                // 2019
		"bottled_for"         : string,             // Whiskey Live 2019 / Down Syndrome Ireland Charity
		"stated_age"          : string,             // 10 years old
		"bottle_code"         : string,             // L3148509308153
		"block_price"         : string,             // € 150.00
        "photo"               : string,             // "https://static.whiskybase.com/storage/whiskies/1/4/4157/242229-big.jpg"
        "taste_tags" : [
            {
                "tag_name" : string,                // chocolate
                "taste_votes" : int                 // 9
            },
        ],
		"overall_rating"      : sting,              // 82.00/100
		"votes"               : int                 // 1
	}
'''
