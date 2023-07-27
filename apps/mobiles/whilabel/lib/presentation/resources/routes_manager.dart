import 'package:flutter/material.dart';
import 'package:whilabel/presentation/home/home_view.dart';
import 'package:whilabel/presentation/carmera/camera_view.dart';
import 'package:whilabel/presentation/recognition_success/recognition_success_view.dart';

class Routes {
  static const String cameraRoute = "/carmera";
  static const String homeRoute = "/home";
  static const String recongnitionSuccessRoute = "/RecongnitionSuccess";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());

      case Routes.cameraRoute:
        return MaterialPageRoute(builder: (_) => const CameraView());

      case Routes.recongnitionSuccessRoute:
        return MaterialPageRoute(
            builder: (_) => const RecongnitionSuccessView());

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
