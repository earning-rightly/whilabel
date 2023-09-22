import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/screens/archiving_post_detail/archiving_post_detail_view.dart';
import 'package:whilabel/app_root.dart';
import 'package:whilabel/screens/login/login_view.dart';
import 'package:whilabel/screens/onboarding/onboarding_step1.dart';
import 'package:whilabel/screens/user_additional_info/user_additional_info_view.dart';
import 'package:whilabel/screens/whisky_critique/whisky_critique_view.dart';

class Routes {
  static const String cameraRoute = "/carmera";
  static const String rootRoute = "/root";
  static const String loginRoute = "/login";
  static const String archivingPostDetailRoute = "/whiskey_register";
  static const String whiskeyCritiqueRoute = "/whiskey_critque";
  static const String userAdditionalInfoRoute = "/user_additional_info";
  static const String onBoardingRoute = "/on_boarding";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.rootRoute:
        return MaterialPageRoute(builder: (_) => const AppRoot());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginView());
      case Routes.archivingPostDetailRoute:
        final whiskyRegisterViewArgs = routeSettings.arguments as ArchivingPost;

        return MaterialPageRoute(
            builder: (_) => ArchivingPostDetailView(
                  archivingPost: whiskyRegisterViewArgs,
                ));
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
