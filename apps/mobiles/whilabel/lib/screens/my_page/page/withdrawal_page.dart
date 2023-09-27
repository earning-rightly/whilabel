import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_event.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_view_model.dart';

// ignore: must_be_immutable
class WithdrawalPage extends StatelessWidget {
  WithdrawalPage({super.key});

  String withDrowPageTitle = "지금 탈퇴하면 위라벨에서 제공하는 다양한 혜택을 더 이상 누릴 수 없어요";
  String withDrowPageWaringText1 = "위스키 맛과 브랜드의 특징에 접근할 수 없습니다";
  String withDrowPageWaringText2 = "수동적으로 등록된 위스키에 대한 정보는 보관됩니다";
  String withDrowPageWaringText3 = "나의 위스키 기록(사진, 별점, 한 줄평 등)이 영구적으로 삭제됩니다";
  String dot = "\u2022\t\t"; // 점 구현

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MyPageViewModel>();
    final loginViewModel = context.watch<LoginViewModel>();
    final appUser = context.watch<CurrentUserStatus>().state.appUser;

    return Scaffold(
      appBar: buildScaffoldAppBar(context, SvgIconPath.close, "탈퇴하기"),
      body: Padding(
        padding: WhilabelPadding.basicPadding,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 10,
                child: SizedBox(
                  height: 200, //todo 유동성 있게 수정 필요
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 상단 굵은 탈퇴 안내글
                      Flexible(
                        child: Text(
                          withDrowPageTitle,
                          maxLines: 2,
                          style: TextStylesManager().createHadColorTextStyle(
                              "B20", ColorsManager.gray500),
                        ),
                      ),
                      SizedBox(height: WhilabelSpacing.spac24),

                      // 첫 번째 리스트 글
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dot, style: TextStylesManager.regular14),
                          Text(
                            withDrowPageWaringText1,
                            style: TextStylesManager.regular14,
                          ),
                        ],
                      ),
                      SizedBox(height: WhilabelSpacing.spac12),

                      // 두 번째 리스트 글
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dot, style: TextStylesManager.regular14),
                          Text(
                            withDrowPageWaringText2,
                            style: TextStylesManager.regular14,
                          ),
                        ],
                      ),
                      SizedBox(height: WhilabelSpacing.spac12),

                      // 세 번째 리스트 글
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dot, style: TextStylesManager.regular14),
                          Flexible(
                            child: SizedBox(
                              height: 50,
                              child: Text(
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                withDrowPageWaringText3,
                                style: TextStylesManager.regular14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 0,
                left: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 탈퇴 보류 버튼 //todo 어느 곳을 이동?
                      LongTextButton(
                        buttonText: "위라벨 계속 사용하기",
                        buttonTextColor: ColorsManager.gray500,
                        color: ColorsManager.orange,
                        onPressedFunc: () {},
                      ),
                      // 탈퇴하기 => 팝업 창 생성
                      LongTextButton(
                        buttonText: "탈퇴하기",
                        buttonTextColor: ColorsManager.gray500,
                        color: ColorsManager.black100,
                        onPressedFunc: () async {
                          showWithdrawalDialog(
                            context,
                            onClickedYesButton: () {
                              viewModel.onEvent(
                                  MyPageEvent.withdrawAccount(appUser.uid));
                              loginViewModel.onEvent(
                                LoginEvent.logout(appUser.snsType),
                                callback: () {
                                  Navigator.pushNamed(
                                      context, Routes.loginRoute);
                                },
                              );

                              // SystemNavigator.pop();
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
