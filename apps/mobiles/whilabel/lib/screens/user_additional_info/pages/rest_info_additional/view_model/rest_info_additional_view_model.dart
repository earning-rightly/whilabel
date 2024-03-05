import 'package:flutter/material.dart';

import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/repository/user/app_user_repository.dart';

import './rest_info_additional_event.dart';

class RestInfoAdditionalViewModel with ChangeNotifier {
  final AppUserRepository _appUserRepository;
  final CurrentUserStatus _currentUserStatus;

  RestInfoAdditionalViewModel({
    required currentUserStatus,
    required appUserRepository,
  })
      : _appUserRepository = appUserRepository,
        _currentUserStatus = currentUserStatus;


// UI Event
  Future<void> onEvent(RestInfoAdditionalEvent event,
      {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
      addUserInfo: addUserInfo,
    )
        .then((_) => {after()});
  }

  Future<void> addUserInfo(AppUser appUser) async {
    await _appUserRepository.insertUser(appUser);
    await _currentUserStatus.updateUserState();
  }
}
