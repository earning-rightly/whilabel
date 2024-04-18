import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';

import '../widgets/withdrawal_button.dart';

// ignore: must_be_immutable
class WithdrawalPage extends StatelessWidget {
  WithdrawalPage({super.key});

  String withdrawalPageTitle = "지금 탈퇴하면 위라벨에서 제공하는\t다양한\t혜택을 더 이상 누릴 수 없어요";
  String withdrawalPageWaringText1 = "위스키 맛과 브랜드의 특징에 접근할 수 없습니다";
  String withdrawalPageWaringText2 = "수동적으로 등록된 위스키에 대한 정보는 보관됩니다";
  String withdrawalPageWaringText3 = "나의 위스키 기록(사진, 별점, 한 줄평 등)이 영구적으로 삭제됩니다";
  String dot = "\u2022\t\t"; // 점 구현

  @override
  Widget build(BuildContext context) {
    final appUser = context.read<CurrentUserStatus>().state.appUser!;

    return Scaffold(
      appBar: buildScaffoldAppBar(context, SvgIconPath.close, "탈퇴하기"),
      body: Padding(
        padding: WhilabelPadding.basicPadding,
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: WhilabelSpacing.space8),

                  // 상단 굵은 탈퇴 안내글
                  createWaringTitle(withdrawalPageTitle),
                  SizedBox(height: WhilabelSpacing.space24),

                  // 첫 번째 리스트 글
                  createWaringText(withdrawalPageWaringText1),
                  SizedBox(height: WhilabelSpacing.space12),

                  // 두 번째 리스트 글
                  createWaringText(withdrawalPageWaringText2),
                  SizedBox(height: WhilabelSpacing.space12),

                  // 세 번째 리스트 글
                  createWaringText(withdrawalPageWaringText3, maxLine: 2),
                ],
              ),
              Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 탈퇴 보류 버튼 //todo 어느 곳을 이동?
                      createWithdrawalPendingButton(context),
                      // LongTextButton(
                      //   buttonText: "위라벨 계속 사용하기",
                      //   buttonTextColor: ColorsManager.gray500,
                      //   color: ColorsManager.orange,
                      //   onPressedFunc: () {
                      //     Navigator.pushReplacementNamed(
                      //         context, Routes.rootRoute);
                      //   },
                      // ),
                      // 탈퇴하기 => 팝업 창 생성
                      WithdrawalButton(appUser: appUser)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget createWaringTitle(String title) {
    return SizedBox(
      child: Text(
        title,
        maxLines: 3,
        style: TextStylesManager.bold20,
        softWrap: true,
      ),
    );
  }

  Widget createWaringText(String content, {int maxLine = 1}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(dot, style: TextStylesManager.regular14),
      Flexible(
        child: Text(
          content,
          style: TextStylesManager.regular14,
          maxLines: maxLine,
        ),
      )
    ]);
  }

  Widget createWithdrawalPendingButton (BuildContext context){
    return   LongTextButton(
    buttonText: "위라벨 계속 사용하기",
    buttonTextColor: ColorsManager.gray500,
    color: ColorsManager.orange,
    onPressedFunc: () {
      Navigator.pushReplacementNamed(
          context, Routes.rootRoute);
    },
    );
  }
}
