import 'package:flutter/material.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';

class ShortWhiskeyCounter extends StatelessWidget {
  const ShortWhiskeyCounter({super.key});
  final String iDrankWhiskey = "내가 마신 위스키";
  final String iDrankBrand = "내가 마신 브랜드";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 21, bottom: 16),
      width: MediaQuery.of(context).size.width,
      height: 90,
      decoration: BoxDecoration(
          color: ColorsManager.black300,
          border: Border.all(
            width: 1,
            color: ColorsManager.black200,
          ),
          borderRadius:
              BorderRadius.all(Radius.circular(WhilabelRadius.radius16))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 내가 마신 위스키
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                iDrankWhiskey,
                style: TextStylesManager()
                    .createHadColorTextStyle("M14", ColorsManager.gray),
              ),
              SizedBox(height: WhilabelSpacing.spac4),
              //todo 데이터 연결
              Text(
                "30종",
                style: TextStylesManager()
                    .createHadColorTextStyle("B18", ColorsManager.brown100),
              )
            ],
          ),
          VerticalDivider(
            color: ColorsManager.gray,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          // 내가 마신 브랜드
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                iDrankBrand,
                style: TextStylesManager()
                    .createHadColorTextStyle("M14", ColorsManager.gray),
              ),
              SizedBox(height: WhilabelSpacing.spac4),
              //todo 데이터 연결
              Text(
                "20개",
                style: TextStylesManager()
                    .createHadColorTextStyle("B18", ColorsManager.brown100),
              )
            ],
          ),
        ],
      ),
    );
  }
}
