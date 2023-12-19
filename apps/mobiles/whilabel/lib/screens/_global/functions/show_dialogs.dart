import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/widgets/watch_again_checkbox.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/_global/widgets/pop_up_yes_no_button.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/string_manger.dart'as strManger;


Future<void> showRuleForCamera(BuildContext context) async {
  await Future.delayed(const Duration(milliseconds: 100));

  const String title = "정확한 스캔 결과를 위해\n꼭 확인해주세요!";
  const String rule1 = "프레임 안에 맞춰 주세요";
  const String rule2 = "밝은 곳에서 촬양해 주세요";
  const String rule3 = "초점이 흔들리지 않게 찍어주세요";

  const String checkBoxText = "다시 보지 않으시겠습니까?";

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 22.w),
          contentPadding: EdgeInsets.symmetric(horizontal:  24.w, vertical: 24.h),
            backgroundColor: ColorsManager.black200,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      title,
                      style: TextStylesManager.bold20,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      SvgPicture.asset(SvgIconPath.checkBold,
                      colorFilter: const ColorFilter.mode(
                          ColorsManager.brown100,
                          BlendMode.srcIn),),
                        SizedBox(height:6),
                        Text(rule1,
                            style: TextStylesManager.regular16
                                .copyWith(color: ColorsManager.gray)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(SvgIconPath.checkBold,
                          colorFilter: const ColorFilter.mode(
                              ColorsManager.brown100,
                              BlendMode.srcIn),),
                        SizedBox(height:6),
                        Text(rule2,
                            style: TextStylesManager.regular16
                                .copyWith(color: ColorsManager.gray)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(SvgIconPath.checkBold,
                          colorFilter: const ColorFilter.mode(
                              ColorsManager.brown100,
                              BlendMode.srcIn),),
                        SizedBox(height:6),
                        Text(rule3,
                            style: TextStylesManager.regular16
                                .copyWith(color: ColorsManager.gray)),
                      ],
                    ),
                    const SizedBox(height: 16),
                  LongTextButton(
                        buttonText: "알겠어요",
                        enabled: true,
                        color: ColorsManager.brown100,
                        onPressedFunc: () async {

                          Navigator.pop(context);
                        },

                    ),
                    Row(
                      children: [
                        WatchAgainCheckBox(boxKey: strManger.CAMERA_RULE,),
                        SizedBox(width: 8),
                        Text(checkBoxText,
                            style: TextStylesManager.regular16
                                .copyWith(color: ColorsManager.gray))
                      ],
                    ),
                  ],
                ),
              ),
            ]);
      });
}

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
    String title = "홈으로 이동하시겠습니까?\n 변경 사항은 저장되지 않습니다"}) {
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

void showDeletePostDialog(BuildContext context,
    {Function()? onClickedYesButton,
    String title = "게시물을 삭제하시겠습니까?\n삭제 후 복구할 수 없습니다"}) {
  showDialog(
    context: context,
    // 주의) builder parameter에 있는 context 객체를 사용하면 Provider 객체를 불러올 수 없음.
    builder: (BuildContext _) => PopUpYesOrNoButton(
      titleText: title,
      noText: "취소",
      yesText: "네",
      onClickYesButton: onClickedYesButton ?? () {},
      onClickNoButton: () {
        Navigator.pop(context);
      },
    ),
  );
}

void showColoseAppDialog(BuildContext context) {
  showDialog(
    context: context,
    // 주의) builder parameter에 있는 context 객체를 사용하면 Provider 객체를 불러올 수 없음.
    builder: (BuildContext _) => PopUpYesOrNoButton(
      titleText: "앱을 종료 하시겠습니까?",
      noText: "취소",
      yesText: "네",
      onClickYesButton: () async {
        if (Platform.isAndroid)
          await SystemChannels.platform
              .invokeMethod<void>('SystemNavigator.pop');
        else
          // SystemNavigator.pop();
          exit(0);
      },
      onClickNoButton: () {
        Navigator.pop(context);
      },
    ),
  );
}

void showMoveRootDialog(BuildContext context,
    {int rootIndex = 0, String title = "홈으로 돌아기시겠습니까?"}) {
  showDialog(
    context: context,
    // 주의) builder parameter에 있는 context 객체를 사용하면 Provider 객체를 불러올 수 없음.
    builder: (BuildContext _) => PopUpYesOrNoButton(
      titleText: title,
      noText: "취소",
      yesText: "네",
      onClickYesButton: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, arguments: rootIndex, Routes.rootRoute, (route) => false);
      },
      onClickNoButton: () {
        Navigator.pop(context);
      },
    ),
  );
}
