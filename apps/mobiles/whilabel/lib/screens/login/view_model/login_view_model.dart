import 'package:flutter/foundation.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/use_case/user_auth/login_use_case.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  LoginState _state = LoginState(
    userState: UserState.notLogin,
  );

  LoginState get state => _state;

  LoginViewModel(
    LoginUseCase loginUseCase,
    LogoutUseCase logoutUseCase,
  )   : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase;

  Future<void> onEvent(LoginEvent event,
      {required VoidCallback callback}) async {
    event
        .when(
          login: _login,
          logout: _logout,
        )
        .then((_) => {callback()});
  }

  Future<void> _login(SnsType snsType) async {
    UserState userState = await _loginUseCase.login(snsType);
    _state = _state.copyWith(
      userState: userState,
    );

    notifyListeners();
  }

  Future<void> _logout(SnsType snsType) async {
    await _logoutUseCase.call(snsType);
    _state = _state.copyWith(
      userState: UserState.notLogin,
    );

    notifyListeners();
  }
}
