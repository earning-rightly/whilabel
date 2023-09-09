import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/home/grid/widgets/app_bars.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createScaffoldAppBar(context, SvgIconPath.backBold, "알림"),
      body: SafeArea(
        child: AnnouncmentPageEmpty(),
      ),
    );
  }
}

// ignore: must_be_immutable
class AnnouncmentPageEmpty extends StatelessWidget {
  AnnouncmentPageEmpty({super.key});
  String announcementPageTitle = "아직 알림이 없어요";
  String announcementPageSubText = "새로운 알림이 오면 알려들릴게요";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 4,
            left: 0,
            right: 0,
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    SvgIconPath.notification,
                    height: 50,
                    colorFilter: ColorFilter.mode(
                        ColorsManager.black300, BlendMode.srcIn),
                  ),
                  SizedBox(height: WhilabelSpacing.spac24),
                  Text(
                    announcementPageTitle,
                    maxLines: 2,
                    style: TextStylesManager()
                        .createHadColorTextStyle("B20", ColorsManager.gray500),
                  ),
                  SizedBox(height: WhilabelSpacing.spac12),
                  Text(
                    announcementPageSubText,
                    maxLines: 2,
                    style: TextStylesManager()
                        .createHadColorTextStyle("R16", ColorsManager.gray),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
