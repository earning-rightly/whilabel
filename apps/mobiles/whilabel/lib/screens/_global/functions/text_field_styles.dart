// 각각의 view 사용될 TextField에 디자인을 return 하는 함수를 모아둔 파일일입니다.
// TextFormField와 TextField 에서 사용 가능합니다.
import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';

// whiskey_register에서 사용
InputDecoration createBasicTextFieldStyle({
  String hintText = "",
  double paddingVertical = 0,
  double paddingHorizontal = 10
}) {
  return InputDecoration(

    // 에러가 났을때 전체를 빨간색을 TextFied전체를 감사기 위해서 사용
    // 버벅거림을 없에기 위해서
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius8)),
      borderSide: const BorderSide(
        color: ColorsManager.black400,
        width: 1,
      ),
    ),
    // 활성화 되기전 스타일
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius8)),
      borderSide: const BorderSide(
        color: ColorsManager.black400,
        width: 1,
      ),
    ),
    // 활성화 스타일
    contentPadding: EdgeInsets.only(left: paddingHorizontal, right: paddingHorizontal, top: paddingVertical, bottom: paddingVertical),
    focusColor: ColorsManager.gray200,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius8)),
      borderSide: const BorderSide(color: ColorsManager.gray500, width: 2),
    ),
    hintText: hintText,
    hintStyle: TextStylesManager.createHadColorTextStyle(
        "R16", ColorsManager.black400),
  );
}

InputDecoration createEnableBasicTextFieldStyle(
  String hintText,
  bool disable,
) {
  return InputDecoration(
    // 에러가 났을때 전체를 빨간색을 TextFied전체를 감사기 위해서 사용
    // 버벅거림을 없에기 위해서
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius8)),
      borderSide: const BorderSide(
        color: ColorsManager.black400,
        width: 2,
      ),
    ),
    // 활성화 되기전 스타일
  );
}

InputDecoration createLargeTextFieldStyle(
  String hinText,
) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius8)),
      borderSide: const BorderSide(
        color: ColorsManager.black400,
        width: 1,
      ),
    ),
    // 활성화 되기전 스타일
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius8)),
      borderSide: const BorderSide(
        color: ColorsManager.black400,
        width: 1,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius8)),
      borderSide: const BorderSide(
        color: ColorsManager.gray300,
        width: 1,
      ),
    ),
    // 활성화 스타일
    contentPadding: const EdgeInsets.only(top: 10, bottom: 12, left: 12, right: 12),
    focusColor: ColorsManager.yellow,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(WhilabelRadius.radius8)),
      borderSide: const BorderSide(color: ColorsManager.gray500, width: 2),
    ),
  );
}
