import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/button_style.dart';
import 'package:whilabel/screens/_global/whilabel_context_menu.dart';
import 'package:whilabel/screens/_global/widgets/back_listener.dart';
import 'package:whilabel/screens/_global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

class SuccessfulUploadPostPage extends StatelessWidget {
  final int currentWhiskyCount;
  const SuccessfulUploadPostPage({
    Key? key,
    required this.currentWhiskyCount,
  }) : super(key: key);

  void initState() {}

  @override
  Widget build(BuildContext context) {
  // final  homeState = context.read<HomeViewModel>().state;
    final homeViewModel =context.read<HomeViewModel>();
    CustomLoadingIndicator.dimissonProgress();

    return BackListener(
      onBackButtonClick: (){
        bool isAblePop = Navigator.canPop(context);

        if (isAblePop)   Navigator.pop(context);
        else{
          Navigator.pushReplacementNamed(context, Routes.rootRoute);
        }
      },
      child: Scaffold(
        body: SafeArea(
            child: Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height / 3,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 56.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: ColorsManager.brown100,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(SvgIconPath.checkBold),
                  ),
                  SizedBox(height: WhilabelSpacing.space16),
                  Text(
                    "${currentWhiskyCount + 1}번째 위스키에요!",
                    style: TextStylesManager.createHadColorTextStyle(
                        "M16", ColorsManager.brown100),
                  ),
                  SizedBox(height: WhilabelSpacing.space8),
                  Text("등록이 완료되었습니다", style: TextStylesManager.bold20),
                ],
              ),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  // alignment: ,

                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          child: OutlinedButton(
                            onPressed: () async{
                            final lastArchivingPost  =  homeViewModel.state.listTypeArchivingPosts.first;
                              await  WhilabelContextMenu.sharePostWhiskeyImage(lastArchivingPost.imageUrl);

                            },
                            child: Text(
                              "공유하기",
                              style: TextStylesManager.bold16,
                            ),
                            style: createBasicButtonStyle(
                              ColorsManager.black300,
                              buttonSize: Size(120, 53),
                            ),
                          ),
                        ),
                      ),
                      // 공유하기 기능을 만들면 추가
                      SizedBox(width: WhilabelSpacing.space12),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          child: ElevatedButton(
                            onPressed: () async{
                              final lastArchivingPost  =  homeViewModel.state.listTypeArchivingPosts.first;

                              Navigator.pushReplacementNamed(context,
                                  arguments: lastArchivingPost,
                                  Routes.archivingPostDetailRoute);
                            },
                            child: Text(
                              "완료",
                              style: TextStylesManager.bold16,
                            ),
                            style: createBasicButtonStyle(
                              ColorsManager.brown100,
                              buttonSize: Size(120, 53),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        )),
      ),
    );
  }
}
