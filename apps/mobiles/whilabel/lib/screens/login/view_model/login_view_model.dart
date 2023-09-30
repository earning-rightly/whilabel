import 'package:flutter/foundation.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/data/user/vaild_account.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/use_case/short_archiving_post_use_case.dart';
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
    VaildAccount vailAccount = await _loginUseCase.call(snsType);
    UserState userState;
    debugPrint("isLogined ===> ${vailAccount.isLogined}");
    debugPrint("isNewbie ===> ${vailAccount.isNewbie}");
    debugPrint("isDeleted ===> ${vailAccount.isDelted}");

    if (vailAccount.isLogined &&
        vailAccount.isNewbie &&
        vailAccount.isDelted == false)
      userState = UserState.initial;
    else if (vailAccount.isDelted) {
      userState = UserState.notLogin;
      vailAccount = vailAccount.copyWith(isLogined: false);
      // userState = UserState.notLogin;
      print("userState = UserState.deleting;");
    } else if (vailAccount.isLogined && vailAccount.isDelted == false)
      userState = UserState.login;
    else
      userState = UserState.notLogin;

    _state = _state.copyWith(
      isLogined: vailAccount.isLogined,
      userState: userState,
      isDeleted: vailAccount.isDelted,
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
