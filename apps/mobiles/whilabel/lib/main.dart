import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/firebase_options.dart';
import 'package:whilabel/provider_manager.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/themedata_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:whilabel/screens/_global/alim.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
  RemoteNotification? notification = message.notification;

  if (notification != null) {
    await FlutterLocalNotificationsPlugin().show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'high_importance_notification',
            importance: Importance.max,
            icon: "@mipmap/notification",
          ),
          iOS: DarwinNotificationDetails(badgeNumber: 1)),
    );
  }
  // });
}

void initializeNotification() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channel', 'high_importance_notification',
          importance: Importance.max));
  await flutterLocalNotificationsPlugin.initialize(const InitializationSettings(
    android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false),
  ));
}

void main() async {
  await dotenv.load(fileName: 'assets/config/.env');

  await Hive.initFlutter(); // * Hive 초기화
  KakaoSdk.init(nativeAppKey: dotenv.get("KAKAO_NATIVE_APP_KEY"));
  WidgetsFlutterBinding.ensureInitialized();

  // initializeNotification();
  FlutterLocalNotification.init();
  // 3초 후 권한 요청

  Future.delayed(const Duration(seconds: 3),
      FlutterLocalNotification.requestNotificationPermission());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  Future.delayed(const Duration(seconds: 2),(){
    FlutterNativeSplash.remove();

  });

  print('app start!');

  // 알림 권한 묻는 로직
  // 마이페이지에 알림 버튼을 누르면 허용창을 띄우는 것으로 변경
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }

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
