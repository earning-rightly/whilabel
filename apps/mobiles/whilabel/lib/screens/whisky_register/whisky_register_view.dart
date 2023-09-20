import 'package:flutter/material.dart';
import 'package:whilabel/screens/global/functions/create_star_rating.dart';

import 'package:whilabel/screens/global/functions/text_field_styles.dart';
import 'package:whilabel/screens/global/widgets/flavor_range.dart';

const String whiskeyName = "위스키 이름";
const double whiskeyLcoholPercentagea = 40;
const String whiskeyProducingArea = "샌산지";

const String distilleryImageURL =
    "https://ichibankobe.com/ko/wdps/wp-content/uploads/2016/05/01-6.jpg";
const String whiskeyImageUrl =
    'https://jmagazine.joins.com/_data2/photo/2022/10/2041357502_oEjDhyuw_2.jpg';

//-------- viwe 소개------------
// - 위스키 인식이 성공적일때 유저에게 보여줄 view.

// <안에 들어갈 내용>
// - 양조장 사진
// - 위스키 사진
// - 위스키 맛 특징
// - 바텀 버튼 2개(다시찍기, 등록하기)

class WhiskyRegisterView extends StatelessWidget {
  const WhiskyRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    Positioned(
                      child: Column(
                        children: [
                          SizedBox(
                            // 양조장 이미지
                            child: Image.network(
                              distilleryImageURL,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: SizedBox(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      whiskeyName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22),
                                    ),
                                    Text(
                                      "$whiskeyLcoholPercentagea/ $whiskeyProducingArea ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.only(top: 10, right: 10, left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //위스키에 상세에 들어갈 정보를 보여줄 곳입니다.
                          Container(
                            padding: EdgeInsets.only(
                              top: 15,
                              bottom: 15,
                              left: 10,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[600],
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "나의 평가",
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      TextButton(
                                          onPressed: () {}, child: Text("수정")),
                                    ],
                                  ),
                                ),
                                Text("2023,08.03 작성"),
                                Text("별점"),
                                Builder(
                                  builder: (context) =>
                                      createStarRating(3, false),
                                ),
                                SizedBox(height: 20),
                                Text("한줄평"),
                                TextFormField(
                                  decoration: createBasicTextFieldStyle(
                                      "연락처 유저 데이터 수정해야함", true),
                                  initialValue: "너무 맛있다!",
                                  enabled: false,
                                ),
                                SizedBox(height: 20),
                                Text("테이스팅 노트"),
                                TextFormField(
                                  decoration: createBasicTextFieldStyle(
                                      "연락처 유저 데이터 수정해야함", true),
                                  initialValue: "스모키하고 스모키한데 스모키해서",
                                  enabled: false,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 15, bottom: 15, left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[600],
                              borderRadius: BorderRadius.all(
                                Radius.circular(14),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "맛 특징. ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 22),
                                ),
                                FlavorRange(
                                  title: "바디감",
                                  subTitleLeft: "무거움",
                                  subTitleRight: "가변움",
                                  initialCount: 3,
                                ),
                                FlavorRange(
                                  title: "향",
                                  subTitleLeft: "스모키함",
                                  subTitleRight: "섬세함",
                                  initialCount: 3,
                                ),
                                FlavorRange(
                                  title: "피트감",
                                  subTitleLeft: "피트함",
                                  subTitleRight: "언피트",
                                  initialCount: 3,
                                ),
                              ],
                            ),
                          ),
                          //바디감, 향, 피트감 정보등이 들어 갈 곳
                          Container(
                            color: Colors.green,
                            width: double.infinity,
                            height: 250,
                            child: Text("브랜드 특징이 들어갈 곳"),
                          ),
                          ElevatedButton(
                              onPressed: () {}, child: const Text("등록하기")),
                          ElevatedButton(
                              onPressed: () {}, child: const Text("다시찍기")),
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: 150,
                  right: 10,
                  child: Image.network(
                    whiskeyImageUrl,
                    width: 100,
                    height: 180,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
