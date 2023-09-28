import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';

void showSimpleDialog(
    BuildContext context, String title, String subTitle) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        backgroundColor: ColorsManager.black200,
        insetPadding: EdgeInsets.symmetric(horizontal: 30),
        contentPadding:
            EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStylesManager.bold20,
                ),
                SizedBox(height: 20),
                Text(subTitle, style: TextStylesManager.regular16),
                SizedBox(height: 30),
                LongTextButton(
                  buttonText: "확인",
                  enabled: true,
                  color: ColorsManager.black300,
                  onPressedFunc: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ],
      );
    },
  );
}
