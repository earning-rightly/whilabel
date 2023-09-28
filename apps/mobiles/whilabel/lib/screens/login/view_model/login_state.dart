import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  factory LoginState({
    required bool isLogined,
    required bool isDeleted,
    required UserState userState,
  }) = _LoginState;
}
