import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:whilabel/data/user/auth_user.dart';
import 'package:whilabel/data/user/sns_type.dart';

/// apple oauth과 관련되 기능을 정의한 class입니다.
/// author: hihibara
class AppleOauth {
  /// apple간편 로그인 함수 입니다.
  /// (author: hihibara)
  ///
  /// 매개변수 X, 로그인한 플랫폼 유저의 정보를 return 합니다.
  Future<AuthUser?> login() async {
    AuthUser? loginedAuthUser;
    // 1. 애플 로그인이 이용 가능한지 체크함.
    if (await TheAppleSignIn.isAvailable()) {
      // 2. 로그인 수행(FaceId 또는 Password 입력)
      final AuthorizationResult result = await TheAppleSignIn.performRequests([
        const AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      // 3. 로그인 권한 여부 체크
      switch (result.status) {
        // 3-1. 로그인 권한을 부여받은 경우
        case AuthorizationStatus.authorized:
          debugPrint(
              '로그인 결과 : ${result.credential?.fullName}\n ${result.credential?.email} \n 유저:${result.credential?.user.toString()} ');

          loginedAuthUser = AuthUser(
            uid: result.credential!.user.toString() ,
            // 사용자 이름도 마찬가지
            displayName:
                result.credential?.fullName?.middleName ?? "애플로그인",
            // email은 필수 항목이 아니라서 null able로 되어 있다.
            email:"${result.credential!.user}@gmail.com" ,// 이메일이 중복되면 로그인 불가는 하기에 uid 이용
            photoUrl: "",
            snsType: SnsType.APPLE,
          );

          break;
        // 3-2. 오류가 발생한 경우
        case AuthorizationStatus.error:
          debugPrint('애플 로그인 오류 : ${result.error!.localizedDescription}');
          break;
        // 3-3. 유저가 직접 취소한 경우
        case AuthorizationStatus.cancelled:
          debugPrint("취소!!!");
          break;
      }
      debugPrint("${loginedAuthUser?.toJson()}");
    } else {
      debugPrint('애플 로그인을 지원하지 않는 기기입니다.');
    }
    return loginedAuthUser;
  }

   logout() async{
    await const FlutterSecureStorage().deleteAll();

  }
}
