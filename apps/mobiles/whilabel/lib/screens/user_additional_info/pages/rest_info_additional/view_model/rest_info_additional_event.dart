import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/user/app_user.dart';

part 'rest_info_additional_event.freezed.dart';

@freezed
abstract class RestInfoAdditionalEvent with _$RestInfoAdditionalEvent {
  const factory RestInfoAdditionalEvent.addUserInfo(AppUser appUser) =
  AddUserInfo;

}
