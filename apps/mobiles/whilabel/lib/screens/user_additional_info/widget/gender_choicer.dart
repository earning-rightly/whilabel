import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

class GenderChoicer extends StatelessWidget {
  const GenderChoicer({
    Key? key,
    this.onPressedMan,
    this.onPressedFemale,
    required this.isManPressed,
    required this.isFemalePressed,
  }) : super(key: key);
  final Function()? onPressedMan;
  final Function()? onPressedFemale;
  final bool isManPressed;
  final bool isFemalePressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "성별",
          style: TextStylesManager.bold14,
        ),
        SizedBox(height: 12),
        Row(
          children: [
            // 남성 버튼
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: onPressedMan,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: ColorsManager.brown100),
                  fixedSize: Size(142, 52),
                  backgroundColor: isManPressed
                      ? ColorsManager.brown100
                      : ColorsManager.black100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  "남성",
                  style: TextStylesManager.bold16,
                ),
              ),
            ),
            //버튼 중앙에 빈 공간
            SizedBox(width: 12),
            // 여성 버튼
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: onPressedFemale,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: ColorsManager.brown100),
                  fixedSize: Size(142, 52),
                  backgroundColor: isFemalePressed
                      ? ColorsManager.brown100
                      : ColorsManager.black100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  "여성",
                  style: TextStylesManager.bold16,
                ),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
