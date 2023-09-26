import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/whisky/short_whisky.dart';
import 'package:whilabel/provider_manager.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';

// ignore: must_be_immutable
class SerachWhiskyNamePage extends StatelessWidget {
  SerachWhiskyNamePage({super.key});

  final testWhikyDB = ProvidersManager.testWhiskDB();

  List<ShortWhiskyData> searchedResult = [];

  @override
  Widget build(BuildContext context) {
    //  final viewModel =
    final viewModel = context.watch<CarmeraViewModel>();
    final state = viewModel.state;

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            style: TextStylesManager()
                .createHadColorTextStyle("R16", ColorsManager.gray500),
            decoration: createBasicTextFieldStyle("숫자만 가능", true),
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
                  ListTile(
                    title: Text(
                      data.name,
                      style: TextStylesManager()
                          .createHadColorTextStyle("B16", Colors.white),
                    ),
                    trailing: Text(
                      "${data.strength}%",
                      style: TextStylesManager()
                          .createHadColorTextStyle("R14", Colors.white),
                    ),
                    subtitle: Text(
                      "barCode ${data.barcode}",
                      style: TextStylesManager()
                          .createHadColorTextStyle("R14", Colors.white),
                    ),
                  )
              ]),
            )
          ]),
        ));
  }
}
