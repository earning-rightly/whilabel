import 'package:emailjs/emailjs.dart';
import 'package:flutter/cupertino.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_event.dart';

class MyPageViewModel with ChangeNotifier {
  final AppUserRepository _appUserRepository;

  MyPageViewModel({
    required AppUserRepository appUserRepository,
  }) : _appUserRepository = appUserRepository;

  Future<void> onEvent(MyPageEvent event, {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
      changePushAlimValue: changePushAlimValue,
      changeMarketingAlimValue: changeMarketingAlimValue,
      withdrawAccount: withdrawAccount,
      sendEmail: changePushAlimValue,
    )
        .then((_) => {after()});
  }

  Future<void> changePushAlimValue(String uid) async {
    AppUser? appUser = await _appUserRepository.getCurrentUser();
    print(appUser!.toJson());

    final newAppUser = appUser.copyWith(
        isPushNotificationEnabled: !(appUser.isPushNotificationEnabled!));

    await _appUserRepository.updateUser(uid, newAppUser);
  }

  Future<void> changeMarketingAlimValue(String uid) async {
    AppUser? appUser = await _appUserRepository.getCurrentUser();
    print(appUser!.toJson());

    final newAppUser = appUser.copyWith(
        isMarketingNotificationEnabled:
        !(appUser.isMarketingNotificationEnabled!));

    await _appUserRepository.updateUser(uid, newAppUser);
  }

  Future<void> withdrawAccount(String uid) async {
    AppUser? appUser = await _appUserRepository.getCurrentUser();
    print(appUser!.toJson());

    final newAppUser = appUser.copyWith(isDeleted: true);

    await _appUserRepository.updateUser(uid, newAppUser);
  }

  // InquiringPage()가 stless이기 때문에 현재 event안에 넣지 않고 사용
  Future<bool> sendEmail({
    required String uid,
    required String userEmail,
    required String subject,
    required String message,
  }) async {
    final serviceId = "service_3adi8hl";
    final templateId = "template_my18n2o";
    final publicKey = "_Qt-1oUmn42sVZh02";
    final privateKey = "x29hnJw91Yh5FnQi5EEyA";

    try {
      await EmailJS.send(
        serviceId,
        templateId,
        //  emailjs에 들어갈 정보
        {
          'subject': subject,
          'name': uid,
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
