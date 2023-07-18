import 'package:flutter/material.dart';
import 'package:whilabel/presentation/home/home_view.dart';
import 'package:whilabel/presentation/carmera/camera_view.dart';

class Routes {
  static const String cameraRoute = "/carmera";
  static const String homeRoute = "/home";

  // TODO - Add views related with mycare service.
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => HomeView());

      case Routes.cameraRoute:
        return MaterialPageRoute(builder: (_) => CameraView());

      default:
        return unDefinedRoute();
      // return MaterialPageRoute(builder: (_) => TestOnBoardingView());
    }
  }

  static Route<dynamic> unDefinedRoute() {
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
