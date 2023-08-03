import 'package:flutter/material.dart';

import 'package:whilabel/presentation/resources/routes_manager.dart';
import 'package:whilabel/presentation/resources/themedata_manager.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: whilabelThemeData,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.homeRoute,
    );
  }
}
