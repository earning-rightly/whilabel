import 'package:flutter/painting.dart';

class ColorsManager {
  // Primary color
  static const Color white = Color(0xFFFFFFFF);
  static const Color brown100 = Color(0xFFAD643A);

  static const Color black100 = Color(0xFF141516);

  //Secondary
  static const Color red = Color(0xFFE64F45);

  static const Color orange = Color(0xFFE68245);
  static const Color yellow = Color(0xFFF5BA60);
  static const Color skin = Color(0xFFF0E2D1);
  static const Color sky = Color(0xFF97C5F3);

  // GrayScale
  static const Color black200 = Color(0xFF242526);
  static const Color black300 = Color(0xFF3B3E42);
  static const Color black400 = Color(0xFF585B5F);
  static const Color gray = Color(0xFFAAAAAA);
  static const Color gray200 = Color(0xFF888888);
  static const Color gray300 = Color(0xFFDDDDDD);
  static const Color gray400 = Color(0xFFEEEEEE);
  static const Color gray500 = Color(0xFFF5F5F5);

  // Gradient
  static const Color gradient1 = Color(0xFFF0E2D1);
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
