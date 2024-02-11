import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartx/dartx.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/data/user/auth_user.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/functions/create_firebase_token.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/login_services/apple_oauth.dart';
import 'package:whilabel/domain/login_services/googel_oauth.dart';
import 'package:whilabel/domain/login_services/instargram_oauth.dart';
import 'package:whilabel/domain/login_services/kakao_oauth.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';

class LoginUseCase {
  final CurrentUserStatus _currentUserStatus;
  final AppUserRepository _appUserRepository;

  LoginUseCase({
    required  currentUserStatus,
    required AppUserRepository appUserRepository,
  })  : _currentUserStatus = currentUserStatus,
        _appUserRepository = appUserRepository;

  Future<UserState> login(SnsType snsType) async {
    try {
      AuthUser? authUser = await _snsLogin(snsType);

      if (authUser == null) {
        debugPrint("User Cancel login");
        FirebaseAuth.instance.signOut();
        return UserState.loginCanceled;
      }

      User? firebaseUser = await _signInFirebase(authUser);

      if (firebaseUser == null) {
        throw Exception("Firebase Auth Failed");
      }

      final AppUser? existUser = await _findUserWithFirebaseUserId(firebaseUser.uid);

      // 삭제된 유저도 초기화로 처리함
      if (existUser == null || existUser.isDeleted == true) {
        String? _fcmToken = await FirebaseMessaging.instance.getToken();
        final timestampNow = Timestamp.now();
        _currentUserStatus.setState(
          AppUser(
            firebaseUserId: firebaseUser.uid,
            uid: "${firebaseUser.uid}+${timestampNow.microsecondsSinceEpoch}",
            email: authUser.email,
            creatAt: timestampNow,
            fcmToken: _fcmToken,
            isPushNotificationEnabled: false,
            isMarketingNotificationEnabled: true,
            isDeleted: false,
            nickName: authUser.displayName,
            snsType: authUser.snsType,
            snsUserInfo: {}),
          UserState.initial
        );
        return UserState.initial;
      } else {
        if (existUser.fcmToken.isNullOrEmpty){
          await _addFcmTokenOnDB(existUser);
          final user = await _findUserWithFirebaseUserId(existUser.uid);
          _currentUserStatus.setState(user, UserState.login);
          return UserState.login;
        }
        _currentUserStatus.setState(existUser, UserState.login);
        return UserState.login;
      }
    } catch (e) {
      await LogoutUseCase(currentUserStatus: _currentUserStatus, appUserRepository: _appUserRepository).call(snsType);
      debugPrint("Fail to Login with ${snsType.name}: $e");
      return UserState.loginFail;
    }
  }

  Future<User?> _signInFirebase(AuthUser authUser) async {
    if (authUser.uid == "") return null;

    // 다른 플랫폼 정보릁 토대로 firebase토큰 생성
    final token = await createFirebaseToken(authUser);

    if (token == null) return null;

    await FirebaseAuth.instance.signInWithCustomToken(token);

    return FirebaseAuth.instance.currentUser;
  }

  Future<AppUser?> _findUserWithFirebaseUserId(String firebaseUserId) async {
    return await _appUserRepository.findUserWithFirebaseUserId(firebaseUserId);
  }

  Future<AuthUser?> _snsLogin(SnsType snsType) async {
    return switch (snsType) {
      SnsType.KAKAO => await KaKaoOauth().login(),
      SnsType.INSTAGRAM => await InstargramOauth().login(),
      SnsType.GOOGLE => await GoogleOauth().login(),
      SnsType.APPLE => await AppleOauth().login(),
      _ => null
    };
  }
  Future<AppUser>_addFcmTokenOnDB(AppUser _user) async{
    String? _fcmToken = await FirebaseMessaging.instance.getToken();
    final user = _user.copyWith(fcmToken: _fcmToken );
    await _appUserRepository.insertUser(user);

    return user;
  }
}
