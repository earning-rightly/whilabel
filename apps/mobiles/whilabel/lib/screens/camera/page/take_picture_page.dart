import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/camera/page/chosen_image_page.dart';

import 'gallery_page.dart';

/// CameraApp is the Main Application.
class TakePicturePage extends StatefulWidget {
  TakePicturePage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<TakePicturePage> createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage>
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
      // _showCameraException(e);
      debugPrint("$e");
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
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
  }

  @override
  void dispose() {
    controller.dispose();
    _flashModeControlRowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        appBar: AppBar(
            leading: _flashModeControlRowWidget(),
            centerTitle: true,
            title: SvgPicture.asset(SvgIconPath.onBoardingStep2),
            actions: [
              IconButton(
                padding: EdgeInsets.only(left: 16),
                alignment: Alignment.centerLeft,
                icon: SvgPicture.asset(SvgIconPath.close),
                onPressed: () {
                  showMoveRootDialog(context, title: "위스키 기록을 중단 하실건가요?",rootIndex: 1);
                },
              ),
            ]),
        body: GestureDetector(

          onHorizontalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.dx > 50 &&
                Platform.isIOS) {
              print("onHorizontalDragEnd close");
              showMoveRootDialog(context, title: "위스키 기록을 중단 하실건가요?",rootIndex: 1);
            }
          },
          child: WillPopScope(
            onWillPop: () async {
              if (Platform.isAndroid) showMoveRootDialog(context, title:  "위스키 기록을 중단 하실건가요?",rootIndex: 1);

              return false;
            },
            child: SafeArea(
              child: SizedBox(
                // color: Colors.red,

                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,

                child: Column(
                  children: [
                    Flexible(
                        fit: FlexFit.tight,
                        flex: 38,
                        child: Stack(
                          alignment: Alignment.center,
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(
                              controller,
                            )
                          ],
                        )),

                    Flexible(
                        flex: 12,
                        child: Container(
                          color: Color.fromARGB(158, 6, 5, 5),
                          child: Stack(
                            children: [
                              // 갤러리 페이지 이동
                              Positioned(
                                bottom: 38,
                                right: 16,
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                    SvgIconPath.image,
                                    width: 44.w,
                                    height: 44.h,
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GalleryPage(),
                                    ),
                                  ),
                                ),
                              ),
                              // camera 셔터
                              Positioned(
                                bottom: 24,
                                left: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      "잘나온 위스키 사진을 찍어주세요!\n 위스키 대표 사진으로 사용될거에요!",
                                      style: TextStylesManager.regular16,
                                    ),
                                    SizedBox(height: 24.h),
                                    InkWell(
                                      onTap: () async {
                                    try {
                                        XFile? rawImage = await takePicture();
                                        if (rawImage != null) {
                                          File imageFile = File(rawImage.path);
                                          int currentUnix =
                                              DateTime
                                                  .now()
                                                  .millisecondsSinceEpoch;
                                          final directory =
                                          await getApplicationDocumentsDirectory();
                                          String fileFormat =
                                              imageFile.path
                                                  .split('.')
                                                  .last;

                                          File finalImage = await imageFile
                                              .copy(
                                            '${directory
                                                .path}/$currentUnix.$fileFormat',
                                          );

                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChosenImagePage(
                                                      isUnableSlide: false,
                                                      finalImage,
                                                      0
                                                    // Pass the automatically generated path to
                                                    // the DisplayPictureScreen widget.

                                                  ),
                                            ),
                                          );
                                        } } catch (e) {
                                        // If an error occurs, log the error to the console.
                                          print(e);
                                        }
                                      },

                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              SvgIconPath.cameraShutter,
                                              width: 72.w,
                                              height: 72.h
                                          ),

                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
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


}

