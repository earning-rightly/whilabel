import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_event.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_view_model.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';

// ignore: must_be_immutable
class ArchivingPostDetailFooter extends StatelessWidget {
  final String postImageUrl;
  final String whiskyName;
  final String strength;
  final String? whiskyLocation;
  final bool isModify;
  ArchivingPostDetailFooter({
    Key? key,
    required this.postImageUrl,
    required this.whiskyName,
    required this.strength,
    this.whiskyLocation,
    required this.isModify,
  }) : super(key: key);

  bool isfilled = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArchivingPostDetailViewModel>();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
          color: ColorsManager.black100,
          border:
              Border(top: BorderSide(width: 1, color: ColorsManager.black200))),
      height: 75,
      width: 340,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 40,
            child: Image.network(
              postImageUrl,
              fit: BoxFit.cover,
            ),
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
                    whiskyName,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                whiskyLocation != null
                    ? SizedBox(
                        child: Text(
                          "$whiskyLocation\t$strength%",
                          style: TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )
                    : SizedBox(
                        child: Text(
                          "\t$strength%",
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
                onPressed: isModify
                    ? () {
                        showUpdatePostDialog(
                          context,
                          onClickedYesButton: () {
                            viewModel.onEvent(
                              UpdateUserCritique(),
                              callback: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.rootRoute,
                                );
                              },
                            );
                          },
                        );
                      }
                    : null),
          )
        ],
      ),
    );
  }
}
