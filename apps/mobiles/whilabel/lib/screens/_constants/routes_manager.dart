import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/screens/archiving_post_detail/archiving_post_detail_view.dart';
import 'package:whilabel/app_root.dart';
import 'package:whilabel/screens/login/login_view.dart';
import 'package:whilabel/screens/my_page/page/announcement_page.dart';
import 'package:whilabel/screens/my_page/page/f_a_q_page.dart';
import 'package:whilabel/screens/my_page/page/inquiring_page.dart';
import 'package:whilabel/screens/my_page/page/setting_page.dart';
import 'package:whilabel/screens/my_page/page/term_condition_service_page.dart';
import 'package:whilabel/screens/my_page/page/withdrawal_page.dart';
import 'package:whilabel/screens/onboarding/onboarding_step1.dart';
import 'package:whilabel/screens/user_additional_info/user_additional_info_view.dart';
import 'package:whilabel/screens/whisky_critique/whisky_critique_view.dart';

class MyPageRoutes {
  static const String announcementRoute = "announcementt";
  static const String faqRoute = "FAQ";
  static const String inquiringRoute = "inquiring";
  static const String privacyPolicyPage = "privacyPolicyPage";
  static const String settingRoute = "setting";
  static const String termConditionSerciceRoute = "termConditionService";
  static const String withdrawalRoute = "withdrawal";
}

class Routes {
  static const String rootRoute = "/root";
  static const String loginRoute = "/login";
  static const String archivingPostDetailRoute = "/whiskey_register";
  static const String whiskeyCritiqueRoute = "/whiskey_critque";
  static const String userAdditionalInfoRoute = "/user_additional_info";
  static const String onBoardingRoute = "/on_boarding";
  static const String announcementPageRoute = "my_page/announcement_page";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings,) {
    switch (routeSettings.name) {
      case Routes.rootRoute:
        final rootIndex = routeSettings.arguments as int?;
        return MaterialPageRoute(builder: (_) => AppRoot(
          screenIndex: rootIndex ?? 0,
        ));
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
      // case Routes.announcementPageRoute:
      //   return MaterialPageRoute(builder: (_) => const AnnouncementPage());

      // MyPage Route
      case MyPageRoutes.announcementRoute:
        return MaterialPageRoute(builder: (_) => const AnnouncementPage());
      case MyPageRoutes.faqRoute:
        return MaterialPageRoute(builder: (_) => FaqPage());
      case MyPageRoutes.inquiringRoute:
        return MaterialPageRoute(builder: (_) => InquiringPage());
      case MyPageRoutes.settingRoute:
        return MaterialPageRoute(builder: (_) => const SettingPage());
      case MyPageRoutes.termConditionSerciceRoute:
        return MaterialPageRoute(builder: (_) => TermConditionServicePage());
      case MyPageRoutes.withdrawalRoute:
        return MaterialPageRoute(builder: (_) => WithdrawalPage());

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
