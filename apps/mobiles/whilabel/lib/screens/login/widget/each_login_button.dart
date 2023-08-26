import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/constants/styles/button_styles.dart'
    as btnStyle;

class EachLoginButton extends StatefulWidget {
  final Function()? onPressedFunc; // 파라미터로 받아서 실행할 로직
  final bool? enabled; // 버튼이 눌려도 되는지 확인할 변수
  final String svgImagePath; //
  final String buttonText;

  const EachLoginButton({
    Key? key,
    this.onPressedFunc,
    this.enabled,
    required this.svgImagePath,
    required this.buttonText,
  }) : super(key: key);

  @override
  State<EachLoginButton> createState() => _EachLoginButtonState();
}

class _EachLoginButtonState extends State<EachLoginButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: btnStyle.oauthLoginBtnStyle,
      onPressed: (widget.onPressedFunc != null) ? widget.onPressedFunc : () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.svgImagePath,
            width: 30,
            // height: 20,
          ),
          // SizedBox(width: 18),
          Text(
            widget.buttonText,
            style: TextStyle(
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
