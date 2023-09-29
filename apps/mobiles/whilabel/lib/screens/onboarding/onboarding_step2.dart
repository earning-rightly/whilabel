import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';

class OnboardingStep2Page extends StatelessWidget {
  const OnboardingStep2Page({super.key});
  final String onBoardingText = "나만의 맛 평가를 입력하고\n저장하면 기록 끝!";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xffA87137),
                Color(0xff864E33),
              ]),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: WhilabelSpacing.spac16,
                left: 0,
                right: 0,
                child: SvgPicture.asset(SvgIconPath.onBoardingStep2),
              ),
              Positioned(
                top: (WhilabelSpacing.spac16 + WhilabelSpacing.spac32),
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    child: Text(
                      onBoardingText,
                      style: TextStylesManager.bold24,
                      maxLines: 2,
                    ),
                  ),
                ),
              ),
              Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: WhilabelPadding.onlyHoizBasicPadding,
                    child: LongTextButton(
                      buttonText: "위라벨 시작하기",
                      buttonTextColor: ColorsManager.brown100,
                      borderColor: ColorsManager.gray500,
                      color: ColorsManager.gray500,
                      onPressedFunc: () {
                        Navigator.pushNamed(context, Routes.rootRoute);
                      },
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
