import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_additional_state.freezed.dart';

@freezed
class UserInfoAdditionalState with _$UserInfoAdditionalState {
  factory UserInfoAdditionalState({
    required bool isAbleNickName,
    required String forbiddenWord,
  }) = _UserInfoAdditionalState;
}
