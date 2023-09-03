import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_state.dart';
import 'package:whilabel/domain/use_case/user_auth/login_use_case.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/domain/user/firestore_user_repository_impl.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';

List<SingleChildWidget> initialProviders() {
  AppUserCollectionReference appUserRef = usersRef;
  AppUserRepository appUserRepository = FirestoreUserRepositoryImpl(appUserRef);

  final currentUserStatus = CurrentUserStatus(appUserRepository);

// use case provider
  final loginUseCase = LoginUseCase(
    appUserRepository: appUserRepository,
    currentUserStatus: currentUserStatus,
  );
  final logoutUseCase = LogoutUseCase(
    currentUserStatus: currentUserStatus,
  );

// view model Provider
  final loginViewModel = LoginViewModel(
    loginUseCase,
    logoutUseCase,
  );

  return [
    ChangeNotifierProvider(
      create: (context) => currentUserStatus,
    ),
    ChangeNotifierProvider(
      create: (context) => loginViewModel,
    ),
  ];
}
