// 각각의 view 사용될 TextField에 디자인을 return 하는 함수를 모아둔 파일일입니다.
// TextFormField와 TextField 에서 사용 가능합니다.
import 'package:flutter/material.dart';

// whiskey_register에서 사용
InputDecoration makeWhiskeyRegisterTextFieldStyle(
  String hinText,
  bool disable,
) {
  return InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ),
    ),
    contentPadding: EdgeInsets.only(left: 10, right: 10),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2),
    ),
    hintText: hinText,
    fillColor: Colors.grey,
    filled: true,
  );
}
