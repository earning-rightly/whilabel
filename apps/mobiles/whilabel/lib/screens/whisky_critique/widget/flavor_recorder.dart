import 'package:flutter/material.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/flavor_range.dart';

class FlavorRecorder extends StatelessWidget {
  final Function(double value)? onChangeBodyRate;
  final Function(double value)? onChangeFlavorRate;
  final Function(double value)? onChangePeatRate;
  final TasteFeature? tastFeature;
  final double? size;
  final bool? disable;

  const FlavorRecorder({
    Key? key,
    this.onChangeBodyRate,
    this.onChangeFlavorRate,
    this.onChangePeatRate,
    this.tastFeature,
    this.size,
    this.disable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final flavorRangeSize = (constraints.maxWidth - 16) / 5;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: (WhilabelSpacing.spac16)),
            FlavorRange(
                disable: disable,
                initialCount: tastFeature?.bodyRate.toDouble() ?? 1,
                title: "바디감",
                subTitleLeft: "가벼움",
                subTitleRight: "무거움",
                onChangeRating: onChangeBodyRate,
                size: flavorRangeSize),
            SizedBox(height: (WhilabelSpacing.spac16)),
            FlavorRange(
                disable: disable,
                initialCount: tastFeature?.flavorRate.toDouble() ?? 1,
                title: "향",
                subTitleLeft: "섬세함",
                subTitleRight: "스모크함",
                onChangeRating: onChangeFlavorRate,
                size: flavorRangeSize),
            SizedBox(height: (WhilabelSpacing.spac16)),
            FlavorRange(
                disable: disable,
                initialCount: tastFeature?.peatRate.toDouble() ?? 1,
                title: "피트감",
                subTitleLeft: "언피트",
                subTitleRight: "피트함",
                onChangeRating: onChangePeatRate,
                size: flavorRangeSize),
          ],
        );
      },
    );
  }
}
