import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';

ButtonStyle createBasicButtonStyle(Color color,
    {Size buttonSize = Size.infinite}) {
  return OutlinedButton.styleFrom(
    backgroundColor: color,
    fixedSize: buttonSize,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius12)),
    ),
  );
}
