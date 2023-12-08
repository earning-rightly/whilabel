import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';

import 'whisky_barcode_recognition_page.dart';

// ignore: must_be_immutable
class ChosenImagePage extends StatefulWidget {
  bool isFindingBarcode;
  bool isUnableSlide;
  final File initFileImage;
  final int index;

  // ignore: prefer_const_constructors_in_immutables
  ChosenImagePage(File initFileImage, int index,
      {bool isFindingBarcode = false, bool isUnableSlide = true})
      : initFileImage = initFileImage,
        index = index,
        isFindingBarcode = isFindingBarcode,
        isUnableSlide = isUnableSlide;

  @override
  State<ChosenImagePage> createState() => _ChosenImagePageState();
}

class _ChosenImagePageState extends State<ChosenImagePage> {
  int currentIndex = 0;
  File? currentFile;

  @override
  void initState() {
    super.initState();
    setState(() {
      currentIndex = widget.index;
      currentFile = widget.initFileImage;
    });
  }

  Future<void> changeCurrentFimeImage(Medium medium) async {
    final imageFile = await medium.getFile();
    setState(() {
      currentFile = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();
    final state = viewModel.state;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(SvgIconPath.backBold),
        ),
        actions: (widget.isFindingBarcode == true)
            ? [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsManager.black300),
                    child: Text(
                      "편집",
                      style: TextStyle(color: ColorsManager.gray400),
                    ),
                    onPressed: () async {
                      if (currentFile != null) {
                        CroppedFile? croppedFile =
                            await ImageCropper().cropImage(
                          sourcePath: currentFile!.path,
                          aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
                          uiSettings: [
                            AndroidUiSettings(
                                toolbarTitle: 'crop barcode',
                                toolbarColor: ColorsManager.black200,
                                toolbarWidgetColor: Colors.white,
                                hideBottomControls: true,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            IOSUiSettings(
                              title: 'crop barcode',
                              hidesNavigationBar: true,
                            ),
                          ],
                        );

                        if (croppedFile != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WhiskyBarcodeRecognitionPage(
                                imageFile: File(croppedFile.path),
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                )
              ]
            : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 76, child: SizedBox()),
            Expanded(
              flex: 468,
              child: widget.isUnableSlide == true
                  ? CarouselSlider.builder(
                      // carouselController: buttonCarouselController,
                      options: CarouselOptions(
                        onPageChanged: (index, reason) =>
                            changeCurrentFimeImage(state.mediums[index]),
                        initialPage: widget.index,
                        autoPlay: false,
                        height: height,
                        viewportFraction: 1.0,
                        enlargeCenterPage: false,
                      ),
                      itemCount: state.mediums.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: MemoryImage(kTransparentImage),
                            image: PhotoProvider(
                                mediumId: state.mediums[itemIndex].id),
                          ))
                  : Image.file(currentFile!,
                      fit: BoxFit.fill,
                      width: MediaQuery.of(context).size.width),
            ),
            Expanded(flex: 76, child: SizedBox()),
            Padding(
              padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
              // padding: EdgeInsets.all(0),
              child: widget.isFindingBarcode == true
                  ? LongTextButton(
                      buttonText: "바코드 선택",
                      color: ColorsManager.red,
                      onPressedFunc: () async {
                        try {
                          // Medium패기지 내장 함수
                          if (currentFile != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    WhiskyBarcodeRecognitionPage(
                                  imageFile: currentFile!,
                                ),
                              ),
                            );
                          }
                          // Navigator.pushNamed(context, Routes.whiskeyCritiqueRoute);
                        } catch (error) {
                          debugPrint("사진 저장 오류 발생!!\n$error");
                        }
                      },
                    )
                  : LongTextButton(
                      buttonText: "다음",
                      color: ColorsManager.brown100,
                      onPressedFunc: () async {
                        try {
                          // Medium패기지 내장 함수

                          if (currentFile != null) {
                            await viewModel
                                .saveUserWhiskyImageOnNewArchivingPostState(
                                    currentFile!);

                            Navigator.pushNamed(
                                context, Routes.whiskeyCritiqueRoute);
                          }
                        } catch (error) {
                          debugPrint("사진 저장 오류 발생!!\n$error");
                        }
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
