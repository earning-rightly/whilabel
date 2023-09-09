import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/constants/routes_manager.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/my_page/announcement_page.dart';
import 'package:whilabel/screens/my_page/setting_page.dart';
import 'package:whilabel/screens/my_page/widgets/list_button.dart';
import 'package:whilabel/screens/my_page/widgets/short_whiskey_contuer.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final myPageData = MyPageData();
    return SingleChildScrollView(
      padding: WhilablePadding.basicPadding,
      child: Column(
        children: [
          // 마이페이지 최상상단 부분 (닉네임과 설정 아이콘)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "닉네임님",
                style: TextStylesManager()
                    .createHadColorTextStyle("B24", ColorsManager.gray500),
              ),
              IconButton(
                icon: SvgPicture.asset(myPageData.settingIconPath),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                },
              )
            ],
          ),
          // 유저가 마신 위스키와 브랜드 갯수를 보여준다
          ShortWhiskeyCounter(),

          // 마이페이지 리스트 중에 설정과 공지사랑으로 이동시켜주는 리스트 버튼
          for (Map<String, dynamic> data in myPageData.myPageViewButtonDatas)
            ListTitleIconButton(
              svgPath: data["svg_path"],
              titleText: data["title"],
              onPressedButton: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnnouncementPage(),
                  ),
                );
              },
            ),

          // 마이페이지 설정보기 과 문서보기를 구분 지어주는 선
          Divider(
            color: ColorsManager.black200,
            height: WhilabelSpacing.spac16,
            thickness: 2,
          ),

          // 마이페이지 문서보기 리스트 버튼
          for (Map<String, dynamic> docData
              in myPageData.myPageViewDucButtonDatas)
            ListTitleIconButton(
              svgPath: docData["svg_path"],
              titleText: docData["title"],
            ),
          TextButton(
            child: Text("muck route"),
            onPressed: () {
              Navigator.pushNamed(context, Routes.loginRoute);
            },
          ),
        ],
      ),
    );
  }
}

class MyPageData {
  String settingIconPath = SvgIconPath.setting;

//  todo "rotue 키값 value를 채워야 한다."
  List<Map<String, dynamic>> myPageViewButtonDatas = [
    {
      "svg_path": SvgIconPath.announce,
      "title": "공지사항",
      "rotue": AnnouncementPage
    },
    {"svg_path": SvgIconPath.icCheck, "title": "FAQ", "rotue": ""},
    {"svg_path": SvgIconPath.customer, "title": "1:1 문의하기", "rotue": ""},
    {"svg_path": SvgIconPath.announce, "title": "위라벨 소개", "rotue": ""},
  ];
//  todo "rotue 키값 value를 채워야 한다."

  List<Map<String, dynamic>> myPageViewDucButtonDatas = [
    {"svg_path": SvgIconPath.document, "title": "서비스, 이용약관", "rotue": ""},
    {
      "svg_path": SvgIconPath.document,
      "title": "개인정보 처리방침",
      "rotue": "",
    },
    {
      "svg_path": SvgIconPath.document,
      "title": "오픈소스 라이센스",
      "rotue": "",
    },
  ];
}