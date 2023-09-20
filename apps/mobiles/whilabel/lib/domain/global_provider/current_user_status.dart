import 'package:flutter/material.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';

enum UserState {
  initial, // 유저 추가 정보를 입력 x
  notLogin, // 로그인 X 사용자
  login, // 로그인 O 사용자
}

class CurrentUserStatus extends ChangeNotifier {
  final AppUserRepository _repository;

  UserState _userState = UserState.initial;
  UserState get userState => _userState;

  CurrentUserStatus(this._repository) {
    updateUserState();
  }

  Future<AppUser?> getAppUser() async {
    AppUser? result = await _repository.getCurrentUser();
    print("Future<AppUser?> getAppUser() ====> $result");
    return result;
  }

  Future<void> updateUserState() async {
    final appUser = await _repository.getCurrentUser();
    if (appUser == null) {
      _userState = UserState.notLogin;
      print("----- userState----\n ===>>>>>>  notLogin");
    } else if (appUser.nickname == "") {
      print("----- userState----\n ===>>>>>>  inital");

      _userState = UserState.initial;
    } else {
      print("----- userState----\n ===>>>>>>  login");

      _userState = UserState.login;
    }

    notifyListeners();
  }
}
