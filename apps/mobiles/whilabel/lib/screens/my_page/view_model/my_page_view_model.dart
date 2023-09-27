import 'package:emailjs/emailjs.dart';
import 'package:flutter/cupertino.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_event.dart';

class MyPageViewModel with ChangeNotifier {
  final CurrentUserStatus _currentUserStatus;
  final AppUserRepository _appUserRepository;
  final LogoutUseCase _logoutUseCase;
  MyPageViewModel({
    required CurrentUserStatus currentUserStatus,
    required AppUserRepository appUserRepository,
    required LogoutUseCase logoutUseCase,
  })  : _currentUserStatus = currentUserStatus,
        _appUserRepository = appUserRepository,
        _logoutUseCase = logoutUseCase;

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
    await _currentUserStatus.updateUserState();
  }

  Future<void> changeMarketingAlimValue(String uid) async {
    AppUser? appUser = await _appUserRepository.getCurrentUser();
    print(appUser!.toJson());

    final newAppUser = appUser.copyWith(
        isMarketingNotificationEnabled:
            !(appUser.isMarketingNotificationEnabled!));
    // appUser
    await _appUserRepository.updateUser(uid, newAppUser);
    await _currentUserStatus.updateUserState();
  }

  Future<void> withdrawAccount(String uid) async {
    AppUser? appUser = await _appUserRepository.getCurrentUser();
    print(appUser!.toJson());

    final newAppUser = appUser.copyWith(isDeleted: true);

    await _appUserRepository.updateUser(uid, newAppUser);
    await _currentUserStatus.updateUserState();
  }

  Future<bool> sendEmail({
    required String userEmail,
    required String subject,
    required String message,
  }) async {
    final serviceId = "service_3adi8hl";
    final templateId = "template_my18n2o";
    final publicKey = "_Qt-1oUmn42sVZh02";
    final privateKey = "x29hnJw91Yh5FnQi5EEyA";
    final appUser = await _currentUserStatus.getAppUser();

    try {
      await EmailJS.send(
        serviceId,
        templateId,
        // templateParams,
        {
          'subject': subject,
          'name': "${appUser!.nickName}/${appUser.uid}",
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
}
