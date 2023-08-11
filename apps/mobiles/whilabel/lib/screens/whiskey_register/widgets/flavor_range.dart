import 'package:flutter/material.dart';

// 일열로 세워진 5개의 box에 채워짐 갯 수에 따라서 왼쪽과 오른쪽에
// 어느쪽에 치우쳐 져있는지 알 수 있습니다.
class FlavorRange extends StatelessWidget {
  final String title; // 무엇에 관한
  final String subTitleRight;
  final String subTitleLeft;
  final maxCount = 5; // 칸에 최대 갯수
  final int filledCount; // 왼쪽부터 채워질 box 갯 수 입니다

  final BorderRadius borderRadiusLeft = BorderRadius.only(
      topLeft: Radius.circular(10), bottomLeft: Radius.circular(10));
  final BorderRadius borderRadiusRight = BorderRadius.only(
      topRight: Radius.circular(10), bottomRight: Radius.circular(10));
  final Color filledColor = Colors.amber;
  final Color emptyColor = Colors.brown;
  final double height = 25;
  final borderStyle = Border.all(width: 1); // const르 둘 수 없기에 final

  FlavorRange(
      {super.key,
      required this.title,
      required this.subTitleLeft,
      required this.subTitleRight,
      required this.filledCount});

  @override
  Widget build(BuildContext context) {
    // 채우는 값이 잘못들어오면 빈박스 반환
    if (filledCount < 1 || filledCount > maxCount) {
      return SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          Row(children: makeRangeBars(maxCount, filledCount)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(subTitleLeft), Text(subTitleRight)],
          )
        ],
      ),
    );
  }

  List<Widget> makeRangeBars(int maxCount, int filledCount) {
    final List<Expanded> barList = List<Expanded>.generate(
        maxCount,
        (int index) => Expanded(
              child: Container(
                height: height,
                decoration: BoxDecoration(
                    color: getColor(index),
                    border: borderStyle,
                    borderRadius: getBorderRadius(index)),
              ),
            ),
        growable: false);

    return barList;
  }

  Color getColor(index) {
    return index < filledCount ? filledColor : emptyColor;
  }

  BorderRadius getBorderRadius(index) {
    if (index == 0)
      return borderRadiusLeft;
    else if (index == maxCount - 1)
      return borderRadiusRight;
    else
      return BorderRadius.zero;
  }
}
