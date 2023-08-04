import 'package:flutter/material.dart';

// 일열로 세워진 5개의 box에 채워짐 갯 수에 따라서 왼쪽과 오른쪽에
// 어느쪽에 치우쳐 져있는지 알 수 있습니다.
class FlavorRange extends StatelessWidget {
  final String title; // 무엇에 관한
  final String subTitleRight;
  final String subTitleLeft;
  final int value; // 왼쪽부터 채워질 box 갯 수 입니다

  const FlavorRange(
      {super.key,
      required this.title,
      required this.subTitleLeft,
      required this.subTitleRight,
      required this.value});

  @override
  Widget build(BuildContext context) {
    const maxContainer = 5; // 칸에 최대 갯수
    const double height = 25;
    const Color filledColor = Colors.amber;
    const Color emptiedColor = Colors.brown;
    final borderStyle = Border.all(width: 1); // const르 둘 수 없기에 final
    const BorderRadius borderRadiusL = BorderRadius.only(
        topLeft: Radius.circular(10), bottomLeft: Radius.circular(10));
    const BorderRadius borderRadiusR = BorderRadius.only(
        topRight: Radius.circular(10), bottomRight: Radius.circular(10));
    List fillContainer =
        List.filled(maxContainer, false); // 화면에서 보여지는 화면을 리스트로 구현

    // 입력 받은 value만큼 0 index에서 부터 true로 변환
    if (1 <= value && value <= maxContainer) {
      for (int i = 0; i < value; i++) fillContainer[i] = true;
    } else // 입력한 valuer가 이상하다면 화면에 아무거도 띄우지 않는다.
      return SizedBox();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          Row(
            children: [
              for (int i = 0; i < maxContainer; i++)
                i == 0 // 맨 처음에 생성되는 칸은 항상 왼쪽이 둥그러야 하기에 고정
                    ? Expanded(
                        child: Container(
                          height: height,
                          decoration: BoxDecoration(
                              color: fillContainer[i] == true
                                  ? filledColor
                                  : emptiedColor,
                              border: borderStyle,
                              borderRadius: borderRadiusL),
                        ),
                      )
                    : Expanded(
                        child: Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: fillContainer[i] == true
                                ? filledColor
                                : emptiedColor,
                            border: borderStyle,
                            // 맨 왼쪽과 오른쪽만 둥글면 되기에
                            // 위에서 왼쪽은 if를 만들어 두었으니깐 오르쪽만 조건을 추가
                            borderRadius: i == maxContainer - 1
                                ? borderRadiusR
                                : BorderRadius.zero,
                          ),
                        ),
                      ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(subTitleLeft), Text(subTitleRight)],
          )
        ],
      ),
    );
  }
}
