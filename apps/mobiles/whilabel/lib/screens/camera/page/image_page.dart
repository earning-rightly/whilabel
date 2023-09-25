import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';

class ImagePage extends StatefulWidget {
  final Medium medium;
  final int index;

  // ignore: prefer_const_constructors_in_immutables
  ImagePage(Medium medium, int index)
      : medium = medium,
        index = index;

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
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(SvgIconPath.downLoad),
            padding: EdgeInsets.only(right: 16),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 60, child: SizedBox()),
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
            Expanded(flex: 100, child: SizedBox()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // padding: EdgeInsets.all(0),
              child: LongTextButton(
                buttonText: "다음",
                color: ColorsManager.brown100,
                onPressedFunc: () async {
                  try {
                    // final File imageFile = await widget.medium.getFile()..writeAsBytes(await Im.encodeNamedImage(smallerImage, realExt));
                    File _imageFile = await widget.medium.getFile();

                    // todo if문으로 사진에 크기가 1mb 이하면 더 이상 줄이지 않고 드대로 업로드
                    // if (_imageFile.)
                    final imageFile = await FlutterNativeImage.compressImage(
                        _imageFile.path,
                        quality: 90,
                        targetHeight: 1411,
                        targetWidth: 1058);

                    viewModel.saveImageFileOnProvider(imageFile);

                    Navigator.pushNamed(context, Routes.whiskeyCritiqueRoute);
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
