import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart'
    as imagePaths;
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/show_simple_dialog.dart';
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
  bool _isLoginProgress = true;
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
            Column(
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    imagePaths.whilabelIcon,
                    width: 270,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      children: [
                        EachLoginButton(
                          buttonText: "인스타그램 계정으로 로그인",
                          svgImagePath: imagePaths.instargramIcon,
                          onPressedFunc: () {
                            startLogin();

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
                        SizedBox(height: WhilabelSpacing.spac16),
                        EachLoginButton(
                          buttonText: "구글 계정으로 로그인",
                          svgImagePath: imagePaths.googleIcon,
                          onPressedFunc: () {
                            startLogin();

                            viewModel.onEvent(const LoginEvent.login(SnsType.GOOGLE),
                                callback: () {
                                  // 로그인 후 이동할 경로 확인
                                  checkNextRoute(
                                    context: context,
                                    isLogined: viewModel.state.isLogined,
                                    isDeleted: viewModel.state.isDeleted,
                                    userState: viewModel.state.userState,
                                  );
                                });
                          },
                        ),
                        SizedBox(height: WhilabelSpacing.spac16),
                        EachLoginButton(
                          buttonText: "카카오톡으로 로그인",
                          svgImagePath: imagePaths.kakaoIcon,
                          onPressedFunc: () {
                            startLogin();

                            viewModel.onEvent(const LoginEvent.login(SnsType.KAKAO),
                                callback: () {
                                  // 로그인 후 이동할 경로 확인
                                  checkNextRoute(
                                    context: context,
                                    isLogined: viewModel.state.isLogined,
                                    isDeleted: viewModel.state.isDeleted,
                                    userState: viewModel.state.userState,
                                  );
                                });
                          },
                        ),
                        // SizedBox(height: WhilabelSpacing.spac16),
                        // EachLoginButton(
                        //   buttonText: "MB 로그인하기",
                        //   svgImagePath: imagePaths.kakaoIcon,
                        //   onPressedFunc: () {
                        //     // turnOnOffoffstage();
                        //
                        //     // viewModel.onEvent(LoginEvent.login(SnsType.KAKAO),
                        //     //     callback: () {
                        //     //   // 로그인 후 이동할 경로 확인
                        //     //   checkNextRoute(
                        //     //     context: context,
                        //     //     isLogined: viewModel.state.isLogined,
                        //     //     isDeleted: viewModel.state.isDeleted,
                        //     //     userState: viewModel.state.userState,
                        //     //   );
                        //     // });
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            LodingProgressIndicator(
              offstage: _isLoginProgress,
            )
          ],
        ),
      ),
    );
  }

  void startLogin() {
    setState(() {
      _isLoginProgress = true;
    });
  }

  void endLogin() {
    setState(() {
      _isLoginProgress = false;
    });
  }

  void loginError(BuildContext context) {
    endLogin();
    showSimpleDialog(context, "로그인 에러!!", "앱을 종료하고 다시 시작해주세요");
    debugPrint("로그인 오류 발생");
  }

// 삭제 처리중인 계정으로 로그인할 경우
  void loginWithdrawingAccount(BuildContext context) {
    endLogin();

    showSimpleDialog(context, "삭제 처리중 계정입니다",
        "삭체처리 취소나 문의가 있는 아래로 해주세요\nwhilabel23@gmail.com");
    debugPrint("삭제 요청을한 계정 로그인 오류 발생");
  }

  void checkNextRoute({
    required BuildContext context,
    required bool isLogined,
    required bool isDeleted,
    required UserState userState,
  }) {
    setState(() {});

    // 뉴비면 유저 추가 정보를 받는 화면으로 이동
    if (isLogined && userState == UserState.initial) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.userAdditionalInfoRoute,
        (route) => false,
      );

      // 뉴비가 아닌 유저면 홈 화면으로 이동
    } else if (isDeleted) {
      loginWithdrawingAccount(context);
    }

    else if (isLogined && userState == UserState.login) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.rootRoute,
        (route) => false,
      );
    } // TODO: login하는 과정에서 에러가 발생하면 알림 띄우기
    else {
      loginError(context);
    }
  }
}
