// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/login_services/googel_oauth.dart';
import 'package:whilabel/domain/login_services/kakao_oauth.dart';
import 'package:whilabel/domain/share_provider/current_user_state.dart';

class LogoutUseCase {
  CurrentUserStatus currentUserStatus;

  LogoutUseCase({
    required this.currentUserStatus,
  });

  Future<bool> call(SnsType snsType) async {
    if (currentUserStatus.userState != UserState.login) {
      debugPrint("정상 로그아웃 실패, 로그인 상태는 유지됨...");
      return false;
    }
    switch (snsType) {
      case SnsType.KAKAO:
        await KaKaoOauth().logout();

        break;
      case SnsType.GOOGLE:
        await GoogleOauth().logout();

        break;
      default:
        debugPrint("instatgram 과 카카오는 로그아웃 방식이 다릅니다.");

        break;
    }

    await FirebaseAuth.instance.signOut();
    currentUserStatus.updateUserState();

    return true;
  }
}
