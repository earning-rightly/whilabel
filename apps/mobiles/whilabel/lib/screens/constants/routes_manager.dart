import 'package:flutter/material.dart';
import 'package:whilabel/screens/home/home_view.dart';
import 'package:whilabel/screens/login/login_view.dart';
import 'package:whilabel/screens/onboarding/onboarding_step1.dart';
import 'package:whilabel/screens/user_additional_info/user_additional_info_view.dart';
import 'package:whilabel/screens/whisky_register/whisky_register_view.dart';
import 'package:whilabel/screens/whisky_critique/whisky_critique_view.dart';

class Routes {
  static const String cameraRoute = "/carmera";
  static const String homeRoute = "/home";
  static const String loginRoute = "/login";
  static const String whiskeyRegisterRoute = "/whiskey_register";
  static const String whiskeyCritiqueRoute = "/whiskey_critque";
  static const String userAdditionalInfoRoute = "/user_additional_info";
  static const String onBoardingRoute = "/on_boarding";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginView());
      case Routes.whiskeyRegisterRoute:
        return MaterialPageRoute(builder: (_) => WhiskyRegisterView());
      case Routes.whiskeyCritiqueRoute:
        return MaterialPageRoute(builder: (_) => WhiskyCritiqueView());
      case Routes.userAdditionalInfoRoute:
        return MaterialPageRoute(
            builder: (_) => const UserAdditionalInfoView());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingStep1Page());
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
