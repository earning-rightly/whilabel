import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';

// ignore: must_be_immutable
class ListToggleButton extends StatelessWidget {
  ListToggleButton({
    super.key,
    required this.title,
    required this.isToggleState,
    this.onPressedFunc,
  });
  final String title;
  final bool isToggleState;
  final Function()? onPressedFunc;

  String offToggleIconPath = SvgIconPath.toggleOff;
  String onToggleIconPath = SvgIconPath.toggleOn;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStylesManager().createHadColorTextStyle(
              "M16",
              ColorsManager.gray200,
            ),
          ),
          IconButton(
            iconSize: 70,
            onPressed: onPressedFunc,
            icon: SvgPicture.asset(
                isToggleState == true ? onToggleIconPath : offToggleIconPath),
          )
        ],
      ),
    );
  }
}
