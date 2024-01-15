import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/string_manger.dart' as strManger;
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_recognition_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';

import 'gallery_page.dart';

/// CameraApp is the Main Application.
class WhiskyBarCodeScanPage extends StatefulWidget {
  WhiskyBarCodeScanPage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<WhiskyBarCodeScanPage> createState() => _WhiskyBarCodeScanPageState();
}

class _WhiskyBarCodeScanPageState extends State<WhiskyBarCodeScanPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late CameraController controller;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;
  int flashIconIndex = 0;

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController!.value.isTakingPicture) {
      return null;
    }
    try {
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      print('Error occured while taking picture: $e');
      return null;
    }
  }

  void onSetFlashModeButtonPressed(FlashMode mode) {
    setFlashMode(mode).then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> setFlashMode(FlashMode mode) async {

    try {
      await controller.setFlashMode(mode);
    } on CameraException catch (e) {
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    final watchAgainCheckBox = Hive.box(strManger.WATCH_AGAIN_CHECKBOX);
    final isShowCameraRule= watchAgainCheckBox.get(strManger.CAMERA_RULE);

    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );

    controller = CameraController(widget.cameras[0], ResolutionPreset.max,
        enableAudio: false);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    if (isShowCameraRule == false || isShowCameraRule == null)
      showRuleForCamera(context);
  }

  @override
  void dispose() {
    controller.dispose();
    _flashModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              padding: EdgeInsets.only(left: 16),
              alignment: Alignment.centerLeft,
              icon: SvgPicture.asset(SvgIconPath.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            centerTitle: true,
            title: SvgPicture.asset(SvgIconPath.onBoardingStep1),
            actions: [_flashModeControlRowWidget()]),
        body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),
                cameraOverlay(
                    padding: 50,
                    aspectRatio: 1,
                    color: Color.fromARGB(158, 6, 5, 5)),
                Positioned(
                    bottom: 120,
                    child: Column(
                      children: [
                        SvgPicture.asset(SvgIconPath.barcode,
                            width: 52, height: 32),
                        SizedBox(height: 16),
                        Text("위스키 병의 바코드를 찍어주세요",
                            style: TextStylesManager.regular16),
                        SizedBox(height: 16),
                      ],
                    )),
                Positioned(
                    bottom: 24,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      // color: ColorsManager.black200,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                                icon: SvgPicture.asset(
                                  SvgIconPath.image,
                                  width: 44,
                                  height: 44,
                                ),
                                onPressed: () async {
                                  if (Platform.isIOS) {
                                    final ImagePicker picker = ImagePicker();
// Pick an image.
                                    final XFile? image = await picker.pickImage(
                                        source: ImageSource.gallery);
                                    if (image != null) {
                                      File currentFile = File(image.path);

                                      try {
                                        // Medium패기지 내장 함수

                                        await viewModel
                                            .saveUserWhiskyImageOnNewArchivingPostState(
                                                currentFile);

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                WhiskyBarcodeRecognitionPage(
                                                  imageFile: currentFile,
                                                ),
                                          ),
                                        );
                                      } catch (error) {
                                        debugPrint("사진 저장 오류 발생!!\n$error");
                                      }
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GalleryPage(
                                          isFindingBarcode: true,
                                        ),
                                      ),
                                    );
                                  }
                                }),
                          ),
                          InkWell(
                            onTap: () async {
                              XFile? rawImage = await takePicture();
                              if (rawImage != null) {
                                File imageFile = File(rawImage.path);

                                await Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WhiskyBarcodeRecognitionPage(
                                                imageFile: imageFile)));
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(SvgIconPath.cameraShutter,
                                    width: 72, height: 72),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

  Widget _flashModeControlRowWidget() {
    List<Widget> flastIcons = [
      Icon(Icons.flash_off, color: ColorsManager.gray400),
      Icon(Icons.flash_auto, color: ColorsManager.gray400),
      Icon(Icons.flash_on, color: ColorsManager.gray400),
      Icon(Icons.highlight, color: ColorsManager.gray400)
    ];

    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: IconButton(
            icon: flastIcons[flashIconIndex],
            onPressed: () {
              setState(() {
                if (flashIconIndex >= 3) {
                  flashIconIndex = 0;
                } else {
                  flashIconIndex++;
                }
              });

              switch (flashIconIndex) {
                case 0:
                  onSetFlashModeButtonPressed(FlashMode.off);
                  break;

                case 1:
                  onSetFlashModeButtonPressed(FlashMode.auto);
                  setState(() {
                    flashIconIndex = 1;
                  });
                  break;

                case 2:
                  onSetFlashModeButtonPressed(FlashMode.always);
                  setState(() {
                    flashIconIndex = 2;
                  });
                  break;

                case 3:
                  onSetFlashModeButtonPressed(FlashMode.torch);
                  setState(() {
                    flashIconIndex = 3;
                  });
                  break;
              }
            }),
      ),
    );
  }

  Widget cameraOverlay(
      {required double padding,
      required double aspectRatio,
      required Color color}) {
    return LayoutBuilder(builder: (context, constraints) {
      double widthCopy, heightCopy;

      if (padding <= 0 || aspectRatio <= 0) {
        throw ArgumentError('Invalid parameter values');
      }

      // Determine the rectangle's dimensions based on the aspect ratio
      if (aspectRatio > 1) {
        widthCopy = 1.0 - 2 * padding;
        heightCopy = widthCopy / aspectRatio;
      } else {
        heightCopy = 1.0 - 2 * padding;
        widthCopy = heightCopy * aspectRatio;
      }
      return Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              height: double.infinity,
              width: 16,
              color: color,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: double.infinity,
              width: 16,
              color: color,
            ),
          ),
          Column(
            children: [
              Flexible(
                flex: 10,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  color: color,
                ),
              ),
              AspectRatio(
                aspectRatio: 2.2 / 1,
                child: Container(
                  height: 172,
                  width: 340,
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  // clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    // color: Colors.,
                    border: Border.all(color: ColorsManager.gray500, width: 1),
                  ),
                ),
              ),
              Flexible(
                flex: 18,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  color: color,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
