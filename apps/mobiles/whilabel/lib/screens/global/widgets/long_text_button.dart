import 'package:flutter/material.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';

class LongTextButton extends StatelessWidget {
  final String buttonText;
  final Color buttonTextColor;
  final double buttionTextSize;
  final Function()? onPressedFunc;
  final bool? enabled;
  final Function()? onPressedFuncWhenDisabled;
  final Color color;
  final Color borderColor;
  final double height;

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
    this.buttionTextSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (enabled == false) ? onPressedFuncWhenDisabled : null,
      child: Container(
        width: double.infinity,
        decoration: enabled!
            ? BoxDecoration(
                border: Border.all(
                width: 0.5,
                color: borderColor,
              ))
            : null,
        height: height,
        child: ElevatedButton(
          onPressed: (enabled == false) ? null : onPressedFunc,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: ColorsManager.white, // 활성화 시 글자색
            backgroundColor: color, // 활성화 시 배경색
            disabledForegroundColor: ColorsManager.gray, // 비활성화 시 글자색 todo 미정
            disabledBackgroundColor: ColorsManager.gray300, // 비활성화 시 배경색
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            textStyle: TextStyle(
              fontSize: buttionTextSize,
              fontWeight: FontWeight.w400,
            ),
          ),
          child: Text(
            buttonText,
            style: TextStyle(color: buttonTextColor),
          ),
        ),
      ),
    );
  }
}
