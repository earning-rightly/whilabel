import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/user/app_user.dart';

part 'user_additional_info_event.freezed.dart';

@freezed
abstract class UserAdditionalInfoEvent with _$UserAdditionalInfoEvent {
  const factory UserAdditionalInfoEvent.addUserInfo(AppUser appUser) =
      AddUserInfo;
  const factory UserAdditionalInfoEvent.checkNickName(String nickName) =
      CheckNickName;
}
