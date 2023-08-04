import 'package:flutter/material.dart';
import 'package:whilabel/screens/constants/routes_manager.dart';
import 'package:whilabel/screens/constants/themedata_manager.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: whilabelTheme,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.homeRoute,
    );
  }
}
