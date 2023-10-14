import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

class ShortWhiskeyCounter extends StatelessWidget {
  const ShortWhiskeyCounter({super.key});
  final String iDrankWhiskey = "내가 마신 위스키";
  final String iDrankKind = "마신 위스키 종류";

  @override
  Widget build(BuildContext context) {
    final HomeState = context.watch<HomeViewModel>().state;

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
        children: [
          // 내가 마신 위스키
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  iDrankWhiskey,
                  style: TextStylesManager.createHadColorTextStyle(
                      "M14", ColorsManager.gray),
                ),
                SizedBox(height: WhilabelSpacing.spac4),
                //todo 데이터 연결
                Text(
                  "${HomeState.archivingPosts.length}개",
                  style: TextStylesManager.createHadColorTextStyle(
                      "B18", ColorsManager.brown100),
                )
              ],
            ),
          ),
          VerticalDivider(
            color: ColorsManager.gray,
            thickness: 2,
            indent: 20,
            endIndent: 20,
          ),
          // 내가 마신 브랜드 => 마신 위스키 종류
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  iDrankKind,
                  style: TextStylesManager.createHadColorTextStyle(
                      "M14", ColorsManager.gray),
                ),
                SizedBox(height: WhilabelSpacing.spac4),
                //todo 데이터 연결
                Text(
                  "${HomeState.shortArchivingPostMap.length}개",
                  style: TextStylesManager.createHadColorTextStyle(
                      "B18", ColorsManager.brown100),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
