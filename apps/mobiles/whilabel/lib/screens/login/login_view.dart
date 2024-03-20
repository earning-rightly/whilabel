import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/_global/functions/show_simple_dialog.dart';
import 'package:whilabel/screens/_global/widgets/back_listener.dart';
import 'package:whilabel/screens/_global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';
import 'package:whilabel/screens/login/widget/each_login_button.dart';

import '../_constants/colors_manager.dart';
import '../_constants/text_styles_manager.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool get isiOS => foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();

    return BackListener(
      onBackButtonClick: ()=> showColoseAppDialog(context),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xffA87137),
                          Color(0xff864E33),
                        ]),
                  ),
                ),
              ),
              Column(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        SvgIconPath.whilabelIcon,
                        width: 270,
                      ),
                      SizedBox(height: WhilabelSpacing.space16),
                      Text("즐거운 위스키 생활의 시작, 위라벨.",
                          style: TextStylesManager.createHadColorTextStyle(
                              "B16", ColorsManager.white))
                    ],
                  )),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 32),
                      child: Column(
                        children: [
                          EachLoginButton(
                            buttonText: "카카오톡으로 로그인",
                            svgImagePath: SvgIconPath.kakaoIcon,
                            onPressedFunc: () {
                              startLogin();

                              viewModel.onEvent(const LoginEvent.login(SnsType.KAKAO),
                                  callback: () {
                                    // 로그인 후 이동할 경로 확인
                                    checkNextRoute(
                                      context: context,
                                      userState: viewModel.state.userState,
                                    );
                                  });
                            },
                          ),
                          SizedBox(height: WhilabelSpacing.space16),
                          EachLoginButton(
                            buttonText: "구글 계정으로 로그인",
                            svgImagePath: SvgIconPath.googleIcon,
                            onPressedFunc: () {
                              startLogin();

                              viewModel.onEvent(const LoginEvent.login(SnsType.GOOGLE),
                                  callback: () {
                                    // 로그인 후 이동할 경로 확인
                                    checkNextRoute(
                                      context: context,
                                      userState: viewModel.state.userState,
                                    );
                                  });
                            },
                          ),
                          if (isiOS)
                            ...[SizedBox(height: WhilabelSpacing.space16),
                            EachLoginButton(
                              buttonText: "애플 계정으로 로그인",
                              svgImagePath: SvgIconPath.appleIcon,
                              onPressedFunc: () async {
                                startLogin();

                                viewModel.onEvent(const LoginEvent.login(SnsType.APPLE),
                                    callback: () {
                                      // 로그인 후 이동할 경로 확인
                                      checkNextRoute(
                                        context: context,
                                        userState: viewModel.state.userState,
                                      );
                                    });
                              },
                            )]
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startLogin() {

    CustomLoadingIndicator.showLodingProgress();

  }

  void endLogin() {
    CustomLoadingIndicator.dimissonProgress(milliseconds: 5000);

  }

  void checkNextRoute({
    required BuildContext context,
    required UserState userState,
  }) {
    setState(() {});

    // 뉴비면 유저 추가 정보를 받는 화면으로 이동
    if (userState == UserState.initial) {
      debugPrint("회원가입을 진행합니다.");
      Navigator.pushNamed(
        context,
        Routes.userAdditionalInfoRoute,
      );
    }
    // 뉴비가 아닌 유저면 홈 화면으로 이동
    else if (userState == UserState.login) {
      debugPrint("로그인을 성공했습니다.");
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.rootRoute,
        (route) => false,
      );
    } else if (userState == UserState.loginFail) {
      final loginViewModel = context.read<LoginViewModel>();
      loginViewModel.onEvent(LoginEvent.logout(SnsType.EMPTY), callback: (){
        showSimpleDialog(context, "로그인 실패", "아래로 문의주세요.\nwhilabel23@gmail.com");
      });
    }
    endLogin();
  }
}
