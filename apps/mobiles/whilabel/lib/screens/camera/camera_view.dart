import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/mock_data/mock_camera_route.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/path/image_paths.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';

import 'package:whilabel/screens/_global/widgets/long_text_button.dart';

class CameraView extends StatelessWidget {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: WhilablePadding.onlyHoizBasicPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text(
                "위스키 기록",
                style: TextStylesManager()
                    .createHadColorTextStyle("B24", ColorsManager.gray500),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              child: Column(
                children: [
                  Image.asset(
                    cameraViewPngImage,
                  ),
                  SizedBox(height: WhilabelSpacing.spac32),
                  Text(
                    "오늘 마신 위시키를 기록해볼까요?",
                    style: TextStylesManager()
                        .createHadColorTextStyle("B20", ColorsManager.gray500),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: WhilabelSpacing.spac24),
                  Row(
                    children: [
                      Expanded(flex: 10, child: SizedBox()),
                      Expanded(
                        flex: 34,
                        child: LongTextButton(
                          buttonText: "위스키 기록하기",
                          color: ColorsManager.brown100,
                          onPressedFunc: () {
                            // todo 테스트로 사용할 루트 나중에 다시 바꿀예정
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MockCameraRoute(),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(flex: 10, child: SizedBox()),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
