import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/constants/routes_manager.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/global/widgets/app_bars.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';
import 'package:whilabel/screens/my_page/widgets/functions/show_dialog.dart';
import 'package:whilabel/screens/my_page/widgets/list_toggel_button.dart';
import 'package:whilabel/screens/my_page/withdrawal_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isPushAlim = false;
  bool isMarketingAlim = true;

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewModel>();
    final currentUserStatus = context.watch<CurrentUserStatus>();

    return Scaffold(
      appBar: createScaffoldAppBar(context, SvgIconPath.backBold, ""),
      body: SafeArea(
        child: Padding(
          padding: WhilablePadding.onlyHoizBasicPadding,
          child: SizedBox(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 푸시 알림
                Expanded(
                  flex: 2,
                  child: ListToggleButton(
                    title: "푸시알림",
                    isToggleState: isPushAlim,
                    onPressedButton: onPressedPushAlim,
                  ),
                ),

                // 마케팅 정보 알림
                Expanded(
                  flex: 2,
                  child: ListToggleButton(
                    title: "마케팅 정보 알림",
                    isToggleState: isMarketingAlim,
                    onPressedButton: onPressedMarcketingAlimAlim,
                  ),
                ),

                // 로그아웃 버튼
                Expanded(
                  flex: 1,
                  child: TextButton(
                    child: Text(
                      "로그아웃",
                      style: TextStylesManager().createHadColorTextStyle(
                          "R14", ColorsManager.black300),
                    ),
                    onPressed: () async {
                      AppUser? currentAppUser =
                          await currentUserStatus.getAppUser();
                      showLogoutDialog(
                        context,
                        onClickedYesButton: () {
                          loginViewModel.onEvent(
                            LoginEvent.logout(currentAppUser!.snsType),
                            callback: () {
                              Navigator.pushNamed(context, Routes.loginRoute);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                // 회원탈퇴 버튼
                // 디자인을 위해서 회원탈퇴입 버튼에는 Expended 적용 안함
                TextButton(
                  child: Text(
                    "회원탈퇴",
                    style: TextStylesManager()
                        .createHadColorTextStyle("R14", ColorsManager.black300),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WithdrawalPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// 푸시 알림 버튼 눌렀을때 실행
  void onPressedPushAlim() {
    setState(() {
      isPushAlim = !isPushAlim;
    });
  }

// 푸시 알림 버튼 눌렀을때 실행
  void onPressedMarcketingAlimAlim() {
    setState(() {
      isMarketingAlim = !isMarketingAlim;
    });
  }
}
