import 'dart:io';
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

import 'searching_whisky_barcode_page.dart';

// ignore: must_be_immutable
class ImagePage extends StatefulWidget {
  bool isFindingBarcode;
  final Medium medium;
  final int index;

  // ignore: prefer_const_constructors_in_immutables
  ImagePage(Medium medium, int index, {bool isFindingBarcode = false})
      : medium = medium,
        index = index,
        isFindingBarcode = isFindingBarcode;

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CarmeraViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(SvgIconPath.backBold),
        ),
        actions: [
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 12,horizontal: 8),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.black300
              ),
                child: Text("편집", style: TextStyle(color: ColorsManager.gray400),),
                onPressed: () async {
                  File imageFile = await widget.medium.getFile();

                  CroppedFile? croppedFile = await ImageCropper().cropImage(
                    sourcePath: imageFile.path,
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
                        builder: (context) => SearchingWhiskyBarcodePage(
                          imageFile: File(croppedFile.path),
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        arguments: 1,
                        Routes.rootRoute,
                        (route) => false);
                  }
                },
              ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 76, child: SizedBox()),
            Expanded(
              flex: 468,
              child: SizedBox(
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: PhotoProvider(mediumId: widget.medium.id),
                ),
              ),
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
                          File imageFile = await widget.medium.getFile();
                          setState(() {});

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchingWhiskyBarcodePage(
                                imageFile: imageFile,
                              ),
                            ),
                          );
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
                          File imageFile = await widget.medium.getFile();

                          await viewModel
                              .saveUserWhiskyImageOnNewArchivingPostState(
                                  imageFile);

                          Navigator.pushNamed(
                              context, Routes.whiskeyCritiqueRoute);
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
