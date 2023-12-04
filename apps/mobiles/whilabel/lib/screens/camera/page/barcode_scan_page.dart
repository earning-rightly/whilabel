import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/camera/page/searching_whisky_barcode_page.dart';


/// CameraApp is the Main Application.
class BarCodeScanPage extends StatefulWidget {
   BarCodeScanPage({super.key, required this.cameras});
   final List<CameraDescription> cameras;

  @override
  State<BarCodeScanPage> createState() => _BarCodeScanPageState();
}

class _BarCodeScanPageState extends State<BarCodeScanPage> {
  late CameraController controller;

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

  @override
  void initState() {
    super.initState();

    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
        appBar: buildScaffoldAppBar(context,SvgIconPath.close,""),
        body:  SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,

            child: Stack(
              alignment: Alignment.center,
              fit: StackFit.expand,
              children: [
                CameraPreview(controller),
                // cameraOverlay(
                //     padding: 50, aspectRatio: 1, color: Color(0x55000000)),
                myLayOut(
                    padding: 50, aspectRatio: 1, color: Color(0x55000000)),
                Positioned(
                  // left: 0,
                  // right: 0,
                    bottom: 174,
                    child: Text("위스키 병에 바코드를 찍어주세요" )),

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
                            child: Icon(Icons.image, color: ColorsManager.gray500,size: 24),
                          ),
                          InkWell(
                            onTap: () async {
                              XFile? rawImage = await takePicture();
                              if(rawImage != null){
                                File imageFile = File(rawImage.path);
                                int currentUnix = DateTime.now().millisecondsSinceEpoch;
                                final directory = await getApplicationDocumentsDirectory();
                                String fileFormat = imageFile.path.split('.').last;

                                File barcodeImage = await imageFile.copy(
                                  '${directory.path}/$currentUnix.$fileFormat',
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchingWhiskyBarcodePage(imageFile:barcodeImage)
                                    ));
                              }
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(Icons.circle, color: Colors.white38, size: 90),
                                Icon(Icons.circle, color: Colors.white, size: 75),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                ),],),),
        )
    );
  }
  Widget cameraOverlay({required double padding, required double aspectRatio, required Color color}) {
    return LayoutBuilder(builder: (context, constraints) {
      double parentAspectRatio = constraints.maxWidth / constraints.maxHeight;
      double horizontalPadding;
      double verticalPadding;

      if (parentAspectRatio < aspectRatio) {
        debugPrint("parentAspectRatio < aspectRatio case");
        horizontalPadding = padding;
        verticalPadding = (constraints.maxHeight -
            ((constraints.maxWidth - 2 * padding) / aspectRatio)) *1.1 ;
      } else {
        verticalPadding = padding;
        horizontalPadding = (constraints.maxWidth -
            ((constraints.maxHeight - 2 * padding) * aspectRatio)) /
            2;
      }
      return Stack(fit: StackFit.expand, children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Container(width: horizontalPadding, color: color)),
        Align(
            alignment: Alignment.centerRight,
            child: Container(width: horizontalPadding, color: color)),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color)),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.only(
                    left: horizontalPadding, right: horizontalPadding),
                height: verticalPadding,
                color: color)),
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: horizontalPadding, vertical: verticalPadding),
        )
      ]);
    });
  }

  Widget myLayOut ({required double padding, required double aspectRatio, required Color color}){

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
            ),),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              height: double.infinity,
              width: 16,
              color: color,
            ),),
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
                    border: Border.all(color: Colors.white,width: 2),

                  ),
                ),
              ),

              Flexible(
                flex: 18,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  color: color,
                ),
              ),  ],
          ),
        ],
      );
    }
    );}
}
