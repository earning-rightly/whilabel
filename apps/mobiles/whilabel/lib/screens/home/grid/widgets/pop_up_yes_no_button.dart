import 'package:flutter/material.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';

// 예, 아니오 두 가지 경우로 구성 되는 팝업
class PopUpYesOrNoButton extends StatelessWidget {
  final String titleText;
  final String yesText;
  final Color? yesButtonColor;
  final Function()? clickYesFunc;

  final String noText;
  final Color? noButtonColor;
  final Function()? clickNoFunc;

  PopUpYesOrNoButton({
    super.key,
    required this.titleText,
    required this.yesText,
    this.yesButtonColor,
    this.clickYesFunc,
    required this.noText,
    this.noButtonColor,
    this.clickNoFunc,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero, // 디폴트 값이 존재하므로 0으로 만들어서 넗혀주기
      insetPadding: EdgeInsets.symmetric(horizontal: 5),
      backgroundColor: ColorsManager.black200,

      title: Container(
        width: 300, // AlertDialog의 width를 넓히기 위해서 사용
        child: Text(
          titleText,
          textAlign: TextAlign.center,
        ),
      ),
      titleTextStyle: TextStylesManager()
          .createHadColorTextStyle("B16", ColorsManager.gray500),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(WhilabelRadius.radius16))),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. No
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 15, right: 5),
                child: ElevatedButton(
                  onPressed: clickNoFunc,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: noButtonColor ?? ColorsManager.black300,
                    foregroundColor: ColorsManager.gray500,
                    fixedSize: Size(120, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(WhilabelRadius.radius12)),
                    side: BorderSide(
                      width: 1.0,
                      color: ColorsManager.black200,
                    ),
                  ),
                  child: Text(
                    noText,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            // 2. Yes
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 5, right: 15),
                child: ElevatedButton(
                  onPressed: clickYesFunc,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: yesButtonColor ?? ColorsManager.brown100,
                    foregroundColor: ColorsManager.gray500,
                    fixedSize: Size(120, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(WhilabelRadius.radius12)),
                    side: BorderSide(
                      width: 1.0,
                      color: ColorsManager.black200,
                    ),
                  ),
                  child: Text(
                    yesText,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
