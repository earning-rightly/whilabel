import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_additional_info_state.freezed.dart';

@freezed
class UserAdditionalInfoState with _$UserAdditionalInfoState {
  factory UserAdditionalInfoState({
    required bool isAbleNickName,
    required String forbiddenWord,
  }) = _UserAdditionalInfoState;
}
