import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/_global/widgets/back_listener.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_view_model.dart';

import '../widgets/each_announcement.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});



  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {

  
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<MyPageViewModel>();
    final currentUserStauts = context.read<CurrentUserStatus>();
    final announcements = currentUserStauts.state.appUser?.announcements;
    return  BackListener(
        onBackButtonClick: ()async {
          await viewModel.delAnnouncement();
        },
      child: Scaffold(
          appBar: buildScaffoldAppBar(context, SvgIconPath.backBold, "알림", onPop: ()async{ await viewModel.delAnnouncement();}),
          body: SafeArea(
            child: (announcements == null || announcements.isEmpty)
                ? AnnouncmentPageEmpty()
                : ListView.separated(
              padding: EdgeInsets.only(top: 10, left: 16, right: 16),
                    itemCount:announcements.length,
                    itemBuilder: (context, index) {
                      return EachAnnouncement(
                        title: announcements[index].title,
                        body: announcements[index].body,
                        whiskyName: announcements[index].whiskyName,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return  const Divider(color: ColorsManager.black200);
                    }),
          )),
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
                  SizedBox(height: WhilabelSpacing.space24),
                  Text(
                    announcementPageTitle,
                    maxLines: 2,
                    style: TextStylesManager.bold20,
                  ),
                  SizedBox(height: WhilabelSpacing.space12),
                  Text(
                    announcementPageSubText,
                    maxLines: 2,
                    style: TextStylesManager.createHadColorTextStyle(
                        "R16", ColorsManager.gray),
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
