import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart'
    as imagePaths;
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/login/instargram_login_web_page.dart';
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
                        child: Text("로그아웃 데트스")),
                    EachLoginButton(
                      buttonText: "카카오로 로그인하기",
                      svgImagePath: imagePaths.kakaoIcon,
                      onPressedFunc: () {
                        turnOnOffoffstage();

                        viewModel.onEvent(LoginEvent.login(SnsType.KAKAO),
                            callback: () {
                          // 로그인 후 이동할 경로 확인
                          checkNextRoute(
                            context,
                            viewModel.state.isLogined,
                            viewModel.state.userState,
                          );
                        });
                      },
                    ),
                    EachLoginButton(
                      buttonText: "인스타로 로그인하기",
                      svgImagePath: imagePaths.instargramIcon,
                      onPressedFunc: () {
                        turnOnOffoffstage();

                        // 인스타 로그인은 웹뷰를 띄어줘야 하기에 로직이 다른것들과 다릅니다.
                        if (viewModel.state.userState == UserState.notLogin) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InstargramLoginWebPage(),
                            ),
                          );
                        }
                      },
                    ),
                    EachLoginButton(
                      buttonText: "구글로 로그인하기",
                      svgImagePath: imagePaths.googleIcon,
                      onPressedFunc: () {
                        turnOnOffoffstage();

                        viewModel.onEvent(LoginEvent.login(SnsType.GOOGLE),
                            callback: () {
                          // 로그인 후 이동할 경로 확인
                          checkNextRoute(
                            context,
                            viewModel.state.isLogined,
                            viewModel.state.userState,
                          );
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

  void turnOnOffoffstage() {
    setState(() {
      _offstage = !_offstage;
    });
  }

  void loginError() {
    turnOnOffoffstage();
    debugPrint("로그인 오류 발생");
  }

  void checkNextRoute(
    BuildContext context,
    bool isLogined,
    UserState userState,
  ) {
    setState(() {});

    // 뉴비면 유저 추가 정보를 받는 화면으로 이동
    if (isLogined && userState == UserState.initial) {
      Navigator.pushReplacementNamed(
        context,
        Routes.userAdditionalInfoRoute,
      );

      // 뉴비가 아닌 유저면 홈 화면으로 이동
    } else if (isLogined && userState == UserState.login) {
      Navigator.pushReplacementNamed(
        context,
        Routes.rootRoute,
      );
    } // TODO: login하는 과정에서 에러가 발생하면 알림 띄우기
    else {
      loginError();
    }
  }
}
