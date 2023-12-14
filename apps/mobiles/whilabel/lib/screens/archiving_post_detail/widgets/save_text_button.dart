import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

class SaveTextButton extends StatelessWidget {
  final Function()? onClickButton;

  const SaveTextButton({
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
        "저장",
        style: TextStylesManager.createHadColorTextStyle(
            "R14", ColorsManager.brown100),
      ),
    );
  }
}
