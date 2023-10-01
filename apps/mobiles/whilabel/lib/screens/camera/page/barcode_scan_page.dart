import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';

import '../view_model/camera_view_model.dart';

// ignore: must_be_immutable
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
