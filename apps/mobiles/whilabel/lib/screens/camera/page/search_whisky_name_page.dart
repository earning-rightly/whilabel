import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/whisky/short_whisky.dart';
import 'package:whilabel/provider_manager.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';

// ignore: must_be_immutable
class SerachWhiskyNamePage extends StatelessWidget {
  SerachWhiskyNamePage({super.key});

  final testWhikyDB = ProvidersManager.testWhiskDB();

  List<ShortWhiskyData> searchedResult = [];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CarmeraViewModel>();
    final state = viewModel.state;

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            style: TextStylesManager.regular16,
            decoration: createBasicTextFieldStyle("영어랑 숫자만 가능", true),
            // onChanged: (value) {
            //   setState(() {
            //     barCodeText = value;
            //   });
            // },
            onSubmitted: (value) async {
              // searchedResult = await testWhikyDB.getWhiskyDataWithName(value);
              // viewModel.searchWhiskyWithName(value);
              viewModel.onEvent(CarmeraEvent.searchWhiskyWithName(value),
                  callback: () {
                // setState(() {});
              });
            },
          ),
        ),
        body: SafeArea(
          child: Stack(children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
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
  late String whiskyStrength;
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
    final viewModel = context.watch<CarmeraViewModel>();

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
        viewModel.onEvent(CarmeraEvent.searchWhiskeyWithBarcode(whiskyBarcode),
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
    );
  }
}
