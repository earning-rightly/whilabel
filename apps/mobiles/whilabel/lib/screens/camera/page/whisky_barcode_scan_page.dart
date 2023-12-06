import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_recognition_page.dart';

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
    // if (controller == null) {
    //   return;
    // }

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

    controller = CameraController(widget.cameras[0], ResolutionPreset.max,enableAudio: false);
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
        appBar: AppBar(actions: [_flashModeControlRowWidget()]),
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
                Positioned(bottom: 174, child: Text("위스키 병에 바코드를 찍어주세요")),
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
                              icon: Icon(Icons.image,
                                  color: ColorsManager.gray500, size: 24),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GalleryPage(
                                    isFindingBarcode: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              XFile? rawImage = await takePicture();
                              if (rawImage != null) {
                                File imageFile = File(rawImage.path);
                                int currentUnix =
                                    DateTime.now().millisecondsSinceEpoch;
                                final directory =
                                    await getApplicationDocumentsDirectory();
                                String fileFormat =
                                    imageFile.path.split('.').last;

                                File barcodeImage = await imageFile.copy(
                                  '${directory.path}/$currentUnix.$fileFormat',
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WhiskyBarcodeRecognitionPage(
                                                imageFile: barcodeImage)));
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(Icons.circle,
                                    color: Colors.white38, size: 90),
                                Icon(Icons.circle,
                                    color: Colors.white, size: 75),
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
    return SizeTransition(
      sizeFactor: _flashModeControlRowAnimation,
      child: ClipRect(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
                icon: const Icon(Icons.flash_off),
                color: controller.value.flashMode == FlashMode.off
                    ? Colors.orange
                    : ColorsManager.gray400,
                onPressed: () => onSetFlashModeButtonPressed(FlashMode.off)),
            IconButton(
                icon: const Icon(Icons.flash_auto),
                color: controller.value.flashMode == FlashMode.auto
                    ? Colors.orange
                    : ColorsManager.gray400,
                onPressed: () => onSetFlashModeButtonPressed(FlashMode.auto)),
            IconButton(
                icon: const Icon(Icons.flash_on),
                color: controller.value.flashMode == FlashMode.always
                    ? Colors.orange
                    : ColorsManager.gray400,
                onPressed: () => onSetFlashModeButtonPressed(FlashMode.always)),
            IconButton(
                icon: const Icon(Icons.highlight),
                color: controller.value.flashMode == FlashMode.torch
                    ? Colors.orange
                    : ColorsManager.gray400,
                onPressed: () => onSetFlashModeButtonPressed(FlashMode.torch)),
          ],
        ),
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
                    border: Border.all(color: Colors.white, width: 2),
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
