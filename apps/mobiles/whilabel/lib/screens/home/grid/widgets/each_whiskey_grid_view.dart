import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/post/short_archiving_post.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/home/grid/expanded_image_item.dart';
import 'package:whilabel/screens/_global/whilabel_context_menu.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

import '../../view_model/home_event.dart';

// ignore: must_be_immutable
class EachWhiskeyGridView extends StatelessWidget {
  final List<ShortArchivingPost> shortArchivingPosts;

  EachWhiskeyGridView({
    Key? key,
    required this.shortArchivingPosts,
  }) : super(key: key);

  GlobalKey key = GlobalKey(); // declare a global key

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final homeViewModel = context.watch<HomeViewModel>();
    final List<ArchivingPost> archivingPosts =
        homeViewModel.state.listTypeArchivingPosts;

    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    return GestureDetector(
      onTap: () {
        // ShowPopupWhiskyImage(
        //     context, mediaQueryWidth * 0.5, mediaQueryHeight * 0.6);

        showDialog(
          context: context,
          builder: (context) => ExpandedImageItem(
            useDots: false,
            height: mediaQueryHeight * 0.6,
            context: context,
            images: [
              for (ShortArchivingPost shortArchivingPost in shortArchivingPosts)
                shortArchivingPost.imageUrl,
            ],
            onClick: (index) {
              print("grid ====>>> current index: $index");
              final ArchivingPost currentArchivingPost = archivingPosts
                  .where((archivingPost) =>
                      archivingPost.postId == shortArchivingPosts[index].postId)
                  .first;

              WhilabelContextMenu.showContextMenu(
                      context,
                      overlay!.paintBounds.size.width,
                      overlay.paintBounds.size.height * 0.6)
                  .then((menuValue) {
                switch (menuValue) {
                  case "share":
                    break;
                  case "modify":
                    Navigator.pushNamed(
                        context, Routes.archivingPostDetailRoute,
                        arguments: currentArchivingPost);
                    break;
                  case "delete":
                    showDeletePostDialog(
                      context,
                      onClickedYesButton: () {
                        homeViewModel.onEvent(
                            HomeEvent.deleteArchivingPost(
                              archivingPostId: currentArchivingPost.postId,
                              userid: currentArchivingPost.userId,
                              whiskyName: currentArchivingPost.whiskyName,
                            ), callback: () {
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
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(shortArchivingPosts.first.imageUrl),
          ),
        ),
      ),
    );
  }

  // void ShowPopupWhiskyImage(BuildContext context, double width, double height) {
  //   final RenderObject? overlay =
  //       Overlay.of(context).context.findRenderObject();

  //   showDialog(
  //     context: context,
  //     builder: (context) => ExpandedImageItem(
  //       useDots: false,
  //       height: height,
  //       context: context,
  //       images: [
  //         for (ShortArchivingPost shortArchivingPost in shortArchivingPosts)
  //           shortArchivingPost.imageUrl,
  //       ],
  //       onClick: (valeu) {
  //         WhilabelContextMenu.showContextMenu(
  //             context,
  //             overlay!.paintBounds.size.width,
  //             overlay.paintBounds.size.height * 0.6);
  //       },
  //     ),
  //   );
  // }
}
