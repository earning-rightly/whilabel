import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/user/app_user.dart';

part 'user_info_additional_event.freezed.dart';

@freezed
abstract class UserInfoAdditionalEvent with _$UserInfoAdditionalEvent {
  const factory UserInfoAdditionalEvent.addUserInfo(AppUser appUser) =
      AddUserInfo;
  const factory UserInfoAdditionalEvent.checkNickName(String nickName) =
      CheckNickName;
}
