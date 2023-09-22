import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';

final ThemeData whilabelTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: ColorsManager.black100, // Your accent color
  ),
  fontFamily: 'Pretendard',
  scaffoldBackgroundColor: ColorsManager.black100,
  appBarTheme: AppBarTheme(backgroundColor: ColorsManager.black100),
  bannerTheme: const MaterialBannerThemeData(backgroundColor: Colors.grey),
  textTheme: const TextTheme(
    bodyLarge:
        TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.red),
    bodyMedium: TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        color: Colors.white),
    bodySmall: TextStyle(fontSize: 14),
    headlineMedium: TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  ),
);
