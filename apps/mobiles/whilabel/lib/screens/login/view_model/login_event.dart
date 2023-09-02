import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/user/sns_type.dart';

part 'login_event.freezed.dart';

@freezed
abstract class LoginEvent with _$LoginEvent {
  const factory LoginEvent.login(SnsType snsType) = Login;
  const factory LoginEvent.logout(SnsType snsType) = Logout;
}
