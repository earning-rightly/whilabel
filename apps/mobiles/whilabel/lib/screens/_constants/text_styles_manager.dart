import 'package:flutter/rendering.dart';

class TextStylesManager {
// bold style
  static TextStyle bold28 =
      TextStyle(fontSize: 28, fontWeight: FontWeight.bold);
  static TextStyle bold24 =
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  static TextStyle bold20 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static TextStyle bold18 =
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  static TextStyle bold16 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle bold14 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  static TextStyle bold12 =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  //regular
  static TextStyle regular24 =
      TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
  static TextStyle regular20 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w400);
  static TextStyle regular18 =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  static TextStyle regular16 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static TextStyle regular14 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static TextStyle regular12 =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

  //medium
  static TextStyle medium20 =
      TextStyle(fontSize: 20, fontWeight: FontWeight.w500);
  static TextStyle medium18 =
      TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
  static TextStyle medium16 =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static TextStyle medium14 =
      TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle medium12 =
      TextStyle(fontSize: 12, fontWeight: FontWeight.w500);

  final Map<String, TextStyle> _boldMap = {
    "B28": bold28,
    "B24": bold24,
    "B20": bold20,
    "B18": bold18,
    "B16": bold16,
    "B14": bold14,
    "B12": bold12,
  };

  final Map<String, TextStyle> _mediumMap = {
    "M20": medium20,
    "M18": medium18,
    "M16": medium16,
    "M14": medium14,
    "M12": medium12,
  };

  final Map<String, TextStyle> _regularMap = {
    "R24": regular24,
    "R20": regular20,
    "R18": regular18,
    "R16": regular16,
    "R14": regular14,
    "R12": regular12,
  };
  TextStyle? createHadColorTextStyle(String textStyle, Color color) {
    TextStyle? result;

    if (_boldMap[textStyle] != null) {
      result = _boldMap[textStyle];
      return result!.copyWith(color: color);
    }
    if (_mediumMap[textStyle] != null) {
      result = _mediumMap[textStyle];
      return result!.copyWith(color: color);
    }
    if (_regularMap[textStyle] != null) {
      result = _regularMap[textStyle];
      return result!.copyWith(color: color);
    }
    return null;
  }
}
