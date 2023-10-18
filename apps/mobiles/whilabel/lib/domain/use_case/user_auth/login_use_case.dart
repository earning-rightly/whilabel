import 'package:dartx/dartx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/data/user/auth_user.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/data/user/account_state.dart';
import 'package:whilabel/domain/functions/create_firebase_token.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/login_services/googel_oauth.dart';
import 'package:whilabel/domain/login_services/instargram_oauth.dart';
import 'package:whilabel/domain/login_services/kakao_oauth.dart';
import 'package:whilabel/domain/use_case/short_archiving_post_use_case.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';

class LoginUseCase {
  AuthUser? _loginUserInfo;

  final CurrentUserStatus _currentUserStatus;
  final AppUserRepository _appUserRepository;
  final ShortArchivingPostUseCase _sameKindWhiskyUseCase;

  LoginUseCase({
    required CurrentUserStatus currentUserStatus,
    required AppUserRepository appUserRepository,
    required ShortArchivingPostUseCase shortArchivingPostUseCase,
  })  : _currentUserStatus = currentUserStatus,
        _appUserRepository = appUserRepository,
        _sameKindWhiskyUseCase = shortArchivingPostUseCase;

  Future<AccountState?> call(SnsType snsType) async {
    _loginUserInfo = switch (snsType) {
      SnsType.KAKAO => await KaKaoOauth().login(),
      SnsType.INSTAGRAM => await InstargramOauth().login(),
      SnsType.GOOGLE => await GoogleOauth().login(),
      _ => null
    };

    if (_loginUserInfo == null) {
      debugPrint("fail with login as $snsType");
      // return null state for error handling
      return null;
    }

    // TODO: isDeleted 를 확실히 구해올 수 있도록 수정
    final isDeleted = await _customTokenLoginService(_loginUserInfo!);

    _currentUserStatus.updateUserState();
    bool isNewbie = await _isNewbie();

    // return Pair(true, isNewbie);
    return AccountState(
        isDeleted: isDeleted ?? false, isLogined: true, isNewbie: isNewbie);
  }

  Future<bool> _isNewbie() async {
    final currentUser = await _appUserRepository.getCurrentUser();

    if (currentUser != null && (currentUser.name.isNotNullOrEmpty)) {
      debugPrint("current user is not new  ");
      return false;
    }
    debugPrint("current user is new!!  ");

    return true;
  }

  Future<User?> _getFirebaseUser(AuthUser authUser) async {
    if (authUser.uid == "") return null;
    try {
      // 다른 플랫폼 정보릁 토대로 firebase토큰 생성
      final token = await createFirebaseToken(authUser);

      if (token == null) return null;

      await FirebaseAuth.instance.signInWithCustomToken(token);
    } catch (e) {
      debugPrint("Firebase Auth Error: $e");
      return null;
    }
    return FirebaseAuth.instance.currentUser;
  }

  Future<bool?> _customTokenLoginService(AuthUser authUser) async {
    try {
      User? firebaseUser = await _getFirebaseUser(authUser);

      // login 실패 시 초기화 필요
      if (firebaseUser == null) {
        FirebaseAuth.instance.signOut();
        return null;
      }

      final AppUser? user = await _appUserRepository.findUser(firebaseUser.uid);

      // isNewbie
      if (user == null) {
        await _appUserRepository.insertUser(
          AppUser(
              uid: firebaseUser.uid,
              email: authUser.email,
              isPushNotificationEnabled: false,
              isMarketingNotificationEnabled: true,
              isDeleted: false,
              nickName: authUser.displayName,
              snsType: authUser.snsType,
              snsUserInfo: {}),
        );
        _sameKindWhiskyUseCase.creatSameKindWhiskyDoc(userId: firebaseUser.uid);
      } else if (user.isDeleted!) {
        print("삭제요청을 한 계정입니다.");
        // FirebaseAuth.instance.signInWithCustomToken()에서 로그인되 계정 로그아웃
        await LogoutUseCase(currentUserStatus: _currentUserStatus)
            .call(user.snsType);

        return true;
      }
    } catch (e) {
      e.printError;
      debugPrint("firebase function 접근할 수 없습니다.");
    }
    return false;
  }
}
