import 'package:flutter/material.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/whiskey_register/widgets/flavor_range.dart';

class FlavorRecorder extends StatelessWidget {
  final Function(double value)? onChangeBodyRate;
  final Function(double value)? onChangeFlavorRate;
  final Function(double value)? onChangePeatRate;

  const FlavorRecorder({
    Key? key,
    this.onChangeBodyRate,
    this.onChangeFlavorRate,
    this.onChangePeatRate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "맛 기록 (선택)",
          style: TextStylesManager.bold16,
        ),
        SizedBox(height: (WhilabelSpacing.spac16)),
        FlavorRange(
          initialCount: 1,
          title: "바디감",
          subTitleLeft: "가벼움",
          subTitleRight: "무거움",
          onChangeRating: onChangeBodyRate,
        ),
        SizedBox(height: (WhilabelSpacing.spac16)),
        FlavorRange(
          initialCount: 1,
          title: "향",
          subTitleLeft: "섬세함",
          subTitleRight: "스모크함",
          onChangeRating: onChangeFlavorRate,
        ),
        SizedBox(height: (WhilabelSpacing.spac16)),
        FlavorRange(
          initialCount: 1,
          title: "피트감",
          subTitleLeft: "언피트",
          subTitleRight: "피트함",
          onChangeRating: onChangePeatRate,
        ),
      ],
    );
  }
}
