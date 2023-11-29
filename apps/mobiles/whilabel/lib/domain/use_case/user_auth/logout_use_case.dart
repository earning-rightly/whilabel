// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/login_services/apple_oauth.dart';
import 'package:whilabel/domain/login_services/googel_oauth.dart';
import 'package:whilabel/domain/login_services/kakao_oauth.dart';

class LogoutUseCase {
  CurrentUserStatus currentUserStatus;

  LogoutUseCase({
    required this.currentUserStatus,
  });

  Future<bool> call(SnsType snsType) async {
    // 로그인한 플랫폼마다 로그아웃 방식을 다르게 설정
    switch (snsType) {
      case SnsType.KAKAO:
        await KaKaoOauth().logout();
        debugPrint("kakao logout");
        break;

      case SnsType.GOOGLE:
        await GoogleOauth().logout();
        debugPrint("google logout");
        break;

      case SnsType.APPLE:
        await AppleOauth().logout();
        debugPrint("apple logout");
        break;

      default:
        debugPrint("instatgram 과 카카오는 로그아웃 방식이 다릅니다.");
        break;
    }
    await FirebaseAuth.instance.signOut();
    await const FlutterSecureStorage().deleteAll();
    await currentUserStatus.updateUserState();

    return true;
  }
}
