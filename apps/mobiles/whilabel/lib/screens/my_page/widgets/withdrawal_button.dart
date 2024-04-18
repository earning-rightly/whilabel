// ignore: must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/_global/functions/show_simple_dialog.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_view_model.dart';

import '../view_model/my_page_event.dart';

// ignore: must_be_immutable
class WithdrawalButton extends StatelessWidget {
  /** 탈퇴 기능을 가지고 있는 dialog를 생성*/
  WithdrawalButton({Key? key, required this.appUser}) : super(key: key);
  AppUser appUser;

  @override
  Widget build(BuildContext context) {
    final myPageViewModel = context.watch<MyPageViewModel>();
    final loginViewModel = context.read<LoginViewModel>();
    // final appUser = context.read<CurrentUserStatus>().state.appUser!;
    return LongTextButton(
      buttonText: "탈퇴하기",
      buttonTextColor: ColorsManager.gray500,
      color: ColorsManager.black100,
      onPressedFunc: () async {
        showWithdrawalDialog(context, onClickedYesButton: () {
          try {
            onClickedYesButton(myPageViewModel, loginViewModel);
          } catch (e) {
            showSimpleDialog(context, "회원탈퇴 에러발생",
                "예상치 못한 에러가 발생했습니다.\n whilable23@gmail.com으로 문의 주시면 감사하겠습니다");
          }
        });
      },
    );
  }

  Future<void> onClickedYesButton(
      MyPageViewModel myPageViewModel, LoginViewModel loginViewModel) async {
    await myPageViewModel
        .onEvent(MyPageEvent.withdrawAccount(appUser.uid, appUser.nickName),
        callback: () {
          loginViewModel.onEvent(
            LoginEvent.logout(appUser.snsType),
            callback: () async {
              // 회원 탈퇴 후 앱 나가기
              if (Platform.isAndroid)
                await SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
              else
                exit(0);
            },
          );
        });
  }
}
