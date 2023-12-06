import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:barcode_finder/barcode_finder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';

import '../view_model/camera_event.dart';
import '../view_model/camera_view_model.dart';
import 'package:image/image.dart' as img;


class SearchingWhiskyBarcodePage extends StatefulWidget {
  const SearchingWhiskyBarcodePage(
      {Key? key, required this.imageFile})
      : super(key: key);
  final File imageFile;

  @override
  State<SearchingWhiskyBarcodePage> createState() => _SearchingWhiskyBarcodePageState();
}

class _SearchingWhiskyBarcodePageState extends State<SearchingWhiskyBarcodePage> {
  String barcode = "";
  File? initImageFile;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      scanFileinLocalMemory(widget.imageFile);
    });

    super.initState();
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
          height: decodedImage.height > 850? 800:decodedImage.height,
          width: decodedImage.width > 650 ? 600: decodedImage.width
      );
      Uint8List unit8ListPng = img.encodePng(thumbnail);


      File SavedPngImage = File("${tempDir.path}/${Timestamp.now().millisecondsSinceEpoch}.png")
        ..writeAsBytes(unit8ListPng);
      debugPrint("\n\nresult ==> ${SavedPngImage.path}\n\n---");

        setState(() {
          initImageFile = SavedPngImage;
        });
        Future.delayed(const Duration(milliseconds: 2000), ()
        { scanBarcodeImage(SavedPngImage.path); });
      }
  }

  void scanBarcodeImage(String imagePath) async {

    try{
      String? _barcodeString =
      await BarcodeFinder.scanFile(path: imagePath);
      if (_barcodeString != null) {
        setState(() {
          barcode = _barcodeString;
        });
      }else {
        setState(() {
          barcode = "scan error";
        });
      }
    }
    catch(e) {
      debugPrint("$e");
      setState(() {
        barcode = "scan error";
      });
      throw Exception("barcode scan error ");
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CarmeraViewModel>();

    // 계속 실행되는 것을 막기 위해서
    if (barcode != "" && initImageFile != null) {

        initImageFile = null;
        viewModel.onEvent(CarmeraEvent.searchWhiskeyWithBarcode(barcode),
            callback: () async {
          if (viewModel.state.isFindWhiskyData) {
            showSuccedDialog();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => GalleryPage(),
              ),
            );
          } else {
            showFailedDialog();
            Navigator.pushNamedAndRemoveUntil(context,arguments: 1,
                Routes.rootRoute, (route) => false);

            // addFailCounter();
          }

      });
    }

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
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AspectRatio(
                      aspectRatio: 1 / 1.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: SizedBox(
                          width: 343,
                          height: 427,
                          child: Image.file(
                            widget.imageFile,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    color: ColorsManager.gray500,
                    thickness: 3,
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
      ),
    );

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
      "바코드 인식 실패\n다시 시도해주세요",
    );
    if (EasyLoading.isShow) {
      // await Future.delayed(const Duration(seconds: 3));
      Timer(Duration(milliseconds: 3000), () {
        EasyLoading.dismiss();
      });
    }
  }
}
