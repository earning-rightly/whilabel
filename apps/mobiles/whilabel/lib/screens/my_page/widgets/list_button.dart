import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';

class ListTitleIconButton extends StatelessWidget {
  const ListTitleIconButton({
    super.key,
    required this.pageRoute,
    this.spacing = 8,
    required this.svgPath,
    required this.titleText,
  });
  final String svgPath;
  final String titleText;
  final String pageRoute;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: WhilabelSpacing.space16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                svgPath,
                height: 24,
                colorFilter: const ColorFilter.mode(ColorsManager.black400, BlendMode.srcIn),
              ),
              SizedBox(
                width: spacing,
              ),
              Text(
                titleText,
                style: TextStylesManager.medium16Gray200,
              ),
            ],
          ),
        ),
        onTap: () {
          if (pageRoute.isNotEmpty) {
            Navigator.pushNamed(context, pageRoute);
          }
        });
  }
}
