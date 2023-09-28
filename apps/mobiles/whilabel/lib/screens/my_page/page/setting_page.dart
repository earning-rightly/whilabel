import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/_global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_event.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_view_model.dart';
import 'package:whilabel/screens/my_page/widgets/list_toggel_button.dart';
import 'package:whilabel/screens/my_page/page/withdrawal_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late bool isPushAlim;
  late bool isMarketingAlim;

  @override
  Widget build(BuildContext context) {
    final loginViewModel = context.watch<LoginViewModel>();
    final currentUserStatus = context.watch<CurrentUserStatus>();
    final viewModel = context.watch<MyPageViewModel>();

    return Scaffold(
      appBar: buildScaffoldAppBar(context, SvgIconPath.backBold, ""),
      body: SafeArea(
        child: Padding(
          padding: WhilabelPadding.onlyHoizBasicPadding,
          child: SizedBox(
            height: 200,
            // 페이지에서 로그인한 유저 정보 계속 받아오기
            child: FutureBuilder<AppUser?>(
              future: currentUserStatus.getAppUser(),
              builder: (context, snapshot) {
                if (snapshot.data == null || !snapshot.hasData) {
                  return LodingProgressIndicator(
                    offstage: true,
                  );
                }

                final appUser = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 푸시 알림
                    Expanded(
                      flex: 2,
                      child: ListToggleButton(
                        title: "푸시알림",
                        isToggleState: appUser!.isPushNotificationEnabled!,
                        onPressedButton: () async {
                          // final appUser =
                          //     await currentUserStatus.getAppUser();
                          viewModel.onEvent(
                            MyPageEvent.changePushAlimValue(appUser.uid),
                            callback: () async {
                              await currentUserStatus.updateUserState();
                            },
                          );
                        },
                      ),
                    ),

                    // 마케팅 정보 알림
                    Expanded(
                      flex: 2,
                      child: ListToggleButton(
                          title: "마케팅 정보 알림",
                          isToggleState:
                              appUser.isMarketingNotificationEnabled!,
                          onPressedButton: () {
                            viewModel.onEvent(
                              MyPageEvent.changeMarketingAlimValue(appUser.uid),
                              callback: () async {
                                await currentUserStatus.updateUserState();
                              },
                            );
                          }),
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
                                  Navigator.pushNamed(
                                      context, Routes.loginRoute);
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
                        style: TextStylesManager().createHadColorTextStyle(
                            "R14", ColorsManager.black300),
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}