import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';

import '../view_model/camera_event.dart';
import '../view_model/camera_view_model.dart';
import '../widget/image_scan_animation.dart';

class WhiskyBarcodeRecognitionPage extends StatefulWidget {
  // todo
  // 1. 바코드 스캔 useCaase 만들기
  // 2. 바코드 resize 비율 새로 만들기
  // 3. 바코드 이미지 테스트 코드 만들기
  const WhiskyBarcodeRecognitionPage({Key? key, required this.imageFile})
      : super(key: key);
  final File imageFile;

  @override
  State<WhiskyBarcodeRecognitionPage> createState() =>
      _WhiskyBarcodeRecognitionPageState();
}

class _WhiskyBarcodeRecognitionPageState
    extends State<WhiskyBarcodeRecognitionPage> {
  @override
  void initState() {
    final viewModel = context.read<CameraViewModel>();

    Future.delayed(const Duration(milliseconds: 1000), () {
      viewModel.scanBarcode(widget.imageFile);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CameraViewModel>();
    String? whiskyBarcode = context.select<CameraViewModel, String?>(
        (CameraViewModel cameraViewModel) => cameraViewModel.state.barcode);

    if (whiskyBarcode != null) {
      Future.delayed(const Duration(milliseconds: 2000), () {
        viewModel.onEvent(CameraEvent.searchWhiskeyWithBarcode(whiskyBarcode),
            callback: () async {
          if (whiskyBarcode != "" && viewModel.state.isFindWhiskyData) {

            Navigator.pushReplacementNamed(context, Routes.cameraRoutes.takePictureRoute,
            arguments: viewModel.state.cameras);

          } else {
            await Navigator.pushReplacementNamed(
                context, Routes.cameraRoutes.unregisteredWhiskyRoute,
                arguments: widget.imageFile);
          }
        });
      });
    }
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
                flex: 10,
                child: Container(
                  color: Colors.transparent,
                )),
            Stack(
              children: [
                ImageScanAnimation(
                  imageFile: widget.imageFile,
                  width: 343.w,
                  height: 427.h,
                ),
              ],
            ),
            Flexible(
                flex: 14,
                child: Container(
                  padding: EdgeInsets.only(top: WhilabelSpacing.space32),
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.discreteCircle(
                        color: ColorsManager.gray500,
                        secondRingColor: ColorsManager.gray500,
                        size: 20,
                      ),
                      SizedBox(width: 5),
                      Text("이미지 분석중입니다")
                    ],
                  ),
                )),
          ],
        ),
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

  Future<void> showFailedDialog() async {
    await EasyLoading.showError(
      "바코드를 인식할 수 없습니다\n다시 시도해주세요",
    );
    if (EasyLoading.isShow) {
      // await Future.delayed(const Duration(seconds: 3));
      Timer(Duration(milliseconds: 4000), () {
        EasyLoading.dismiss();
      });
    }
  }
}
