import 'package:flutter/painting.dart';

class ColorsManager {
  // Primary color
  static Color white = HexColor.fromHex("FFFFFF");
  static Color brown100 = HexColor.fromHex("AD643A");
  static Color black100 = HexColor.fromHex("141516");

  //Secondary
  static Color red = HexColor.fromHex("E64F45");
  static Color orange = HexColor.fromHex("E68245");
  static Color yellow = HexColor.fromHex("F5BA60");
  static Color skin = HexColor.fromHex("F0E2D1");
  static Color sky = HexColor.fromHex("97C5F3");

  // GrayScale
  static Color black200 = HexColor.fromHex("242526");
  static Color black300 = HexColor.fromHex("3B3E42");
  static Color black400 = HexColor.fromHex("585B5F");
  static Color gray = HexColor.fromHex("AAAAAA");
  static Color gray200 = HexColor.fromHex("888888");
  static Color gray300 = HexColor.fromHex("DDDDDD");
  static Color gray400 = HexColor.fromHex("EEEEEE");
  static Color gray500 = HexColor.fromHex("F5F5F5");

  // Gradient
  static Color gradient1 = HexColor.fromHex("F0E2D1");
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString; // 8 char with opacity 100%
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}
