import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';
import 'package:whilabel/screens/camera/page/search_whisky_name_page.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_scan_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("mock camera route")),
      body: Builder(builder: (context) {
        final viewModel = context.read<CameraViewModel>();

        return Center(
            child: Column(
          children: [
            TextField(
              style: TextStylesManager.regular16,
              decoration: createBasicTextFieldStyle(hintText: "숫자만 가능"),
              controller: barCodeTextController,
            ),
            OutlinedButton(
              child: Text("위스키 기록하기"),
              onPressed: () async {
                viewModel.onEvent(
                    CameraEvent.searchWhiskeyWithBarcode(
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
            OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GalleryPage()),
                  );
                },
                child: Text("garellery")),
            OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SerachWhiskyNamePage()),
                  );
                },
                child: Text("SerachWhiskyNamePage")),

          ],
        ));
      }),
    );
  }
}


void choicerWhiskyArchiving(BuildContext context){
  /// 나중에 개발하다가 필요할 수도 있기에 보관중인 코드 함수 안에서 정의된 viewModel은 사용 x
  final viewModel = context.read<CameraViewModel>(); // 사용 할때는 함수 밖에서 사용해야 합니다.

  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding:
        EdgeInsets.symmetric(horizontal: 18),
        color: ColorsManager.black200,
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

              // 바코드로 인식하기
              LongTextButton(
                buttonText: "위스키 병 바코드 인식",
                onPressedFunc: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WhiskyBarCodeScanPage(
                              cameras: viewModel.state.cameras,
                            ),
                      ));
                },
              ),
              SizedBox(
                  height: WhilabelSpacing.space8),
              LongTextButton(
                buttonText: "위스키 이름 검색",
                onPressedFunc: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SerachWhiskyNamePage()),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}