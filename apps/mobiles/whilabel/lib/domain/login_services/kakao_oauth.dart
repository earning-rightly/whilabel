import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:whilabel/data/user/auth_user.dart';
import 'package:whilabel/data/user/sns_type.dart';

class KaKaoOauth {
  Future<AuthUser?> login() async {
    AuthUser? loginedAuthUser;
    final bool isCheckLogin = await _isCheckLogin();
    if (isCheckLogin) {
      debugPrint("kakao login!!!!");

      final user = await UserApi.instance.me();
      try {
        loginedAuthUser = AuthUser(
            uid: user.id.toString(),
            displayName: user.kakaoAccount!.profile!.nickname.toString(),
            email: user.kakaoAccount!.email!,
            photoUrl: user.kakaoAccount!.profile!.profileImageUrl!,
            snsType: SnsType.KAKAO);
      } catch (erro) {
        debugPrint("$erro");
        ("firebase function 접근할 수 없습니다.");
        return null;
      }
    } else {
      debugPrint("isLogined ==== >>>> ture, kakao 로그인을 취소 했습니다");
      return null;
    }
    return loginedAuthUser;
  }

  Future<bool> logout() async {
    try {
      await UserApi.instance.unlink();
      return true;
    } catch (error) {
      debugPrint("kakao logout erro!!");
      debugPrint("$error");

      return false;
    }
  }

  Future<bool> _isCheckLogin() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        debugPrint("카카오톡 : 설치 O 상태");
        try {
          await UserApi.instance.loginWithKakaoTalk();
          debugPrint("카카오톡 로그인 : 성공");
          return true;
        } catch (error) {
          if (error is PlatformException && error.code == 'CANCELED') {
            debugPrint("사용자가 의도적으로 로그인 취소:\n $error");

            return false;
          }
          debugPrint("카카오톡 로그인 : 실패, 에러 메시지: $error");
          return false;
        }
      } else {
        debugPrint("카카오톡 : 설치 X 상태");
        try {
          await UserApi.instance.loginWithKakaoAccount();
          debugPrint("카카오 계정으로 로그인 : 성공");
          return true;
        } catch (error) {
          debugPrint("카카오 계정으로 로그인 : 실패, 에러 메시지 : $error");
          return false;
        }
      }
    } catch (error) {
      debugPrint("에러 발생, 에러 메시지 : $error");
      return false;
    }
  }
}
