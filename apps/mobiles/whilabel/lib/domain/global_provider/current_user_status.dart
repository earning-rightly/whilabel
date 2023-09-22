import 'package:flutter/material.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_user_status.freezed.dart';

enum UserState {
  initial, // 유저 추가 정보를 입력 x
  notLogin, // 로그인 X 사용자
  login, // 로그인 O 사용자
}

@freezed
class CurrentUserState with _$CurrentUserState {
  factory CurrentUserState(
      {required AppUser appUser,
      required UserState userState}) = _CurrentUserState;
}

class CurrentUserStatus extends ChangeNotifier {
  final AppUserRepository _repository;

  late CurrentUserState _state = CurrentUserState(
      userState: UserState.initial,
      appUser: AppUser(
          uid: "",
          nickname: "",
          snsUserInfo: {},
          snsType: SnsType.EMPTY,
          isDeleted: false,
          allowNotification: false));
  CurrentUserState get state => _state;

  CurrentUserStatus(this._repository) {
    updateUserState();
  }

  Future<AppUser?> getAppUser() async {
    AppUser? result = await _repository.getCurrentUser();
    print("getAppUser => ${result?.toJson()}");
    if (result != null) {
      _state = _state.copyWith(appUser: result);
      notifyListeners();
    }
    print("Future<AppUser?> getAppUser() ====> ${result?.toJson()}");
    return result;
  }

  Future<void> updateUserState() async {
    final appUser = await _repository.getCurrentUser();
    if (appUser == null) {
      _state = _state.copyWith(userState: UserState.notLogin);
      print("----- userState----\n ===>>>>>>  notLogin");
    } else if (appUser.nickname == "") {
      print("----- userState----\n ===>>>>>>  inital");

      _state = _state.copyWith(userState: UserState.initial);
    } else {
      print("----- userState----\n ===>>>>>>  login");

      _state = _state.copyWith(userState: UserState.login);
    }

    notifyListeners();
  }
}
