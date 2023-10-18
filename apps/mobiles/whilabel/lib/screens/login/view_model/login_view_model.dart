import 'package:flutter/foundation.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/data/user/account_state.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/use_case/user_auth/login_use_case.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  LoginState _state = LoginState(
    isLogined: false,
    isDeleted: false,
    userState: UserState.notLogin,
  );

  LoginState get state => _state;

  LoginViewModel(
    LoginUseCase loginUseCase,
    LogoutUseCase logoutUseCase,
  )   : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase;

  Future<void> onEvent(LoginEvent event, {required VoidCallback callback}) async {
    event
        .when(
          login: _login,
          logout: _logout,
        )
        .then((_) => {callback()});
  }

  Future<void> _login(SnsType snsType) async {
    AccountState? accountState = await _loginUseCase.getAccountState(snsType);

    if (accountState == null) {
      return;
    }

    UserState userState;
    debugPrint("isLogined ===> ${accountState.isLogined}");
    debugPrint("isNewbie ===> ${accountState.isNewbie}");
    debugPrint("isDeleted ===> ${accountState.isDeleted}");

    if (accountState.isLogined &&
        accountState.isNewbie &&
        accountState.isDeleted == false)
      userState = UserState.initial;
    else if (accountState.isDeleted) {
      userState = UserState.notLogin;
      accountState = accountState.copyWith(isLogined: false);
      // userState = UserState.notLogin;
      print("userState = UserState.deleting;");
    } else if (accountState.isLogined && accountState.isDeleted == false)
      userState = UserState.login;
    else
      userState = UserState.notLogin;

    _state = _state.copyWith(
      isLogined: accountState.isLogined,
      userState: userState,
      isDeleted: accountState.isDeleted,
    );

    notifyListeners();
  }

  Future<void> _logout(SnsType snsType) async {
    bool isLogined = await _logoutUseCase.call(snsType);
    _state = _state.copyWith(
      isLogined: isLogined,
      userState: UserState.notLogin,
    );

    notifyListeners();
  }
}
