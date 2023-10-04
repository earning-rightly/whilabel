import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

// scaffold의 appBar 파라미터는 AppBar타입만 들어갈 수 있기에 함수로 생성
AppBar createScaffoldAppBar(
    BuildContext context, String svgPath, String title) {
  return AppBar(
    leading: IconButton(
      padding: EdgeInsets.only(left: 16, right: 16),
      alignment: Alignment.centerLeft,
      icon: SvgPicture.asset(svgPath),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    centerTitle: true,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: TextStylesManager.bold16,
    ),
  );
}

class BodyAppBar extends StatelessWidget {
  const BodyAppBar({
    super.key,
    required this.svgPath,
    required this.centerTitle,
    this.rightTitle,
  });
  final String svgPath;
  final String centerTitle;
  final String? rightTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: SvgPicture.asset(svgPath),
          ),
          Expanded(
            child: Text(
              centerTitle,
              textAlign: TextAlign.center,
              style: TextStylesManager.bold16,
            ),
          ),
          Expanded(
            child: Text(
              rightTitle ?? "",
              textAlign: TextAlign.center,
              style: TextStylesManager.bold16,
            ),
          ),
        ],
      ),
    );
  }
}
