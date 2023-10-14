import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

class ModifyTextButton extends StatelessWidget {
  final Function()? onClickButton;
  const ModifyTextButton({
    Key? key,
    this.onClickButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          foregroundColor: ColorsManager.black400),
      onPressed: onClickButton ?? () {},
      child: Text(
        "수정",
        style: TextStylesManager.createHadColorTextStyle(
            "R14", ColorsManager.brown100),
      ),
    );
  }
}
