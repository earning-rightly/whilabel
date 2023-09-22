import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/onboarding/onboarding_step2.dart';

class OnboardingStep1Page extends StatelessWidget {
  const OnboardingStep1Page({super.key});
  final String onBoardingText = "내가 마신 위스키 사진을 찍으면 자동으로 정보가 입력돼요.";

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
                child: SizedBox(
                    child: SvgPicture.asset(SvgIconPath.onBoardingStep1)),
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
                        style: TextStylesManager().createHadColorTextStyle(
                            "B24", ColorsManager.gray500),
                        maxLines: 2,
                      ),
                    )),
              ),
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Padding(
                  padding: WhilablePadding.onlyHoizBasicPadding,
                  child: LongTextButton(
                    buttonText: "알겠어요",
                    buttonTextColor: ColorsManager.brown100,
                    borderColor: ColorsManager.gray500,
                    color: ColorsManager.gray500,
                    onPressedFunc: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OnboardingStep2Page(),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
