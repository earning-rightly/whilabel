import 'package:flutter/material.dart';

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

class WhiskeyRegisterView extends StatelessWidget {
  const WhiskeyRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  // 양조장 이미지
                  child: Image.network(
                    distilleryImageURL,
                    width: double.infinity,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          whiskeyName,
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                        //위스키에 들어갈 정보를 보여줄 곳입니다.
                        Text(
                          "$whiskeyLcoholPercentagea/ $whiskeyProducingArea ",
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30, bottom: 10),
                          child: Text(
                            "맛 특징. ",
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                        ),
                        //바디감, 향, 피트감 정보등이 들어 갈 곳
                        Container(
                          color: Colors.green,
                          width: double.infinity,
                          height: 250,
                          child: Text("바디감, 향, 피트감 정보등이 들어 갈 곳"),
                        )
                      ]),
                )
              ],
            ),
            Positioned(
              top: 150,
              right: 15,
              child: Image.network(
                whiskeyImageUrl,
                width: 100,
                height: 180,
              ),
            ),
            Positioned(
                bottom: 30,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    ElevatedButton(onPressed: () {}, child: const Text("등록하기")),
                    ElevatedButton(onPressed: () {}, child: const Text("다시찍기")),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
