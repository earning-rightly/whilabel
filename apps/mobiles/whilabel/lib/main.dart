import 'package:flutter/material.dart';

import 'package:whilabel/presentation/resources/routes_manager.dart';

void main() {
  runApp(const Whilabel());
}

class Whilabel extends StatelessWidget {
  const Whilabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.homeRoute,
    );
  }
}
