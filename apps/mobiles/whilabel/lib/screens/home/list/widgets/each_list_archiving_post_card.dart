import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/_global/whilabel_context_menu.dart';
import 'package:whilabel/screens/home/view_model/home_event.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

// ignore: must_be_immutable
class EachListArchivingPostCard extends StatelessWidget {
  final ArchivingPost archivingPost;
  EachListArchivingPostCard({super.key, required this.archivingPost});
  String creatDate = "";
  GlobalKey key = GlobalKey(); // declare a global key

  void initState() {
    final DateTime date1 = DateTime.fromMicrosecondsSinceEpoch(
        archivingPost.createAt!.microsecondsSinceEpoch);

    creatDate = DateFormat("yyyy.MM.dd").format(date1);
  }

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.archivingPostDetailRoute,
            arguments: archivingPost);
      },
      child: SizedBox(
        width: 350,
        height: 110,
        child: Row(
          children: [
            Expanded(
              flex: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: SizedBox(
                  width: 85,
                  height: 120,
                  child: Image.network(
                    archivingPost.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: WhilabelSpacing.spac16),
            //
            Expanded(
              flex: 247,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        archivingPost.whiskyName.length > 12
                            ? archivingPost.whiskyName.substring(0, 12)
                            : "${archivingPost.whiskyName}...",
                        style: TextStylesManager.bold16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      IconButton(
                        splashColor: ColorsManager.black300,
                        splashRadius: 15,
                        icon: SvgPicture.asset(SvgIconPath.menu),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 10, minHeight: 10),
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () async {
                          RenderBox box = key.currentContext?.findRenderObject()
                              as RenderBox;
                          Offset position = box.localToGlobal(
                              Offset.zero); //this is global position
                          await WhilabelContextMenu.showContextMenu(
                                  context, position.dx + 1000, position.dy)
                              .then((menuValue) {
                            switch (menuValue) {
                              case "share":
                                break;
                              case "modify":
                                Navigator.pushNamed(
                                    context, Routes.archivingPostDetailRoute,
                                    arguments: archivingPost);
                                break;
                              case "delete":
                                showDeletePostDialog(
                                  context,
                                  onClickedYesButton: () {
                                    homeViewModel.onEvent(
                                        HomeEvent.deleteArchivingPost(
                                            archivingPost.postId),
                                        callback: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Routes.rootRoute,
                                      );
                                      homeViewModel.state.archivingPosts.length;
                                    });
                                  },
                                );
                            }
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: WhilabelSpacing.spac12 / 2),
                  Text(
                    "${archivingPost.location ?? ""}\t\u2022\t${archivingPost.strength != null ? archivingPost.strength! + "%" : ""}",
                    style: TextStylesManager()
                        .createHadColorTextStyle("R12", ColorsManager.gray),
                  ),
                  SizedBox(height: WhilabelSpacing.spac12 / 2),
                  Flexible(
                    fit: FlexFit.tight, // 나머지 모든 공간을 차지
                    child: Container(
                      padding: EdgeInsets.only(left: 1, right: 1),
                      child: SizedBox(
                        child: Text(
                          "\"archivingPost.note\"",
                          style: TextStylesManager().createHadColorTextStyle(
                              "R14", ColorsManager.gray300),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: WhilabelSpacing.spac12 / 2),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    height: 30,
                    width: MediaQuery.of(context).size.width / 2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: ColorsManager.black200),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: ColorsManager.yellow, size: 16),
                        Text(
                          "${archivingPost.starValue}",
                          style: TextStylesManager().createHadColorTextStyle(
                              "M12", ColorsManager.yellow),
                        ),
                        Text(
                          "\t$creatDate",
                          style: TextStylesManager().createHadColorTextStyle(
                              "M12", ColorsManager.yellow),
                        ),
                        Text(
                          archivingPost.location ?? "",
                          style: TextStylesManager().createHadColorTextStyle(
                              "R12", ColorsManager.gray),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void callItemValue(BuildContext context, String itemValue) {}
