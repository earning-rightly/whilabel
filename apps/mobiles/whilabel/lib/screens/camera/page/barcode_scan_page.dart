import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:whilabel/screens/_global/functions/show_simple_dialog.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';

import '../view_model/camera_view_model.dart';

// class BarCodeScanPage extends StatelessWidget {
//   const BarCodeScanPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Mobile Scanner')),
//       body: MobileScanner(
//         fit: BoxFit.contain,
//         controller: MobileScannerController(
//           facing: CameraFacing.back,
//           torchEnabled: false,
//           returnImage: true,
//         ),
//         onDetect: (capture) {
//           final List<Barcode> barcodes = capture.barcodes;
//           final Uint8List? image = capture.image;
//           for (final barcode in barcodes) {
//             debugPrint('Barcode found! ${barcode.rawValue}');
//           }
//           if (image != null) {
//             showSimpleDialog(context, "바코드인식 성공", "");
//             // showDialog(
//             //   context: context,
//             //   builder: (context) => Image(image: MemoryImage(image)),
//             // );
//             // Future.delayed(const Duration(seconds: 5), () {
//             //   Navigator.pop(context);
//             // });
//           }
//         },
//       ),
//     );
//   }
// }

class BarCodeScanPage extends StatelessWidget {
  BarCodeScanPage({super.key});

  String result = '';

  bool searchResult = false;

  int _failCounter = 0;

  StreamController<int> _events = StreamController();

  // @override
  void addFailCounter() {
    _failCounter++;
    _events.add(_failCounter);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CarmeraViewModel>();
    final state = viewModel.state;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    )).then((value) {
                  if (value is String) {
                    // setState(() {
                    //   result = value;
                    // });

                    viewModel
                        .onEvent(CarmeraEvent.searchWhiskeyWithBarcode(value),
                            callback: () async {
                      if (viewModel.state.isFindWhiskyData) {
                        await showSuccedDialog();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GalleryPage(),
                          ),
                        );
                      } else {
                        addFailCounter();
                      }
                    });
                  }
                });
              },
              child: const Text('Open Scanner'),
            ),
            StreamBuilder<int>(
                stream: _events.stream,
                builder: (context, snapshot) {
                  return Text('Barcode Result: ${snapshot.data.toString()}');
                }),
          ],
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
}
