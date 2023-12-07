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
  final int sameWhiskyNameCounter;
  EachListArchivingPostCard({
    Key? key,
    required this.archivingPost,
    required this.sameWhiskyNameCounter,
  }) : super(key: key);
  String creatDate = "";
  GlobalKey key = GlobalKey(); // declare a global key

  void initState() {}

  @override
  Widget build(BuildContext context) {
    final homeViewModel = context.watch<HomeViewModel>();
    final DateTime date1 = DateTime.fromMicrosecondsSinceEpoch(
        archivingPost.createAt!.microsecondsSinceEpoch);

    creatDate = DateFormat("yyyy.MM.dd").format(date1);

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
            // 리스트 왼쪽 위스키 사진
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
            SizedBox(width: WhilabelSpacing.space16),
            // 사진을 제외한 모든 공간
            Expanded(
              flex: 247,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        // whisky이름이 12자 이상이면 그 뒤로는 ... 표시
                        // archivingPost.whiskyName.length > 12
                        //     ? archivingPost.whiskyName.substring(0, 12)
                        //     : "${archivingPost.whiskyName}...",

                        archivingPost.whiskyName.length < 12
                            ? archivingPost.whiskyName
                            : "${archivingPost.whiskyName.substring(0, 12)}...",
                        style: TextStylesManager.bold16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // 누르면 item meun 보여주는 아이콘 버튼
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
                          RenderBox popUpMenuBox = key.currentContext?.findRenderObject()
                            as RenderBox;
                          // meauitems가 나타나야 하는 곳에 위치를 통일 시키기 위해서
                          Offset position = popUpMenuBox.localToGlobal(Offset.zero); //this is global position
                          // 디바이스가 터치된 곳 좌표를 보내준다.
                          await WhilabelContextMenu.showContextMenu(
                                context, position.dx + 1000, position.dy)
                                .then((menuValue) {
                            switch (menuValue) {
                              case "share":
                                WhilabelContextMenu.sharePostWhiskeyImage(archivingPost.imageUrl);
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
                                            archivingPostId:
                                              archivingPost.postId,
                                            userid: archivingPost.userId,
                                            whiskyName: archivingPost
                                                .whiskyName), callback: () {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Routes.rootRoute,
                                      );
                                      homeViewModel.state.listTypeArchivingPosts.length;
                                    });
                                  },
                                );
                            }
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(height: WhilabelSpacing.space12 / 2),
                  Text(
                    "${archivingPost.location ?? ""}\t\u2022\t${archivingPost.strength ?? 0.0.toString()}%",
                    style: TextStylesManager.createHadColorTextStyle(
                        "R12", ColorsManager.gray),
                  ),
                  SizedBox(height: WhilabelSpacing.space12 / 2),
                  Flexible(
                    fit: FlexFit.tight, // 나머지 모든 공간을 차지
                    child: Container(
                      padding: EdgeInsets.only(left: 1, right: 1),
                      child: SizedBox(
                        child: Text(
                          archivingPost.note.length < 24
                              ? archivingPost.note
                              : "${archivingPost.note.substring(0, 24)}...",
                          style: TextStylesManager.createHadColorTextStyle(
                              "R14", ColorsManager.gray300),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: WhilabelSpacing.space12 / 2),
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
                          style: TextStylesManager.createHadColorTextStyle(
                              "M12", ColorsManager.yellow),
                        ),
                        Text(
                          "\t$creatDate",
                          style: TextStylesManager.createHadColorTextStyle(
                              "M12", ColorsManager.gray),
                        ),
                        Text(
                          "\t\t- $sameWhiskyNameCounter잔",
                          style: TextStylesManager.createHadColorTextStyle(
                              "M12", ColorsManager.gray),
                        ),
                        Text(
                          archivingPost.location ?? "",
                          style: TextStylesManager.createHadColorTextStyle(
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

