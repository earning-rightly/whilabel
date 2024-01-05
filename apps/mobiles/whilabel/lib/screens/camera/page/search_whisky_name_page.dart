import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/whisky/short_whisky.dart';
import 'package:whilabel/provider_manager.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';

import 'gallery_page.dart';

// ignore: must_be_immutable
class SerachWhiskyNamePage extends StatelessWidget {
  SerachWhiskyNamePage({super.key});

  final testWhikyDB = ProvidersManager.testWhiskDB();

  List<ShortWhiskyData> searchedResult = [];
  final whiskyNameTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();
    final state = viewModel.state;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TextField(
            style: TextStylesManager.regular16,
            controller: whiskyNameTextController,
            decoration: createBasicTextFieldStyle(hintText: "영어랑 숫자만 가능"),
            onSubmitted: (value) async {
              print(value);

              EasyLoading.show(
                status: 'Searching...',
                maskType: EasyLoadingMaskType.black,
              );

              viewModel.onEvent(CameraEvent.searchWhiskyWithName(value),
                  callback: () {
                if (EasyLoading.isShow) {
                  Timer(Duration(milliseconds: 1000), () {
                    EasyLoading.dismiss();
                  });
                }
              });
            },
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: state.shortWhisyDatas.isEmpty
                  ? NoSearchResult()
                  : Column(children: [
                      for (ShortWhiskyData data in state.shortWhisyDatas)
                        SearchedWhiskyListTitle(
                          data: data,
                        )
                    ]),
            )
          ]),
        ));
  }
}

class SearchedWhiskyListTitle extends StatefulWidget {
  final ShortWhiskyData data;
  const SearchedWhiskyListTitle({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<SearchedWhiskyListTitle> createState() =>
      _SearchedWhiskyListTitleState();
}

class _SearchedWhiskyListTitleState extends State<SearchedWhiskyListTitle> {
  late String whiskyName;
  late double whiskyStrength;
  late String whiskyBarcode;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    whiskyName = widget.data.name;
    whiskyStrength = widget.data.strength;
    whiskyBarcode = widget.data.barcode;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();

    return ListTile(
      shape:
          Border(bottom: BorderSide(color: ColorsManager.black400, width: 1)),
      title: Text(
        whiskyName,
        style: TextStylesManager.bold16,
      ),
      trailing: Text(
        "$whiskyStrength%",
        style: TextStylesManager.bold14,
      ),
      subtitle: Text(
        "barCode $whiskyBarcode",
        style: TextStylesManager.regular14,
      ),
      onTap: () {
        viewModel.onEvent(CameraEvent.searchWhiskeyWithBarcode(whiskyBarcode),
            callback: () {
          showSuccedDialog();
          setState(() {});
          if (viewModel.state.isFindWhiskyData) {
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => TakePicturePage(cameras: viewModel.state.cameras),
                builder: (context) => GalleryPage(),
              ),
            );
          }
        });
      },
    );
  }

  Future<void> showSuccedDialog() async {
    await EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    if (EasyLoading.isShow) {
      Timer(Duration(milliseconds: 2000), () {
        EasyLoading.dismiss();
      });
    }
  }
}

class NoSearchResult extends StatelessWidget {
  const NoSearchResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorsManager.black200, width: 4),
      ),
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                "위스키 이름을 검색해주세요",
                style: TextStylesManager.createHadColorTextStyle(
                    "B20", ColorsManager.sky),
                overflow: TextOverflow.fade,
              ),
            ),
            Icon(
              Icons.find_in_page,
              color: ColorsManager.black400,
              size: 35,
            ),
          ],
        ),
        SizedBox(height: WhilabelSpacing.space8),
        Text("영어와 한글만 입력해주세요.\n아래 예시를 참고하고 입력해주세요"),
        SizedBox(
          height: WhilabelSpacing.space24,
        ),
        Text("ex)", textAlign: TextAlign.left),
        Text(
          "Balvenie12-year-old\nTomatin12-year-old\nHighland Park2003",
          style: TextStylesManager.regular14,
        ),
        SizedBox(height: WhilabelSpacing.space32)
      ]),
    );
  }
}
