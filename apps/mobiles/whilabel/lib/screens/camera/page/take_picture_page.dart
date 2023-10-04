// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// // Future<void> main() async {
// //   WidgetsFlutterBinding.ensureInitialized();

// //   _cameras = await availableCameras();
// //   runApp(const CameraApp());
// // }

// /// CameraApp is the Main Application.
// class TakePicturePage extends StatefulWidget {
//   /// Default Constructor
//   const TakePicturePage({super.key});

//   @override
//   State<TakePicturePage> createState() => _TakePicturePageState();
// }

// class _TakePicturePageState extends State<TakePicturePage> {
//   late CameraController controller;
//   late List<CameraDescription> _cameras;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(_cameras[0], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() async {
//         _cameras = await availableCameras();
//       });
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             // Handle access errors here.
//             break;
//           default:
//             // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return MaterialApp(
//       home: CameraPreview(controller),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';

// Future<void> main() async {
//   // Ensure that plugin services are initialized so that `availableCameras()`
//   // can be called before `runApp()`
//   WidgetsFlutterBinding.ensureInitialized();

//   // Obtain a list of the available cameras on the device.
//   final cameras = await availableCameras();

//   // Get a specific camera from the list of available cameras.
//   final firstCamera = cameras.first;

//   runApp(
//     MaterialApp(
//       theme: ThemeData.dark(),
//       home: TakePictureScreen(
//         // Pass the appropriate camera to the TakePictureScreen widget.
//         camera: firstCamera,
//       ),
//     ),
//   );
// }

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CarmeraViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      // body: Image.file(File(imagePath)),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(flex: 50, child: SizedBox()),
            Expanded(
              flex: 468,
              child: SizedBox(
                child: Image.file(File(imagePath), fit: BoxFit.fill),
              ),
            ),
            Expanded(flex: 20, child: SizedBox()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              // padding: EdgeInsets.all(0),
              child: LongTextButton(
                buttonText: "다음",
                color: ColorsManager.brown100,
                onPressedFunc: () async {
                  try {
                    // Medium패기지 내장 함수
                    // File imageFile = await widget.medium.getFile();

                    await viewModel.saveImageFileOnProvider(File(imagePath));

                    Navigator.pushNamed(context, Routes.whiskeyCritiqueRoute);
                  } catch (error) {
                    debugPrint("사진 저장 오류 발생!!\n$error");
                  }
                },
              ),
            ),
            SizedBox(height: WhilabelSpacing.spac16)
          ],
        ),
      ),
    );
  }
}
