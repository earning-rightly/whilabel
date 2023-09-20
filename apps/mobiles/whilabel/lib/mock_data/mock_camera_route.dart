import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/global/functions/text_field_styles.dart';

class MockCameraRoute extends StatefulWidget {
  const MockCameraRoute({super.key});

  @override
  State<MockCameraRoute> createState() => _MockCameraRouteState();
}

class _MockCameraRouteState extends State<MockCameraRoute> {
  String barCodeText = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CarmeraViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text("mock camera route")),
      body: Center(
          child: Column(
        children: [
          TextField(
            style: TextStylesManager()
                .createHadColorTextStyle("R16", ColorsManager.gray500),
            decoration: createBasicTextFieldStyle("숫자만 가능", true),
            onChanged: (value) {
              setState(() {
                barCodeText = value;
              });
            },
          ),
          ElevatedButton(
            child: Text("위스키 기록하기"),
            onPressed: () async {
              viewModel
                  .onEvent(CarmeraEvent.searchWhiskeyWithBarcode(barCodeText),
                      callback: () {
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
        ],
      )),
    );
  }
}
