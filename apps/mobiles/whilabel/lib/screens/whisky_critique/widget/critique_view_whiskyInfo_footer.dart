// ignore: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/routes_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_event.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_view_model.dart';

// ignore: must_be_immutable
class CritiqueViewWhiskyInfoFooter extends StatefulWidget {
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
    final state = viewModel.state;

    return FutureBuilder<bool>(
      future: viewModel.isChangeStareValue(),
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          isfilled = true;
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
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
                child: Image.file(fit: BoxFit.cover, state.image!),
              ),
              SizedBox(width: WhilabelSpacing.spac12),
              Expanded(
                flex: 149,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Text(
                        state.whiskyName,
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    state.whiskyLocation != null
                        ? SizedBox(
                            child: Text(
                              "${state.whiskyLocation}\t${state.strength}%",
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        : SizedBox(
                            child: Text(
                              "\t${state.strength}%",
                              style: TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                  ],
                ),
              ),
              SizedBox(width: WhilabelSpacing.spac12),
              Expanded(
                flex: 96,
                child: ElevatedButton(
                  child: Text("저장하기"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsManager.brown100,
                  ),
                  onPressed: isfilled == false
                      ? null
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

                              print(
                                  " last post id ===>  ${state.archivingPost?.postId.toString()}");
                              ArchivingPost? lastArArchivingPost =
                                  await viewModel.getLastArchivingPost(
                                      viewModel.state.archivingPost!.postId);
                              Navigator.pushNamed(
                                  context, Routes.whiskeyRegisterRoute,
                                  arguments: lastArArchivingPost);
                            },
                          );
                        },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}