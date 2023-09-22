import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_global/widgets/pop_up_yes_no_button.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';

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

void showUpdatePostDialog(BuildContext context,
    {Function()? onClickedYesButton}) {
  final String title = "변경 사항을 저장하시겠습니까?";

  showDialog(
    context: context,
    // 주의) builder parameter에 있는 context 객체를 사용하면 Provider 객체를 불러올 수 없음.
    builder: (BuildContext _) => PopUpYesOrNoButton(
      titleText: title,
      noText: "취소",
      yesText: "네",
      onClickYesButton: onClickedYesButton,
      onClickNoButton: () {
        Navigator.pop(context);
      },
    ),
  );
}

void showMoveHomeDialog(BuildContext context,
    {Function()? onClickedYesButton,
    String title = "홈으로 이동하시겠습니까?\n 변경사항은 저장되지 않습니다"}) {
  // final String title = "변경 사항을 저장하시겠습니까?";

  showDialog(
    context: context,
    // 주의) builder parameter에 있는 context 객체를 사용하면 Provider 객체를 불러올 수 없음.
    builder: (BuildContext _) => PopUpYesOrNoButton(
      titleText: title,
      noText: "취소",
      yesText: "네",
      onClickYesButton: onClickedYesButton ??
          () {
            Navigator.pushNamed(context, Routes.rootRoute);
          },
      onClickNoButton: () {
        Navigator.pop(context);
      },
    ),
  );
}
