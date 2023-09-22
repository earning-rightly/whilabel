import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';

class ListTitleIconButton extends StatelessWidget {
  const ListTitleIconButton({
    super.key,
    this.onPressedButton,
    this.spacing = 8,
    required this.svgPath,
    required this.titleText,
  });
  final String svgPath;
  final String titleText;
  final Function()? onPressedButton;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: WhilabelSpacing.spac16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              svgPath,
              height: 25,
              colorFilter:
                  ColorFilter.mode(ColorsManager.black400, BlendMode.srcIn),
            ),
            SizedBox(
              width: spacing,
            ),
            Text(
              titleText,
              style: TextStylesManager.medium16,
            ),
          ],
        ),
      ),
      onTap: onPressedButton ?? () {},
    );
  }
}
