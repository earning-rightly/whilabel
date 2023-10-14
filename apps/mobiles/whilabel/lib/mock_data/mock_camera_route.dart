import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/camera/page/barcode_scan_page.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';
import 'package:whilabel/screens/camera/page/search_whisky_name_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';

class MockCameraRoute extends StatefulWidget {
  const MockCameraRoute({super.key});

  @override
  State<MockCameraRoute> createState() => _MockCameraRouteState();
}

class _MockCameraRouteState extends State<MockCameraRoute> {
  String barCodeText = "";
  final TextEditingController barCodeTextController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    barCodeTextController.dispose();
  }

  // final testWhikyDB = ProvidersManager.testWhiskDB();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("mock camera route")),
      body: Builder(builder: (context) {
        final viewModel = context.read<CarmeraViewModel>();

        return Center(
            child: Column(
          children: [
            TextField(
              style: TextStylesManager.regular16,
              decoration: createBasicTextFieldStyle("숫자만 가능", true),
              controller: barCodeTextController,
            ),
            ElevatedButton(
              child: Text("위스키 기록하기"),
              onPressed: () async {
                viewModel.onEvent(
                    CarmeraEvent.searchWhiskeyWithBarcode(
                        barCodeTextController.text), callback: () {
                  setState(() {});
                  if (viewModel.state.isFindWhiskyData) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryPage(),
                      ),
                    );
                  }
                });
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GalleryPage()),
                  );
                },
                child: Text("garellery")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SerachWhiskyNamePage()),
                  );
                },
                child: Text("SerachWhiskyNamePage")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BarCodeScanPage()),
                  );
                },
                child: Text("BarCodeScanPage")),
          ],
        ));
      }),
    );
  }
}
