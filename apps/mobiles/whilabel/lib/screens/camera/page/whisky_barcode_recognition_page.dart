import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:barcode_finder/barcode_finder.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/const_string.dart'as ConstString ;
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/camera/page/take_picture_page.dart';
import 'package:whilabel/screens/camera/page/unregistered_whisky_page.dart';
import 'package:image/image.dart' as img;

import '../view_model/camera_event.dart';
import '../view_model/camera_view_model.dart';
import '../widget/image_scan_animation.dart';

class WhiskyBarcodeRecognitionPage extends StatefulWidget {
  /// 바코드 인식 결과를 총 3개로 나누었다.
  ///  1. 바코드 스캔 O. DB 메칭 O => 정상적으로 위스키 아카이빙 실행
  ///  2 바코드 스캔 O, DB 매칭 X => 인식되지 않는 위스키 로직 실행
  ///  3. 바코드 스캔 X   ===> 다시 바코드 인식을 요청하는 다이어로그 후 홈으로 이동
  const WhiskyBarcodeRecognitionPage({Key? key, required this.imageFile})
      : super(key: key);
  final File imageFile;

  @override
  State<WhiskyBarcodeRecognitionPage> createState() =>
      _WhiskyBarcodeRecognitionPageState();
}

class _WhiskyBarcodeRecognitionPageState
    extends State<WhiskyBarcodeRecognitionPage> {
  String barcode = "";
  bool isResizedImage = false;
  List<CameraDescription> cameras = [];
  StreamController<String> barcodeStream = StreamController<String>();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      scanFileinLocalMemory(widget.imageFile);
    });

    super.initState();
  }

  void addBarcodeOnStream(String barcode) {
    barcodeStream.add(barcode);
  }

  /// 이미지 크기 때문에 barcodeScan이 안되는 경우가 있다.
  /// 이미지 크기를 줄이므로 .png 변화가 빠르게 진행된다.
  Future<void> scanFileinLocalMemory(File imageFile) async {
    img.Image? decodedImage = img.decodeImage(imageFile.readAsBytesSync());
    final tempDir = await getTemporaryDirectory();
    debugPrint("원본이미지 주소 =>>\n   ${imageFile.path}");

    if (decodedImage != null) {
      // cropRect에 해당하는 부분을 decodeImageFromList() 함수를 사용하여 decodedImage로 변환합니다.
      // 이미지의 사이즈, byte가 크면 이미지 전환과 스캔하는데 오랜 시간이 걸린다.
      img.Image thumbnail = img.copyResize(decodedImage,
          height: decodedImage.height > 850 ? 800 : decodedImage.height,
          width: decodedImage.width > 650 ? 600 : decodedImage.width);
      Uint8List unit8ListPng = img.encodePng(thumbnail);

      File SavedPngImage =
          File("${tempDir.path}/${Timestamp.now().millisecondsSinceEpoch}.png")
            ..writeAsBytes(unit8ListPng);
      debugPrint("\n\nresult ==> ${SavedPngImage.path}\n\n---");

      setState(() {
        isResizedImage = true;
      });
      Future.delayed(const Duration(milliseconds: 2000), () async {
        final _barcodeScanResult = await scanBarcodeImage(SavedPngImage.path);
        if (_barcodeScanResult == null) {
          addBarcodeOnStream(ConstString.SCAN_ERROR);

          throw Exception("barcode scan error");
        } else {
          addBarcodeOnStream(_barcodeScanResult);
        }
      });
    }
  }

  Future<String?> scanBarcodeImage(String imagePath) async {
    try {
      String? _barcodeString = await BarcodeFinder.scanFile(path: imagePath);
      if (_barcodeString != null) {
        return _barcodeString;
      }
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();

    // Future<String> scan
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
                StreamBuilder<String>(
                    stream: barcodeStream.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && isResizedImage == true) {
                        // 1번만 동작 시키기 위해서 추가한 코드
                        isResizedImage = false;

                        if (snapshot.data ==ConstString.SCAN_ERROR) {
                          showFailedDialog().then((value) async {
                            await Navigator.pushNamed(
                                context, arguments: 1, Routes.rootRoute);
                          });
                        }
                        else {
                          viewModel.onEvent(
                              CameraEvent.searchWhiskeyWithBarcode(
                                  snapshot.data!), callback: () async {
                            //  TakePicture에서 사용할 카메라 초기화
                            WidgetsFlutterBinding.ensureInitialized();
                            cameras = await availableCameras();

                            // 1. 바코드 스캔 O. DB 메칭 O => 정상적으로 위스키 아카이빙 실행
                            if (viewModel.state.isFindWhiskyData) {
                              showSuccedDialog();
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TakePicturePage(cameras:  viewModel.state.cameras),
                                ),
                              );
                            } else {
                              // 2 바코드 스캔 O, DB 매칭 X => 인식되지 않는 위스키 로직 실행
                              await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UnregisteredWhiskyPage(
                                          imageFile: widget.imageFile),
                                ),
                              );
                            }
                          });
                        }
                      }
                      return ImageScanAnimation(imageFile: widget.imageFile,width:343.w ,height: 427.h,);
                    }),
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
