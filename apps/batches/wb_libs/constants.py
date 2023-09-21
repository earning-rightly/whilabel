from types import MappingProxyType

KST = 'Asia/Seoul'  # timezone setting


field_map = MappingProxyType(
    {
        'wb_whisky_collect_detail': [
            'whisky_name',
            'whiskybase_id',
            'category',
            'distillery',
            'bottler',
            'bottled',
            'strength',
            'size',
            'label',
            'market',
            'added_on',
            'calculated_age',
            'casknumber',
            'barcode',
            'casktype',
            'bottling_serie',
            'number_of_bottles',
            'vintage',
            'bottled_for',
            'stated_age',
            'bottle_code',
            'block_price',
            'tag_name',
            'photo',
            'overall_rating',
            'votes',
            'link'
        ],
        'wb_bottler_collect_detail' : [
            'company_about',
            'company_address',
            'closed',
            'collection',
            'country',
            'founded',
            'abbreviation',
            'rating',
            'specialists',
            'status',
            'vote',
            'votes',
            'wb_ranking',
            'website',
            'whiskies',
            'views'
        ],
        'wb_distillery_collect_detail' : [
            'company_about',
            'company_address',
            'capacity_per_year',
            'closed',
            'collection',
            'country',
            'founded',
             'owner',
            'rating',
            'specialists',
            'spirit_stills',
            'status',
             'vote',
            'votes',
            'wb_ranking',
            'wash_stills',
            'website',
            'whiskies',
            'wishlist',
             'views',
            'owner',
            'spirit_stills',
            'capacity_per_year',
            'wishlist',
            'wash_stills'
        ],
        'wb_brand_collect_detail' : [
            'country',
            'website',
            'region'
        ],
        'wb_brand_collect_pre' : [
            'brand_name',
            'country',
            'whiskies',
            'votes',
            'rating',
            'link',
            'wb_rank'
        ],
        'wb_bottler_collect_pre' : [
            'bottler_name',
            'country',
            'whiskies',
            'votes',
            'rating',
            'link'
        ],
        'wb_distillery_collect_pre' : [
            'distillery_name',
            'country',
            'whiskies',
            'votes',
            'rating',
            'link'
        ],
        'wb_whisky_link' : [
            'whisky_link'
        ]
    }
)

link_map = MappingProxyType(
    {
        'bottler'  : 'https://www.whiskybase.com/whiskies/bottlers',
        'brand': 'https://www.whiskybase.com/whiskies/brands',
        'distillery': 'https://www.whiskybase.com/whiskies/distilleries'
    }
)


