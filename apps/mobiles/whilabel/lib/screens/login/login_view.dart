import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/global_provider/current_user_state.dart';
import 'package:whilabel/screens/constants/path/image_paths.dart' as imagePaths;
import 'package:whilabel/screens/constants/routes_manager.dart';
import 'package:whilabel/screens/global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';
import 'package:whilabel/screens/login/widget/each_login_button.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _offstage = true;
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  imagePaths.loginPngImage,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              top: 200,
              left: 0,
              right: 0,
              child: SvgPicture.asset(
                imagePaths.whilableIcon,
                width: 270,
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextButton(
                        onPressed: () {
                          viewModel.onEvent(LoginEvent.logout(SnsType.KAKAO));
                        },
                        child: Text("kakao로그아웃 데트스")),
                    TextButton(
                        onPressed: () {
                          viewModel.onEvent(LoginEvent.logout(SnsType.GOOGLE));
                        },
                        child: Text("google 로그아웃 데트스")),
                    EachLoginButton(
                      buttonText: "카카오로 로그인하기",
                      svgImagePath: imagePaths.kakaoIcon,
                      onPressedFunc: () {
                        setState(() {
                          _offstage = !_offstage;
                        });

                        viewModel.onEvent(LoginEvent.login(SnsType.KAKAO),
                            callback: () {
                          setState(() {});
                          if (viewModel.state.isLogined &&
                              viewModel.state.userState == UserState.initial) {
                            Navigator.pushNamed(
                              context,
                              Routes.userInfoAdditionalRoute,
                            );
                          } else if (viewModel.state.isLogined &&
                              viewModel.state.userState == UserState.login) {
                            Navigator.pushNamed(
                              context,
                              Routes.homeRoute,
                            );
                          }
                        });
                      },
                    ),
                    EachLoginButton(
                      buttonText: "인스타로 로그인하기",
                      svgImagePath: imagePaths.instargramIcon,
                      onPressedFunc: () {
                        setState(() {
                          _offstage = !_offstage;
                        });
                        if (viewModel.state.userState == UserState.notLogin) {
                          Navigator.pushNamed(
                            context,
                            Routes.instargramLoginWebPageRoute,
                          );
                        }
                      },
                    ),
                    EachLoginButton(
                      buttonText: "구글로 로그인하기",
                      svgImagePath: imagePaths.googleIcon,
                      onPressedFunc: () {
                        setState(() {
                          _offstage = !_offstage;
                        });
                        viewModel.onEvent(LoginEvent.login(SnsType.GOOGLE),
                            callback: () {
                          setState(() {});
                          if (viewModel.state.isLogined &&
                              viewModel.state.userState == UserState.initial) {
                            Navigator.pushNamed(
                              context,
                              Routes.userInfoAdditionalRoute,
                            );
                          } else if (viewModel.state.isLogined &&
                              viewModel.state.userState == UserState.login) {
                            Navigator.pushNamed(
                              context,
                              Routes.homeRoute,
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            LodingProgressIndicator(
              offstage: _offstage,
            )
          ],
        ),
      ),
    );
  }
}
