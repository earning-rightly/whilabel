import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/functions/button_style.dart';

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
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        style: createBasicButtonStyle(ColorsManager.white),
        onPressed:
            (widget.onPressedFunc != null) ? widget.onPressedFunc : () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.svgImagePath,
              width: 24,
            ),
            const SizedBox(width: 4),
            // Text 16 이 작은 것 같아 18로 키움
            Text(widget.buttonText,
                style: TextStylesManager.createHadColorTextStyle(
                    "B18", ColorsManager.black100))
          ],
        ),
      ),
    );
  }
}

//  SvgPicture.asset(
//               svgPath,
//               height: 25,
//               colorFilter:
//                   ColorFilter.mode(ColorsManager.black400, BlendMode.srcIn),
//             ),
