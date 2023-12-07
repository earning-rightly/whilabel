import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/firebase_options.dart';
import 'package:whilabel/provider_manager.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/themedata_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');

  await Hive.initFlutter(); // * Hive 초기화
  KakaoSdk.init(nativeAppKey: dotenv.get("KAKAO_NATIVE_APP_KEY"));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(seconds: 1));

  print('app start!');
  FlutterNativeSplash.remove();

  runApp(
    MultiProvider(
      providers: ProvidersManager.initialProviders(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp._internal();
  static final MainApp instance = MainApp._internal();
  factory MainApp() => instance; // to guarantee Sigleton

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),

      child: MaterialApp(
        theme: whilabelTheme,
        debugShowCheckedModeBanner: false,
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.rootRoute,
        builder: EasyLoading.init(),
      ),
    );
  }

  // void _removeSplash() async {
  //   print('ready in 3...');
  //   await Future.delayed(const Duration(seconds: 1));
  //   print('ready in 2...');
  //   await Future.delayed(const Duration(seconds: 1));
  //   print('ready in 1...');
  //   await Future.delayed(const Duration(seconds: 1));
  //   print('go!');
  //   FlutterNativeSplash.remove();
  // }
}
