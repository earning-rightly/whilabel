import 'package:flutter/material.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/global/widgets/pop_up_yes_no_button.dart';

void showLogoutDialog(BuildContext context, {Function()? onClickedYesButton}) {
  final String title = "정말로 로그아웃 하시겠어요?";

  showDialog(
    context: context,
    // 주의) builder parameter에 있는 context 객체를 사용하면 Provider 객체를 불러올 수 없음.
    builder: (BuildContext _) => PopUpYesOrNoButton(
      titleText: title,
      noText: "취소",
      yesText: "로그아웃",
      onClickYesButton: onClickedYesButton,
      onClickNoButton: () {
        Navigator.pop(context);
      },
    ),
  );
}

void showWithdrawalDialog(BuildContext context,
    {Function()? onClickedYesButton}) {
  final String title = "정말로 탈퇴하시겠어요?";

  showDialog(
      context: context,

      // 주의) builder parameter에 있는 context 객체를 사용하면 Provider 객체를 불러올 수 없음.
      builder: (BuildContext _) => PopUpYesOrNoButton(
            titleText: title,
            noText: "취소",
            yesText: "탈퇴하기",
            yesButtonColor: ColorsManager.red,
            onClickYesButton: onClickedYesButton,
            onClickNoButton: () {
              Navigator.pop(context);
            },
          ));
}
