import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';

class LongTextButton extends StatelessWidget {
  final String buttonText;
  final Color buttonTextColor;
  final TextStyle? buttonTextStyle;
  final Function()? onPressedFunc;
  final bool? enabled;
  final Function()? onPressedFuncWhenDisabled;
  final Color color;
  final Color borderColor;
  final double height;
  final double width;
  final ButtonStyle? buttonStyle;

  const LongTextButton({
    super.key,
    required this.buttonText,
    this.onPressedFunc,
    this.onPressedFuncWhenDisabled,
    this.color = Colors.black,
    this.borderColor = Colors.black,
    this.buttonTextColor = Colors.white,
    this.enabled = true,
    this.height = 50,
    this.width = double.infinity,
    this.buttonTextStyle,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (enabled == false) ? onPressedFuncWhenDisabled : null,
      child: Container(
        width: width,
        decoration: enabled!
            ? BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(WhilabelRadius.radius12),
                ),
                border: Border.all(
                  width: 0.5,
                  color: borderColor,
                ))
            : null,
        height: height,
        child: OutlinedButton(
          onPressed: (enabled == false) ? null : onPressedFunc,
          style: buttonStyle ??
              OutlinedButton.styleFrom(
                elevation: 0,
                foregroundColor: ColorsManager.white, // 활성화 시 글자색
                backgroundColor: color, // 활성화 시 배경색
                disabledForegroundColor:
                    ColorsManager.gray, // 비활성화 시 글자색 todo 미정
                disabledBackgroundColor: ColorsManager.gray300, // 비활성화 시 배경색
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(WhilabelRadius.radius12)),
                ),
                textStyle: TextStylesManager.bold16,
              ),
          child: Text(
            buttonText,
            style: buttonTextStyle ?? TextStyle(color: buttonTextColor),
          ),
        ),
      ),
    );
  }
}
