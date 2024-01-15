import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

import '../../../data/user/enum/gender.dart';

class GenderChoicer extends StatelessWidget {
  const GenderChoicer({
    Key? key,
    this.onPressedMale,
    this.onPressedFemale,
    this.gender,
  }) : super(key: key);
  final Function()? onPressedMale;
  final Function()? onPressedFemale;
  final Gender? gender;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("성별(선택)", style: TextStylesManager.bold14,),
        const SizedBox(height: 12),
        Row(
          children: <Widget>[
            // 남성 버튼
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: onPressedMale,
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: ColorsManager.brown100),
                  fixedSize: const Size(142, 52),
                  backgroundColor: gender == Gender.MALE
                      ? ColorsManager.brown100
                      : ColorsManager.black100,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10),),
                  ),
                ),
                child: const Text("남성", style: TextStylesManager.bold16,),
              ),
            ),
            //버튼 중앙에 빈 공간
            const SizedBox(width: 12),
            // 여성 버튼
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: onPressedFemale,
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: ColorsManager.brown100),
                  fixedSize: const Size(142, 52),
                  backgroundColor: gender == Gender.FEMALE
                      ? ColorsManager.brown100
                      : ColorsManager.black100,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                child: const Text("여성", style: TextStylesManager.bold16,),
              ),
            ),
          ],
        )
      ]),
    );
  }
}
