import 'package:dartx/dartx.dart';
import 'package:flutter/foundation.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/use_case/user_auth/login_use_case.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;

  LoginState _state = LoginState(
    isLogined: false,
    isNewbie: false,
  );

  LoginState get state => _state;

  LoginViewModel(
    this.loginUseCase,
    this.logoutUseCase,
  );

  Future<void> onEvent(LoginEvent event, {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
          login: _login,
          logout: _logout,
        )
        .then((_) => {after()});
  }

  Future<void> _login(SnsType snsType) async {
    Pair<bool, bool> isLoginedIsNewbie = await loginUseCase.call(snsType);

    debugPrint("isLogined ===> ${isLoginedIsNewbie.first}");
    debugPrint("isNewbie ===> ${isLoginedIsNewbie.second}");

    _state = _state.copyWith(
      isLogined: isLoginedIsNewbie.first,
      isNewbie: isLoginedIsNewbie.second,
    );

    notifyListeners();
  }

  Future<void> _logout(SnsType snsType) async {
    bool isLogined = await logoutUseCase.call(snsType);
    _state = _state.copyWith(
      isLogined: isLogined,
      isNewbie: _state.isNewbie,
    );

    notifyListeners();
  }
}
