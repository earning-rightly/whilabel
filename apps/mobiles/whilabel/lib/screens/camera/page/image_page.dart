import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/routes_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/global/widgets/long_text_button.dart';

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
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 8, child: SizedBox()),
            Expanded(
              flex: 60,
              child: SizedBox(
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: PhotoProvider(mediumId: widget.medium.id),
                ),
              ),
            ),
            Expanded(flex: 10, child: SizedBox()),
            Padding(
              padding: WhilablePadding.bottomButtonPadding,
              child: LongTextButton(
                buttonText: "다음",
                color: ColorsManager.brown100,
                onPressedFunc: () async {
                  try {
                    final File imageFile = await widget.medium.getFile();
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
