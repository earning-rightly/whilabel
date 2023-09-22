import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';

class BasicDivider extends StatelessWidget {
  final Color? color;
  final double? thickness;
  const BasicDivider({
    Key? key,
    this.color,
    this.thickness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? ColorsManager.black200,
      thickness: thickness ?? 2,
    );
  }
}
