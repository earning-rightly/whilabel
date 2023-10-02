import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';
import 'package:whilabel/screens/camera/page/search_whisky_name_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';

// ignore: must_be_immutable
class CameraView extends StatelessWidget {
  CameraView({super.key});
  final focus = FocusNode();
  int _failCounter = 0;

  StreamController<int> _events = StreamController();

  void addFailCounter() {
    _failCounter++;
    _events.add(_failCounter);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CarmeraViewModel>();
    return SafeArea(
        child: Padding(
      padding: WhilabelPadding.onlyHoizBasicPadding,
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
            flex: 3,
            child: SizedBox(
              child: Column(
                children: [
                  Image.asset(
                    cameraViewPngImage,
                  ),
                  SizedBox(height: WhilabelSpacing.spac32),
                  Text(
                    "오늘 마신 위스키를 기록해볼까요?",
                    style: TextStylesManager.bold20,
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
                            showModalBottomSheet<void>(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  padding: EdgeInsets.symmetric(horizontal: 18),
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
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SimpleBarcodeScannerPage(),
                                                )).then((value) {
                                              if (value is String) {
                                                viewModel.onEvent(
                                                    CarmeraEvent
                                                        .searchWhiskeyWithBarcode(
                                                            value),
                                                    callback: () async {
                                                  if (viewModel
                                                      .state.isFindWhiskyData) {
                                                    await showSuccedDialog();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            GalleryPage(),
                                                      ),
                                                    );
                                                  } else {
                                                    addFailCounter();
                                                  }
                                                });
                                              }
                                            });
                                          },
                                        ),
                                        SizedBox(height: WhilabelSpacing.spac8),
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
          )
        ],
      ),
    ));
  }

  Future<void> showSuccedDialog() async {
    await EasyLoading.showSuccess(
      "바코드 인식성공",
    );
    if (EasyLoading.isShow) {
      // await Future.delayed(const Duration(seconds: 3));
      Timer(Duration(milliseconds: 2000), () {
        EasyLoading.dismiss();
      });
    }
  }
}
