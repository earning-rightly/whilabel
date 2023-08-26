import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/constants/path/image_paths.dart' as imagePaths;
import 'package:whilabel/screens/login/widget/each_login_button.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
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
                    EachLoginButton(
                      buttonText: "카카오로 로그인하기",
                      svgImagePath: imagePaths.kakaoIcon,
                    ),
                    EachLoginButton(
                      buttonText: "인스타로 로그인하기",
                      svgImagePath: imagePaths.instargramIcon,
                    ),
                    EachLoginButton(
                      buttonText: "구글로 로그인하기",
                      svgImagePath: imagePaths.googleIcon,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
