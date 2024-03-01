import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/provider_manager.dart';
import 'package:whilabel/screens/archiving_post_detail/archiving_post_detail_view.dart';
import 'package:whilabel/app_root.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_view_model.dart';
import 'package:whilabel/screens/camera/page/chosen_image_page.dart';
import 'package:whilabel/screens/camera/page/gallery_page.dart';
import 'package:whilabel/screens/camera/page/search_whisky_name_page.dart';
import 'package:whilabel/screens/camera/page/take_picture_page.dart';
import 'package:whilabel/screens/camera/page/unregistered_whisky_page.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_recognition_page.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_scan_page.dart';
import 'package:whilabel/screens/login/login_view.dart';
import 'package:whilabel/screens/my_page/page/announcement_page.dart';
import 'package:whilabel/screens/my_page/page/f_a_q_page.dart';
import 'package:whilabel/screens/my_page/page/inquiring_page.dart';
import 'package:whilabel/screens/my_page/page/privacy_policy_page.dart';
import 'package:whilabel/screens/my_page/page/setting_page.dart';
import 'package:whilabel/screens/my_page/page/term_condition_service_page.dart';
import 'package:whilabel/screens/my_page/page/withdrawal_page.dart';
import 'package:whilabel/screens/onboarding/onboarding_step1.dart';
import 'package:whilabel/screens/user_additional_info/pages/rest_info_additional/rest_info_additional_page.dart';
import 'package:whilabel/screens/user_additional_info/pages/rest_info_additional/view_model/rest_info_additional_view_model.dart';
import 'package:whilabel/screens/user_additional_info/user_additional_info_view.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_view_model.dart';
import 'package:whilabel/screens/whisky_critique/pages/successful_upload_post_page.dart';
import 'package:whilabel/screens/whisky_critique/pages/unregistered_whisky_upload_page.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_view_model.dart';
import 'package:whilabel/screens/whisky_critique/whisky_critique_view.dart';

class _MyPageRoutes {
  final String myPageRoute = "/myPage";
  final String announcementRoute = "/myPage/announcement";
  final String faqRoute = "/myPage/Faq";
  final String inquiringRoute = "/myPage/inquiring";
  final String privacyPolicyRoute = "/myPage/privacyPolicy";
  final String settingRoute = "/myPage/setting";
  final String termConditionServiceRoute = "/myPage/termConditionService";
  final String withdrawalRoute = "/myPage/withdrawal";
}

class _CameraRoutes {
  final String cameraRoute = "/camera";
  final String chosenImageRoute = "/camera/chosenImage";
  final String galleryRoute = "/camera/gallery";
  final String searchWhiskyNameRoute = "/camera/searchWhiskyName";
  final String takePictureRoute = "/camera/takePicture";
  final String unregisteredWhiskyRoute = "/camera/unregisteredWhisky";
  final String whiskyBarcodeRecognition = "/camera/whiskyBarcodeRecognition";
  final String whiskyBarcodeScan = "/camera/whiskyBarcodeScan";
}

class _WhiskyCritiqueRoutes {
  final String whiskeyCritiqueRoute = "/whiskey_critique";
  final String successfulUploadPostRoute =
      "/whiskey_critique/successfulUploadPost";
  final String unregisteredWhiskyUploadPageRoute =
      "/whiskey_critique/unregisteredWhiskyUploadPage";
}

class Routes {
  static final myPageRoutes = _MyPageRoutes();
  static final cameraRoutes = _CameraRoutes();
  static final whiskyCritiqueRoutes = _WhiskyCritiqueRoutes();

  static const String rootRoute = "/";
  static const String loginRoute = "/login";
  static const String homeRoute = "/home";

  static const String archivingPostDetailRoute = "/whiskey_register";
  static const String userAdditionalInfoRoute = "/user_additional_info";
  static const String restInfoAdditionalRoute = "/user_additional_info/restInfoAdditional";
  static const String onBoardingRoute = "/on_boarding";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    final _whiskyBrandDistilleryRepository =
        ProvidersManager.whiskyBrandDistilleryRepository;
    final _archivingPostRepository = ProvidersManager.archivingPostRepository;
    final _appUserRepository = ProvidersManager.appUserRepository;
    final _whiskyNewArchivingPostUseCase =
        ProvidersManager.whiskeyNewArchivingPostUseCase;

    switch (routeSettings.name) {
      case Routes.rootRoute:
        final rootIndex = routeSettings.arguments as int?;
        return MaterialPageRoute(
            builder: (_) => AppRoot(screenIndex: rootIndex ?? 0));
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => LoginView());
      case Routes.archivingPostDetailRoute:
        final whiskyRegisterViewArgs = routeSettings.arguments as ArchivingPost;

        return MaterialPageRoute(
            builder: (_) =>
                ChangeNotifierProvider<ArchivingPostDetailViewModel>(
                  create: (_) => ArchivingPostDetailViewModel(
                      archivingPostRepository: _archivingPostRepository,
                      whiskyBrandDistilleryRepository:
                          _whiskyBrandDistilleryRepository),
                  child: ArchivingPostDetailView(
                      archivingPost: whiskyRegisterViewArgs),
                ));

      case Routes.userAdditionalInfoRoute:
        final nickName = routeSettings.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<UserAdditionalInfoViewModel>(
                create: (_) => UserAdditionalInfoViewModel(currentUserStatus: ProvidersManager.currentUserStatus, appUserRepository: _appUserRepository),
                child: UserAdditionalInfoView(nickName: nickName)));
      case Routes.restInfoAdditionalRoute:
        final nickName = routeSettings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider<RestInfoAdditionalViewModel>(
                create: (_) => RestInfoAdditionalViewModel(currentUserStatus: ProvidersManager.currentUserStatus, appUserRepository: _appUserRepository),
                child: RestInfoAdditionalPage(nickName: nickName)));
        case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingStep1Page());

      //  "/myPage"를 경로로 가지고 있을 경우
      case "/myPage/announcementPage":
        return MaterialPageRoute(builder: (_) => const AnnouncementPage());
      case "/myPage/faqPage":
        return MaterialPageRoute(builder: (_) => FaqPage());
      case "/myPage/inquiringPage":
        return MaterialPageRoute(builder: (_) => InquiringPage());
      case "/myPage/setting":
        return MaterialPageRoute(builder: (_) => SettingPage());
      case "/myPage/privacyPolicyPage":
        return MaterialPageRoute(builder: (_) => PrivacyPolicyPage());
      case "/myPage/termConditionServicePage":
        return MaterialPageRoute(builder: (_) => TermConditionServicePage());
      case "/myPage/withdrawalPage":
        return MaterialPageRoute(builder: (_) => WithdrawalPage());

      // "/camera"를 경로할 경우
      case "/camera":
        return MaterialPageRoute(builder: (_) => AppRoot(screenIndex: 1));
      case "/camera/chosenImage":
        final chosenImagePageArgs =
            routeSettings.arguments as ChosenImagePageArgs;
        return MaterialPageRoute(
            builder: (_) => ChosenImagePage(
                chosenImagePageArgs.initFileImage, chosenImagePageArgs.index,
                isFindingBarcode: chosenImagePageArgs.isFindingBarcode,
                isUnableSlide: chosenImagePageArgs.isUnableSlid));
      case "/camera/gallery":
        final _argument = routeSettings.arguments as bool;
        return MaterialPageRoute(
            builder: (_) => GalleryPage(isFindingBarcode: _argument));
      case "/camera/searchWhiskyName":
        return MaterialPageRoute(builder: (_) => SearchWhiskyNamePage());
      case "/camera/takePicture":
        final _cameraDescriptions =
            routeSettings.arguments as List<CameraDescription>;
        return MaterialPageRoute(
            builder: (_) => TakePicturePage(cameras: _cameraDescriptions));
      case "/camera/unregisteredWhisky":
        final _imageFile = routeSettings.arguments as File;
        return MaterialPageRoute(
            builder: (_) => UnregisteredWhiskyPage(imageFile: _imageFile));
      case "/camera/whiskyBarcodeRecognition":
        final _imageFile = routeSettings.arguments as File;
        return MaterialPageRoute(
            builder: (_) =>
                WhiskyBarcodeRecognitionPage(imageFile: _imageFile));
      case "/camera/whiskyBarcodeScan":
        final _cameraDescriptions =
            routeSettings.arguments as List<CameraDescription>;
        return MaterialPageRoute(
            builder: (_) =>
                WhiskyBarCodeScanPage(cameras: _cameraDescriptions));

//  "/whiskey_critique"를 경로로 가지는 경우

    // case Routes.whiskeyCritiqueRoute:

      case "/whiskey_critique":
      return MaterialPageRoute(builder: (_) => ChangeNotifierProvider<WhiskyCritiqueViewModel>(
create: (_)=>WhiskyCritiqueViewModel(appUserRepository: _appUserRepository, whiskyNewArchivingPostUseCase: _whiskyNewArchivingPostUseCase),
child: WhiskyCritiqueView()));
//         return MaterialPageRoute(builder: (_) => WhiskyCritiqueView());
      case "/whiskey_critique/successfulUploadPost":
        final _currentWhiskyCount = routeSettings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => SuccessfulUploadPostPage(
                currentWhiskyCount: _currentWhiskyCount));
      case "/whiskey_critique/unregisteredWhiskyUploadPage":
        final _currentWhiskyCount = routeSettings.arguments as int;
        return MaterialPageRoute(
            builder: (_) => UnregisteredWhiskyUploadPage(
                currentWhiskyCount: _currentWhiskyCount));

      // 경로가 없는 경우
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    const String noRouteFound = "페이지를 찾을 수 없습니다";
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

class ChosenImagePageArgs {
  final File initFileImage;
  final int index;
  bool? isFindingBarcode;
  bool? isUnableSlid;

  // 생성자
  ChosenImagePageArgs(
      {required this.initFileImage,
      required this.index,
      this.isFindingBarcode,
      this.isUnableSlid});
}

// return MaterialPageRoute(
// builder: (_) => ChangeNotifierProvider<ArchivingPostDetailViewModel>(
// create: (_)=> ArchivingPostDetailViewModel(archivingPostRepository: _archivingPostRepository, whiskyBrandDistilleryRepository:  _whiskyBrandDistilleryRepository),
// child: ArchivingPostDetailView(
// archivingPost: whiskyRegisterViewArgs,
// ),
// ));
// case Routes.whiskeyCritiqueRoute:
// return MaterialPageRoute(builder: (_) => ChangeNotifierProvider<WhiskyCritiqueViewModel>(
// create: (_)=>WhiskyCritiqueViewModel(appUserRepository: _appUserRepository, whiskyNewArchivingPostUseCase: _whiskyNewArchivingPostUseCase),
// child: WhiskyCritiqueView()));
