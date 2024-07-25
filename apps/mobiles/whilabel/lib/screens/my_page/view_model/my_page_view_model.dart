import 'dart:developer';

import 'package:emailjs/emailjs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/repository/user/app_user_repository.dart';
import 'package:whilabel/domain/use_case/user_auth/withdraw_use_case.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_event.dart';

// todo AppUserRepository말고 다른 usecase로 로직을 변동하자
class MyPageViewModel with ChangeNotifier {
  final AppUserRepository _appUserRepository;
  final WithdrawUseCase _withdrawUseCase;

  MyPageViewModel({
    required AppUserRepository appUserRepository,
    required WithdrawUseCase withdrawUseCase,
  })  : _appUserRepository = appUserRepository,
        _withdrawUseCase = withdrawUseCase;

  Future<void> onEvent(MyPageEvent event, {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
          changePushAlimValue: changePushAlimValue,
          changeMarketingAlimValue: changeMarketingAlimValue,
          withdrawAccount: withdrawAccount,
          sendEmail: (String str) async {
            log("비이었는 함수 입니다");
          },
        )
        .then((_) => {after()});
  }

  Future<void> changePushAlimValue(String uid) async {
    AppUser? appUser = await _appUserRepository.getCurrentUser();

    final isGranted = await Permission.notification.isGranted;
    final newAppUser = appUser!.copyWith(isPushNotificationEnabled: isGranted);

    await _appUserRepository.updateUser(uid, newAppUser);
  }

  Future<void> changeMarketingAlimValue(String uid) async {
    AppUser? appUser = await _appUserRepository.getCurrentUser();
    print(appUser!.toJson());
    final isGranted = await Permission.notification.isGranted;

    if (isGranted) {
      final newAppUser = appUser.copyWith(
          isMarketingNotificationEnabled:
              !(appUser.isMarketingNotificationEnabled!));

      await _appUserRepository.updateUser(uid, newAppUser);
    }
  }

  Future<void> withdrawAccount(String uid, String nickName) async {
    _withdrawUseCase.call(uid, nickName);
  }

  // InquiringPage()가 stless이기 때문에 현재 event안에 넣지 않고 사용
  Future<bool> sendEmail({
    required String uid,
    required String userEmail,
    required String subject,
    required String message,
  }) async {
    final serviceId = dotenv.get("EMAIL_JS_SERVICE_ID");
    final templateId = dotenv.get("EMAIL_JS_TEMPLATE_ID");
    final publicKey = dotenv.get("EMAIL_JS_PUBLIC_KEY");
    final privateKey = dotenv.get("EMAIL_JS_PRIVATE_KEY");

    try {
      await EmailJS.send(
        serviceId,
        templateId,
        //  emailjs에 들어갈 정보
        {
          'subject': subject,
          'uid': uid,
          'user_email': userEmail,
          'message': message,
        },
        Options(
          publicKey: publicKey,
          privateKey: privateKey,
        ),
      );
      debugPrint('SUCCESS!');
      return true;
    } catch (error) {
      debugPrint('fail!!!');

      debugPrint(error.toString());
      return false;
    }
  }

  Future<void> delAnnouncement() async {
    AppUser? appUser = await _appUserRepository.getCurrentUser();

    if (appUser != null) {
      final newAppUser = appUser.copyWith(announcements: []);

      await _appUserRepository.updateUser(appUser.uid, newAppUser);
    }
  }
}
