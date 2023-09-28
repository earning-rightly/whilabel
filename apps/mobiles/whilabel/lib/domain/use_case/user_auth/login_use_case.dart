import 'package:dartx/dartx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/data/user/auth_user.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/data/user/vaild_account.dart';
import 'package:whilabel/domain/functions/create_firebase_token.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/login_services/googel_oauth.dart';
import 'package:whilabel/domain/login_services/instargram_oauth.dart';
import 'package:whilabel/domain/login_services/kakao_oauth.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';

class LoginUseCase {
  AuthUser? _loginUserInfo;

  final CurrentUserStatus currentUserStatus;
  final AppUserRepository appUserRepository;

  LoginUseCase({
    required this.currentUserStatus,
    required this.appUserRepository,
  });

  Future<VaildAccount> call(SnsType snsType) async {
    switch (snsType) {
      case SnsType.KAKAO:
        final kakaoLoginedUserInfo = await KaKaoOauth().login();
        if (kakaoLoginedUserInfo != null) _loginUserInfo = kakaoLoginedUserInfo;

        break;

      case SnsType.INSTAGRAM:
        final instargramLoginedUserInfo = await InstargramOauth().login();
        if (instargramLoginedUserInfo != null)
          _loginUserInfo = instargramLoginedUserInfo;

        break;

      case SnsType.GOOGLE:
        final googleLoginedUserInfo = await GoogleOauth().login();
        if (googleLoginedUserInfo != null)
          _loginUserInfo = googleLoginedUserInfo;

        break;

      default:
        debugPrint("snsType 값을 찾을 수 없습니다.");
        // return Pair(false, false);
        return VaildAccount(isDelted: false, isLogined: false, isNewbie: false);
    }

    if (_loginUserInfo == null)
      return VaildAccount(isDelted: false, isLogined: false, isNewbie: false);
    // return Pair(false, false);

    final isDeleted = await _customTokenLoginService(_loginUserInfo!);

    currentUserStatus.updateUserState();
    bool isNewbie = await _isNewbie();

    // return Pair(true, isNewbie);
    return VaildAccount(
        isDelted: isDeleted ?? false, isLogined: true, isNewbie: isNewbie);
  }

  Future<bool> _isNewbie() async {
    final currentUser = await appUserRepository.getCurrentUser();

    if (currentUser != null && (currentUser.name.isNotNullOrEmpty)) {
      debugPrint("current user is not new  ");
      return false;
    }
    debugPrint("current user is new!!  ");

    return true;
  }

  Future<bool?> _customTokenLoginService(AuthUser authUser) async {
    if (authUser.uid == "") return null;
    try {
      // 다른 플랫폼 정보릁 토대로 firebase토큰 생성
      final token = await createFirebaseToken(authUser);

      // firebase function에서 발급 받은 토큰으로 현재 유저 로그인
      await FirebaseAuth.instance.signInWithCustomToken(token);

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        debugPrint("error!! 파이어 베이스 로그인 에러");

        return null;
      }
      final isExisted = await appUserRepository.findUser(currentUser.uid);

      if (isExisted == null) {
        await appUserRepository.insertUser(
          AppUser(
              uid: currentUser.uid,
              email: authUser.email,
              isPushNotificationEnabled: false,
              isMarketingNotificationEnabled: true,
              isDeleted: false,
              nickName: authUser.displayName,
              snsType: authUser.snsType,
              snsUserInfo: {}),
        );
      } else if (isExisted.isDeleted!) {
        print("삭제요청을 한 계정입니다.");
        // FirebaseAuth.instance.signInWithCustomToken()에서 로그인되 계정 로그아웃
        await LogoutUseCase(currentUserStatus: currentUserStatus)
            .call(isExisted.snsType);

        return true;
      }
    } catch (e) {
      e.printError;
      debugPrint("firebase function 접근할 수 없습니다.");
    }
    return false;
  }
}
