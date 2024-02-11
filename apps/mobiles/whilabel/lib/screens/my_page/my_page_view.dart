import 'package:dartx/dartx.dart';
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
import 'package:whilabel/screens/my_page/page/setting_page.dart';
import 'package:whilabel/screens/my_page/widgets/list_button.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final myPageData = MyPageData();
    final currentAppUser = context.watch<CurrentUserStatus>().state.appUser!;
    final _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
          padding: WhilabelPadding.basicPadding,
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // 마이페이지 최상상단 부분 (닉네임과 설정 아이콘)
              SizedBox(
                width: _width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: _width * 0.7,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              "${currentAppUser.nickName}님",
                              // "가나다라마바사아자차카타파하아자차카타파하",
                              style: TextStylesManager.bold24,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton( // 유저정보 수정하는 view로 이동
                            icon: SvgPicture.asset(SvgIconPath.modify),
                            onPressed: () {
                             if ( currentAppUser.nickName.isNullOrEmpty != true) {
                               Navigator.pushNamed(context,
                                   arguments: currentAppUser.nickName,
                                   Routes.userAdditionalInfoRoute);
                             }
                            },
                          ),
                        ],
                      ),
                    ),
                    Align(
                      child: IconButton(
                        icon: SvgPicture.asset(myPageData.settingIconPath),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                           Routes.myPageRoutes.settingRoute
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),

              // 마이페이지 리스트 중에 설정과 공지사랑으로 이동시켜주는 리스트 버튼
              for (Map<String, dynamic> data
                  in myPageData.myPageViewButtonDatas)
                ListTitleIconButton(
                  svgPath: data["svg_path"],
                  titleText: data["title"],
                  pageRoute: data["route"],
                ),

              const SizedBox(height: 16),
              // 마이페이지 설정보기 과 문서보기를 구분 지어주는 선
              const Divider(
                color: ColorsManager.black200,
                thickness: 2,
              ),
              const SizedBox(height: 16),
              
              // 마이페이지 문서보기 리스트 버튼
              for (Map<String, dynamic> docData
                  in myPageData.myPageViewDucButtonDatas)
                ListTitleIconButton(
                  svgPath: docData["svg_path"],
                  titleText: docData["title"],
                  pageRoute: docData["route"],
                ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                    children: [Text("버전 정보 1.0.0", style: TextStylesManager.regular12Black400)]
                )
              )
            ],
          )),
    );
  }
}

class MyPageData {
  String settingIconPath = SvgIconPath.setting;

  List<Map<String, dynamic>> myPageViewButtonDatas = [
    {
      "svg_path": SvgIconPath.announce,
      "title": "공지사항",
      "route": Routes.myPageRoutes.announcementRoute
    },
    {
      "svg_path": SvgIconPath.faq,
      "title": "FAQ",
      "route": Routes.myPageRoutes.faqRoute,
    },
    {
      "svg_path": SvgIconPath.customer,
      "title": "1:1 문의하기",
      "route": Routes.myPageRoutes.inquiringRoute
    },
    {
      "svg_path": SvgIconPath.announce,
      "title": "위라벨 소개",
      "route": Routes.onBoardingRoute,
    },
  ];

  List<Map<String, dynamic>> myPageViewDucButtonDatas = [
    {
      "svg_path": SvgIconPath.document,
      "title": "서비스 이용약관",
      "route": Routes.myPageRoutes.termConditionServiceRoute,
    },
    {
      "svg_path": SvgIconPath.document,
      "title": "개인정보 처리방침",
      "route": Routes.myPageRoutes.privacyPolicyRoute,
    },
  ];
}
