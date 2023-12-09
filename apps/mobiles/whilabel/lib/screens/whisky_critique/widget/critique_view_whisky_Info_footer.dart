import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/show_simple_dialog.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';
import 'package:whilabel/screens/whisky_critique/pages/successful_upload_post_page.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_event.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_view_model.dart';

class CritiqueViewWhiskyInfoFooter extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CritiqueViewWhiskyInfoFooter({
    Key? key,
  }) : super(key: key);

  @override
  State<CritiqueViewWhiskyInfoFooter> createState() =>
      _CritiqueViewWhiskyInfoFooterState();
}

class _CritiqueViewWhiskyInfoFooterState
    extends State<CritiqueViewWhiskyInfoFooter> {
  bool isfilled = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WhiskyCritiqueViewModel>();
    final cameraViewModel = context.watch<CameraViewModel>();
    final homeViewModel = context.watch<HomeViewModel>();
    final homeState = homeViewModel.state;
    final currentPostData = viewModel.state.whiskyNewArchivingPostUseCaseState;

    return FutureBuilder<bool>(
      future: viewModel.isChangeStareValue(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          isfilled = true;
        }
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
              color: ColorsManager.black100,
              border: Border(
                  top: BorderSide(width: 1, color: ColorsManager.black200))),
          height: 75,
          width: 340,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 40,
                child: Image.file(fit: BoxFit.cover, currentPostData.images!),
              ),
              SizedBox(width: WhilabelSpacing.space12),
              Expanded(
                flex: 149,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        currentPostData.archivingPost.whiskyName,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    currentPostData.archivingPost.location != null
                        ? SizedBox(
                            child: Text(
                              "${currentPostData.archivingPost.location}\t${currentPostData.archivingPost.strength}%",
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        : SizedBox(
                            child: Text(
                              "\t${currentPostData.archivingPost.strength}%",
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                  ],
                ),
              ),
              SizedBox(width: WhilabelSpacing.space12),
              Expanded(
                flex: 96,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.brown100,
                  ),
                  onPressed: isfilled == false
                      ? () {
                          showSimpleDialog(
                            context,
                            "필수 입력 정보가 비었습니다",
                            "별점은 필수 입력 정보입니다. 탭을 해주세요",
                          );
                        }
                      : () async {
                          EasyLoading.show(
                            maskType: EasyLoadingMaskType.black,
                          );

                          await viewModel.onEvent(
                            SaveArchivingPostOnDb(
                              viewModel.state.starValue,
                              viewModel.state.tasteNote ?? "",
                              viewModel.state.tasteFeature!,
                            ),
                            callback: () async {
                              setState(() {});
                              await cameraViewModel.onEvent(const CameraEvent.cleanMediums());
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SuccessfulUploadPostPage(
                                            currentWhiskyCount:
                                                homeState.listTypeArchivingPosts.length,
                                          )),
                                  (route) => false);
                            },
                          );
                        },
                  child: const Text("등록하기"),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
