import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/my_page/page/announcement_page.dart';
import 'package:whilabel/screens/my_page/page/inquiring_page.dart';
import 'package:whilabel/screens/my_page/page/privacy_policy_page.dart';
import 'package:whilabel/screens/my_page/page/setting_page.dart';
import 'package:whilabel/screens/my_page/page/term_condition_service_page.dart';
import 'package:whilabel/screens/my_page/widgets/list_button.dart';
import 'package:whilabel/screens/my_page/widgets/short_whiskey_contuer.dart';
import 'package:whilabel/screens/onboarding/onboarding_step1.dart';

import 'page/f_a_q_page.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final myPageData = MyPageData();
    final currentAppUser = context.watch<CurrentUserStatus>().state.appUser;

    return SafeArea(
      child: SingleChildScrollView(
          padding: WhilabelPadding.basicPadding,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // 마이페이지 최상상단 부분 (닉네임과 설정 아이콘)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "${currentAppUser.nickName}님",
                      style: TextStylesManager.bold24,
                      maxLines: 2,
                    ),
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
              for (Map<String, dynamic> data
                  in myPageData.myPageViewButtonDatas)
                ListTitleIconButton(
                  svgPath: data["svg_path"],
                  titleText: data["title"],
                  pageRoute: data["rotue"],
                  // onPressedButton: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => data["rotue"],
                  //     ),
                  //   );
                  // },
                ),

              // 마이페이지 설정보기 과 문서보기를 구분 지어주는 선
              Divider(
                color: ColorsManager.black200,
                thickness: 2,
              ),

              // 마이페이지 문서보기 리스트 버튼
              for (Map<String, dynamic> docData
                  in myPageData.myPageViewDucButtonDatas)
                ListTitleIconButton(
                  svgPath: docData["svg_path"],
                  titleText: docData["title"],
                  pageRoute: docData["rotue"],
                  // onPressedButton: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => docData["rotue"],
                  //     ),
                  //   );
                  // },
                ),
            ],
          )),
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
      "rotue": MyPageRoutes.annoucementRoute
    },
    {
      "svg_path": SvgIconPath.faq,
      "title": "FAQ",
      "rotue": MyPageRoutes.faqRoute,
    },
    {
      "svg_path": SvgIconPath.customer,
      "title": "1:1 문의하기",
      "rotue": MyPageRoutes.inquiringRoute
    },
    {
      "svg_path": SvgIconPath.announce,
      "title": "위라벨 소개",
      "rotue": Routes.onBoardingRoute,
    },
  ];
//  todo "rotue 키값 value를 채워야 한다."

  List<Map<String, dynamic>> myPageViewDucButtonDatas = [
    {
      "svg_path": SvgIconPath.document,
      "title": "서비스, 이용약관",
      "rotue": MyPageRoutes.termConditionSerciceRoute,
    },
    {
      "svg_path": SvgIconPath.document,
      "title": "개인정보 처리방침",
      "rotue": MyPageRoutes.privacyPolicyPage,
    },
  ];
}
