import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/home/grid/expanded_image_item.dart';
import 'package:whilabel/screens/_global/whilabel_context_menu.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

import '../../view_model/home_event.dart';

// ignore: must_be_immutable
class EachWhiskeyGridView extends StatelessWidget {
  final List<ArchivingPost> whiskeyNameGroupedArchivingPosts;

  EachWhiskeyGridView({
    Key? key,
    required this.whiskeyNameGroupedArchivingPosts,
  }) : super(key: key);

  GlobalKey key = GlobalKey(); // declare a global key

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final homeViewModel = context.watch<HomeViewModel>();

    final RenderObject? overlay =
    Overlay
        .of(context)
        .context
        .findRenderObject();

    return GestureDetector(
      onTap: () {

        showDialog(
          context: context,
          builder: (context) =>
              SafeArea(
                child: Stack(
                  children: [
                    BackdropFilter(
                      filter: ui.ImageFilter.blur(
                        sigmaX: 6.0,
                        sigmaY: 6.0,
                      ),

                      child: Container(
                        height: mediaQueryHeight,
                        width: mediaQueryWidth,
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 0,
                      left: 0,
                      child: ExpandedImageItem(
                        useDots: false,
                        height: mediaQueryHeight * 0.6,
                        context: context,
                        images: [
                          for (ArchivingPost whiskeyNameGroupedArchivingPost in whiskeyNameGroupedArchivingPosts)
                            whiskeyNameGroupedArchivingPost.imageUrl,
                        ],
                        onClick: (index) {
                          final ArchivingPost currentArchivingPost = whiskeyNameGroupedArchivingPosts[index];

                          WhilabelContextMenu.showContextMenu(
                              context,
                              overlay!.paintBounds.size.width,
                              overlay.paintBounds.size.height * 0.6)
                              .then((menuValue) {
                            switch (menuValue) {
                              case "share":
                                WhilabelContextMenu.sharePostWhiskeyImage(
                                    currentArchivingPost.imageUrl);
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
                    ),
                  ],
                ),
              ),
        );
      },
      child: Container(
        child:  ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          child: Image.network(
              fit: BoxFit.fill,
              whiskeyNameGroupedArchivingPosts.first.imageUrl),
        ),
      ),
    );
  }
}
