import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_scan_page.dart';
import 'package:whilabel/screens/camera/page/search_whisky_name_page.dart';

// ignore: must_be_immutable
class CameraView extends StatelessWidget {
  CameraView({super.key});
  final focus = FocusNode();
  int _failCounter = 0;
  List<CameraDescription> cameras = [];

  StreamController<int> _events = StreamController();

  void addFailCounter() {
    _failCounter++;
    _events.add(_failCounter);
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Padding(
      padding: WhilabelPadding.onlyHoizBasicPadding,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text(
                  "위스키 기록",
                  style: TextStylesManager.bold24,
                ),
              ),
            ),
            Expanded(
              flex: height * 0.85 <= width ? 0 : 3,
              child: SizedBox(
                child: Column(
                  children: [
                    Image.asset(
                      cameraViewPngImage,
                    ),
                    SizedBox(height: WhilabelSpacing.space32),
                    Text(
                      "오늘 마신 위스키를 기록해볼까요?",
                      style: TextStylesManager.bold20,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: WhilabelSpacing.space24),
                    Row(
                      children: [
                        Expanded(flex: 10, child: SizedBox()),
                        Expanded(
                          flex: 34,
                          child: LongTextButton(
                            buttonText: "위스키 기록하기",
                            color: ColorsManager.brown100,
                            onPressedFunc: () {
                              showModalBottomSheet<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 18),
                                    color: ColorsManager.black200,
                                    height: 200,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          // 바코드로 인식하기
                                          LongTextButton(
                                            buttonText: "위스키 병 바코드 인식",
                                            onPressedFunc: () async {
                                              await initCamera();

                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        WhiskyBarCodeScanPage(
                                                      cameras: cameras,
                                                    ),
                                                  ));
                                            },
                                          ),
                                          SizedBox(
                                              height: WhilabelSpacing.space8),
                                          LongTextButton(
                                            buttonText: "위스키 이름 검색",
                                            onPressedFunc: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SerachWhiskyNamePage()),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Expanded(flex: 10, child: SizedBox()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    ));
  }
}
