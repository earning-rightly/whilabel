import "package:dartx/dartx.dart";
import "package:flutter/material.dart";
import "package:whilabel/screens/_constants/string_manger.dart" as strManger;
import "package:whilabel/screens/_constants/text_styles_manager.dart";

class DistilleryAndStrengthText extends StatelessWidget {
  final String? distilleryName;
  final double? strength;

  const DistilleryAndStrengthText(
      {Key? key, this.distilleryName, this.strength}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (distilleryName.isNullOrEmpty == false || strength != null && strength! > 0) {
      return Row(
          children: [
            distilleryName.isNullOrEmpty == false
                ? Text("$distilleryName",
              overflow: TextOverflow.ellipsis,
              style: TextStylesManager
                  .createHadColorTextStyle(
                  "R14", Colors.grey),)
                :  SizedBox(),
            ( distilleryName.isNullOrEmpty == false && strength != null && strength! > 0)
                ? const Row(
                  children: [
                    SizedBox(width: 5),
                    const Text("${strManger.dot}"),
                  ],
                )
                : const SizedBox(),
            strength != null
                ? Text("$strength%",
              overflow: TextOverflow.ellipsis,
              style: TextStylesManager
                  .createHadColorTextStyle(
                  "R14", Colors.grey),)
                : SizedBox(),
          ]
      );
    } else {
      return Text("위스키 정보 검토중",
        overflow: TextOverflow.ellipsis,
        style: TextStylesManager
            .createHadColorTextStyle(
            "R14", Colors.grey),);
    }
  }
}