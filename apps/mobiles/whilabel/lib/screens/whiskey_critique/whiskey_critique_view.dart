import 'package:flutter/material.dart';

// 사용자가 사진을 찍은 위스키에 대해서 자신의 비펴을 적을 수 있는 view 입니다.
// 필수 정보(위스키 별점, 한줄평)가 입력되어야 '저장하기" 버튼을 눌러서 다음 flow이동 가능

// <안에 들어갈 내용>
// - 위스키 별점 평가 (tab해서 5개 별들의 색상을 채우는 방식, 별 반개만 채우기)
// - 위스키 한줄평 (Text입력해서 채우기)
// - 테이스팅 노트 (Text입력해서 채우기)

// 피그마에서 인식성공의 나의평가 부분 (자세한것은 이슈와 PR참고)
class WhiskeyCritiqueView extends StatelessWidget {
  const WhiskeyCritiqueView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Whiskey Record View"),
      ),
      body: Container(),
    );
  }
}
