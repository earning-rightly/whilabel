import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_scan_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';

// ignore: must_be_immutable
class CameraView extends StatefulWidget {
  CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  final focus = FocusNode();
  int _failCounter = 0;
  List<CameraDescription> cameras = [];
  StreamController<int> _events = StreamController();


  @override
  void initState() {
    super.initState();
    final viewModel = context.read<CameraViewModel>();
    initCamera(viewModel);

  }

  void addFailCounter() {
    _failCounter++;
    _events.add(_failCounter);
  }

  Future<void> initCamera(CameraViewModel cameraViewModel) async {
    /// CamerState.cameras를 초기 세팅을 해준다.
    /// cameraCotroller에서 필요한 cameras는 모두 CamerState.cameras사용

    await cameraViewModel.onEvent(CameraEvent.initCamera());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CameraViewModel>();
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;



    return SafeArea(
        child: Padding(
      padding: WhilabelPadding.onlyHoizBasicPadding,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height * 0.8 <= width
                ?  Container(
        margin: EdgeInsets.symmetric(vertical: 32),
        child: Text(
          "위스키 기록",
          style: TextStylesManager.bold24,
        ),
      )
            :Expanded(
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
              flex: height * 0.8 <= width ? 1 : 3,
              child: SizedBox(
                child: Column(
                  children: [
                    Image.asset(
                      cameraViewPngImage,

                    ),
                    SizedBox(height: height * 0.85 <= width ? 0: WhilabelSpacing.space32),
                    Text(
                      "오늘 마신 위스키를 기록해볼까요?",
                      style: TextStylesManager.bold20,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: height * 0.85 <= width ? 0: WhilabelSpacing.space24),
                    Row(
                      children: [
                        Expanded(flex: 10, child: SizedBox()),
                        Expanded(
                          flex: 34,
                          child: LongTextButton(
                            buttonText: "위스키 기록하기",
                            color: ColorsManager.brown100,
                            onPressedFunc: () async{


                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WhiskyBarCodeScanPage(
                                          cameras: viewModel.state.cameras,
                                        ),
                                  ));

                            },
                          ),
                        ),
                             Expanded(flex:  10, child: SizedBox())
                      ],
                    ),
                  ],
                ),
              ),
            ),
            height * 0.8 <= width
                ?  SizedBox()
                : SizedBox(height: 20)
          ],
        ),
      ),
    ));
  }
}
