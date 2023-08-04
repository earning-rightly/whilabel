import 'package:flutter/material.dart';
import 'package:whilabel/screens/home/home_view.dart';
import 'package:whilabel/screens/whiskey_critique/whiskey_critique_view.dart';
import 'package:whilabel/screens/whiskey_register/whiskey_register_view.dart';

class Routes {
  static const String cameraRoute = "/carmera";
  static const String homeRoute = "/home";
  // TODO - Add views related with mycare service.
  static const String WhiskeyRegisterRoute = "/whiskey_register";
  static const String WhiskeyCritiqueRoute = "/whiskey_critque";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());

      case Routes.WhiskeyRegisterRoute:
        return MaterialPageRoute(builder: (_) => const WhiskeyRegisterView());
      case Routes.WhiskeyCritiqueRoute:
        return MaterialPageRoute(builder: (_) => const WhiskeyCritiqueView());

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    const String noRouteFound = "페이지를 찾을 수  없습니다";
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(noRouteFound),
        ),
        body: const Center(
          child: Text(noRouteFound),
        ),
      ),
    );
  }
}
