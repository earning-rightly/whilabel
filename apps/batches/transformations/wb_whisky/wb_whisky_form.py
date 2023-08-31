import pandas as pd
import numpy as np
import json

def make_whisky_id(table: pd.Series) -> int or None:  # fusion 가능
    """
        make_whisky_id
            Args:
               table : 변경해야할 판다스 시리스(한 행)

            Note:
                link주소값에서 위스키 id 값을 추출하여 해당 값 반환

            Return:
                int
    """
    if type(table.link) != type(None):
        return table.link.split('/')[-2]  # 위스키 id 값 추출
    else:
        print(table.link)
        return None

def remove_void_space_whiksy_name(table: pd.Series) -> str or None:
    """
       remove_void_space_whiksy_name
           Args:
              table : 변경해야할 판다스 시리스(한 행)

           Note:
               수집된 위스키 이름에서 빈칸 제거

           Return:
               str
   """
    if type(table.whisky_name) != type(None):
        return table.whisky_name.replace('\n', '').replace('\t', '')  # 위스키 이름에서 탭 또는 빈칸제거
    else:
        return None

def make_taste_tags(table: pd.Series) -> dict or None:
    """
       make_taste_tags
           Args:
              table : 변경해야할 판다스 시리스(한 행)

           Note:
               수집된 위스키 taste tags 형태변환

            Return:
                dict
   """
    if type(table.tag_name) != type(None):
        taste_tags = table.tag_name  # taste tags 형태 dict로 변환
        taste_tag_name_list = list(taste_tags.keys())  # taste tags  명 추출
        taste_tag_vote_list = list(taste_tags.values())  # taste tags 링크 추출
        return {'tag_name': taste_tag_name_list, 'taste_votes': taste_tag_vote_list}  # 저장해야할 taste tags 포맷 반환
    else:
        return None



def make_distillery_information(table: pd.Series) -> dict or None:
    """
        make_distillery_information
            Args:
                table : 변경해야할 판다스 시리스(한 행)

            Note:
                수집된 위스키에 대한 증류소 정보를 저장

            Return:
                dict
      """

    if type(table.distillery) != type(None): #distillery type이 none이 아닌경

        distillery_name_list = list(table.distillery.keys())    #컬럼추출
        distillery_link_list = list(table.distillery.values())  #값 추출
        distillery_id_list = []
        for link in distillery_link_list:
            distillery_id_list.append(link.split('/')[-2])
        return {'distillery_id': distillery_id_list, 'distillery_name': distillery_name_list,
                'distillery_link': distillery_link_list}

    else:
        return None



def remake_size(table : pd.Series) -> object or None:
    """
        remake_size
            Args:
                table : 변경해야할 판다스 시리스(한 행)

            Note:
                수집된 위스키 사이즈에 대한 전처리

            Return:
                str
    """
    if type(table.size) != type(None):
        try:
            return table.size.split(' ml')  #' ml'로 size값을 분리하여 반환

        except: #추후 처리 필요
            print(table.size,table.name)

    else:
        return None

def remake_block_price(table : pd.Series) -> dict or None:
    """
        remake_block_price
            Args:
                table : 변경해야할 판다스 시리스(한 행)

            Note:
                block price에 값을 화폐단위와 금액을 분리

            Return:
                dict
    """
    try:
        price_list = table.block_price.split(' ')
        return {'unit': price_list[0], 'price': price_list[1]}

    except AttributeError: #block_price값이 없는경우
        return None


def make_bottled_year(table : pd.Series) -> str or None:
    """
        make_bottled_year
            Args:
                table : 변경해야할 판다스 시리스(한 행)

            Note:
                bottled에서 년도 값만 분리하여 반환

            Return:
                str
    """
    try:
        if 4 < len(table.bottled):
            return table.bottled.split('.')[-1] # .으로 분리하여 맨뒤에 있는 값을 반환
        else:
            return table.bottled                #값이 4보다 작은경우

    except TypeError:                           #bottled값이 없는경우
        return None


def make_vintage_year(table : pd.Series) -> str or None:
    """
        make_vintage_year
            Args:
                table : 변경해야할 판다스 시리스(한 행)

            Note:
                vintage에서 년도 값만 분리하여 반환

            Return:
                str
    """
    try:
        if 4 < len(table.vintage):
            return table.vintage.split('.')[-1]  # .으로 분리하여 맨뒤에 있는 값을 반환
        else:
            return table.vintage                 #값이 4보다 작은경우
    except AttributeError:
        return None
    except TypeError:                            #bottled값이 없는경우
        return None

def remake_strength(table : pd.Series) -> int or None:
    """
        make_vintage_year
            Args:
                table : 변경해야할 판다스 시리스(한 행)

            Note:
                도수의 값 및 단위를 정규화 vol%

            Return:
                str
    """
    try:
        return table.strength.split('%')[0]

    except TypeError:                 #도수에 값잉 없는경우
        return None
    except AttributeError:           #도수의 값은 있으나 %가 없는경우
        if 'proof' in str(table.strength):
            return float(table.strength.split(' ')[0]) * 0.5  # proof 계산법 미국식 100 proof = 50 %

        elif 'gradi' in str(table.strength):
            return table.strength.split(' ')[0]                # gradi 이태리 표현 '도수'
        else:
            return None

def remake_overall_rate(table : pd.Series) -> float:
    """
        remake_overall_rate
            Args:
                table : 변경해야할 판다스 시리스(한 행)

            Note:
                overrall_rate  98.0/100에서 /100을 제거

            Return:
                float
    """
    try:
        return float(table.overall_rating.split('/')[0])   #overrall_rate에서 값 분리후 반환

    except TypeError:                               #값이 없는경우
        return None
    except AttributeError:                          #index를 못찾은경우
        return None

def price_information_resize(table : pd.Series) -> list:
    """
        price_information_resize
            Args:
                table : 변경해야할 판다스 시리스(한 행)

            Note:
                price_information으로 전처리 된 정보를 price,unit으로 분활하여 반환

            Return:
                list(str,str)
    """
    if table.price_information is not None:
        unit = None
        price = None

        for key, value in dict(table.price_information).items():
            if key == 'unit':
                unit = value
            elif key == 'price':
                price = value
        return unit,price

    else:
        return None, None

def replace_extracted_data_with_wb_whisky_formmat(extract_data: dict) -> [list, dict]:
    """
        replace_extracted_data_with_wb_whisky_formmat

            Note:
                수집된 bottler 정보를 병합 및 전처리 를 진행하는 함수

            Returns:
                [list, dict]
    """
    whisky_data = pd.DataFrame.from_dict(data=extract_data, orient='columns')
    whisky_data['whisky_name'] = whisky_data.apply(remove_void_space_whiksy_name, axis=1) #워스키명 전처리
    whisky_data['wb_whisky_id'] = whisky_data.apply(make_whisky_id, axis=1) #위스키 id 전처리
    whisky_data['distillery_information'] = whisky_data.apply(make_distillery_information, axis=1) #증류소 정보 전처리
    whisky_data['bottled_year'] = whisky_data.apply(make_bottled_year, axis=1) #bottled year 전처리
    whisky_data['taste_tags'] = whisky_data.apply(make_taste_tags, axis=1)  #taste_tag 정보 전처리
    whisky_data['strength'] = whisky_data.apply(remake_strength, axis=1)    #strength정보 전처리
    whisky_data['vintage_year'] = whisky_data.apply(make_vintage_year, axis=1) #vintage year 전처리
    whisky_data['price_information'] = whisky_data.apply(remake_block_price, axis=1)  #price information 전처리
    whisky_data['overall_rating'] = whisky_data.apply(remake_overall_rate, axis=1) #overrall_rating 정보 전처리
    whisky_data[['unit','price']] = whisky_data.apply(price_information_resize, axis=1,result_type='expand') #price_information정보 분활

    whisky_data = whisky_data[
        ['wb_whisky_id', 'whisky_name', 'distillery_information', 'category', 'bottler', 'bottled_year', 'strength',
         'size', 'label', 'market'
            , 'added_on', 'calculated_age', 'casknumber', 'barcode', 'casktype', 'bottling_serie'
            , 'number_of_bottles', 'vintage_year', 'stated_age', 'bottle_code', 'price','unit', 'photo',
         'taste_tags', 'overall_rating', 'votes']]

    whisky_data.rename(columns={'casknumber': 'cask_number', 'casktype': 'cask_type'}, inplace=True)
    whisky_data = whisky_data.replace({np.nan: None})# json으로 저장하기 위해 np.nan -> null로 변환
    result_df_list = []   #fire store에 저장하기 위해 각 로우별로 json화 시켜 라스트에 저장
    for i in range(len(whisky_data)):
        result_df_list.append({
            'id': None,
            'createdAt': None,
            'creator': None,
            'modifiedAt': None,
            'modifier': None,
            'wbId': whisky_data.wb_whisky_id[i],
            'name': whisky_data.whisky_name[i],
            'wbWhisky': json.loads(whisky_data.loc[i, :].to_json())
        })
    return result_df_list, json.loads(whisky_data.to_json())  #[파이어베이스 저장포맷,  (csv, json) 저장포맷]