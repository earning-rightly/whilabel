import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

// scaffold의 appBar 파라미터는 AppBar타입만 들어갈 수 있기에 함수로 생성
AppBar buildScaffoldAppBar(BuildContext context, String svgPath, String title,{Function()? onPop}) {
  return AppBar(
    toolbarHeight: 50,
    centerTitle: true,
    leading: IconButton(
      padding: EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      icon: SvgPicture.asset(svgPath),
      onPressed: () {
        Navigator.pop(context);
        if (onPop != null) onPop();
      },
    ),
    title: Text(
      title,
      style: TextStylesManager.bold16,
    ),
  );
}

class HomeAppBar extends StatelessWidget {
  final int myWhiskeyCounters;
  final bool isHasAnnouncement;

  const HomeAppBar({
    Key? key,
    required this.myWhiskeyCounters, required this.isHasAnnouncement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
      width: MediaQuery.of(context).size.width,
      height: 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Text(
                "나의 위스키",
                style: TextStylesManager.bold24,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  "$myWhiskeyCounters",
                  style: TextStylesManager.createHadColorTextStyle(
                      "M20", ColorsManager.brown100),
                ),
              ),
            ],
          ),
          IconButton(
            splashColor: ColorsManager.black300,
            splashRadius: 15,
            color: ColorsManager.gray200,
            icon: SvgPicture.asset(isHasAnnouncement ? SvgIconPath.notificationNew :SvgIconPath.notification),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 10, minHeight: 10),
            style: IconButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              iconSize: 24
            ),
            onPressed: () {
              Navigator.pushNamed(context, MyPageRoutes.announcementRoute);
            },
          ),
          // SvgPicture.asset(SvgIconPath.notification),
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
      width: MediaQuery
          .of(context)
          .size
          .width,
      child: Row(
        children: [
          Expanded(
            child: SvgPicture.asset(svgPath),
          ),
          Expanded(
            child: Text(
              centerTitle,
              textAlign: TextAlign.center,
              style: TextStylesManager.bold16,
            ),
          ),
          Expanded(
            child: Text(
              rightTitle ?? "",
              textAlign: TextAlign.center,
              style: TextStylesManager.bold16,
            ),
          )
        ],
      ),
    );
  }
}
