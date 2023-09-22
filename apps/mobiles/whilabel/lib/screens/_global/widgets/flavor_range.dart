import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

// 일열로 세워진 5개의 box에 채워짐 갯 수에 따라서 왼쪽과 오른쪽에
// 어느쪽에 치우쳐 져있는지 알 수 있습니다.
class FlavorRange extends StatefulWidget {
  final String title; // 무엇에 관한
  final String subTitleRight;
  final String subTitleLeft;
  final double initialCount;
  final double? size;
  final bool? disable;
  final Function(double rating)? onChangeRating;
  const FlavorRange({
    Key? key,
    required this.title,
    required this.subTitleRight,
    required this.subTitleLeft,
    required this.initialCount,
    this.size,
    this.disable = false,
    this.onChangeRating,
  }) : super(key: key);

  @override
  State<FlavorRange> createState() => _FlavorRangeState();
}

class _FlavorRangeState extends State<FlavorRange> {
  final maxCount = 5;
  double filledCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      filledCount = widget.initialCount;
    });
  }
  // 왼쪽부터 채워질 box 갯 수 입니다

  @override
  Widget build(BuildContext context) {
    // 채우는 값이 잘못들어오면 빈박스 반환
    if (widget.initialCount < 1 || widget.initialCount > maxCount) {
      return SizedBox();
    }

    return Stack(
      children: [
        Positioned(
          child: SizedBox(
            height: 70,
            child: Row(
              children: [
                createFlaverRating(widget.initialCount, widget.disable!,
                    size: widget.size ??
                        (MediaQuery.of(context).size.width - 32 - 12) / 5),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Text(
            widget.title,
            style: TextStylesManager.bold14,
          ),
        ),
        Positioned(
          top: 50,
          left: 0,
          child: Text(
            widget.subTitleLeft,
            style: filledCount < maxCount / 2
                ? TextStylesManager()
                    .createHadColorTextStyle("B14", ColorsManager.yellow)
                : TextStylesManager()
                    .createHadColorTextStyle("B14", ColorsManager.gray200),
          ),
        ),
        Positioned(
          top: 50,
          right: 0,
          child: Text(
            widget.subTitleRight,
            style: (filledCount > maxCount / 2 && filledCount != 3)
                ? TextStylesManager()
                    .createHadColorTextStyle("B14", ColorsManager.yellow)
                : TextStylesManager()
                    .createHadColorTextStyle("B14", ColorsManager.gray200),
          ),
        )
      ],
    );
  }

  Widget createFlaverRating(double initialRating, bool disable,
      {onRatingUpdate, double size = 67}) {
    return RatingBar.builder(
        ignoreGestures: disable, // 별점 매길 것 인지 보기만 할 것인지
        initialRating: initialRating, // 처음에 보여 줘야 할 별점 개수
        minRating: 1,
        itemCount: 5,
        itemSize: size,
        direction: Axis.horizontal,
        itemPadding: EdgeInsets.only(top: 0, bottom: 0, right: 2),
        itemBuilder: (context, index) {
          switch (index) {
            case 0:
              return FlavorBox(
                leftRadius: 8,
                rightRadius: 0,
              );
            case 1:
              return FlavorBox(
                leftRadius: 0,
                rightRadius: 0,
              );

            case 2:
              return FlavorBox(
                leftRadius: 0,
                rightRadius: 0,
              );

            case 3:
              return FlavorBox(
                leftRadius: 0,
                rightRadius: 0,
              );

            case 4:
              return FlavorBox(
                leftRadius: 0,
                rightRadius: 8,
              );
          }

          return Icon(Icons.access_alarm_rounded);
        },
        unratedColor: ColorsManager.black300,
        onRatingUpdate: widget.onChangeRating == null
            ? (rating) {
                print("onChangeRating null");

                setState(() {
                  filledCount = rating;
                });
              }
            : (rating) {
                setState(() {
                  filledCount = rating;
                });
                widget.onChangeRating!(rating);
              });
  }
}

class FlavorBox extends StatelessWidget {
  const FlavorBox(
      {super.key, required this.leftRadius, required this.rightRadius});
  final double leftRadius;
  final double rightRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 67,
      height: 16,
      decoration: BoxDecoration(
        color: ColorsManager.yellow,
        border: Border.all(width: 1), // const르 둘 수 없기에 final

        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(leftRadius),
          right: Radius.circular(rightRadius),
        ),
      ),
    );
  }
}
