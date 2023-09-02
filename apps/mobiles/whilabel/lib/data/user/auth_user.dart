import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/user/sns_type.dart';

part 'auth_user.freezed.dart';
part 'auth_user.g.dart';

// applt 로그인에 들어가야 할 데이터를 잘 모른다.
@freezed
class AuthUser with _$AuthUser {
  factory AuthUser({
    required String uid,
    required String displayName,
    required String email,
    required String photoUrl,
    required SnsType snsType,
  }) = _AuthUser;
  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}
