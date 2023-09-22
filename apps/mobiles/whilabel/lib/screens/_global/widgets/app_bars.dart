import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

// scaffold의 appBar 파라미터는 AppBar타입만 들어갈 수 있기에 함수로 생성
AppBar buildScaffoldAppBar(BuildContext context, String svgPath, String title) {
  return AppBar(
    centerTitle: true,
    leading: IconButton(
      padding: EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      icon: SvgPicture.asset(svgPath),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    title: Text(
      title,
      style: TextStylesManager().createHadColorTextStyle(
        "B16",
        ColorsManager.gray500,
      ),
    ),
  );
}

class HomeAppBar extends StatelessWidget {
  final int myWhiskeyCounters;
  const HomeAppBar({
    Key? key,
    required this.myWhiskeyCounters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 32, left: 16, right: 16),
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              text: "나의 위스키",
              style: TextStylesManager.bold24,
              children: [
                TextSpan(
                  text: "\t\t$myWhiskeyCounters개",
                  style: TextStylesManager()
                      .createHadColorTextStyle("M20", ColorsManager.brown100),
                )
              ],
            ),
          ),
          SvgPicture.asset(SvgIconPath.notification),
        ],
      ),
    );
  }
}

class BodyAppBar extends StatelessWidget {
  const BodyAppBar({
    super.key,
    required this.svgPath,
    required this.centerTitle,
    this.rightTitle,
  });
  final String svgPath;
  final String centerTitle;
  final String? rightTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: SvgPicture.asset(svgPath),
          ),
          Expanded(
            child: Text(
              centerTitle,
              textAlign: TextAlign.center,
              style: TextStylesManager().createHadColorTextStyle(
                "B16",
                ColorsManager.gray500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              rightTitle ?? "",
              textAlign: TextAlign.center,
              style: TextStylesManager().createHadColorTextStyle(
                "B16",
                ColorsManager.gray500,
              ),
            ),
          )
        ],
      ),
    );
  }
}
