import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/screens/home/grid/expanded_image_item.dart';
import 'package:whilabel/screens/_global/whilabel_context_menu.dart';

// ignore: must_be_immutable
class EachWhiskeyGridView extends StatelessWidget {
  final ArchivingPost archivingPost;

  EachWhiskeyGridView({
    Key? key,
    required this.archivingPost,
  }) : super(key: key);

  GlobalKey key = GlobalKey(); // declare a global key

  @override
  Widget build(BuildContext context) {
    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final mediaQueryHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        ShowPopupWhiskyImage(
            context, mediaQueryWidth * 0.5, mediaQueryHeight * 0.6);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(archivingPost.imageUrl),
          ),
        ),
      ),
    );
  }

  void ShowPopupWhiskyImage(BuildContext context, double width, double height) {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    showDialog(
      context: context,
      builder: (context) => ExpandedImageItem(
        useDots: false,
        height: height,
        context: context,
        images: [
          archivingPost.imageUrl,
          "https://tinyurl.com/popup-banner-image2",
          "https://tinyurl.com/popup-banner-image3",
          "https://tinyurl.com/popup-banner-image4"
        ],
        onClick: (valeu) {
          WhilabelContextMenu.showContextMenu(
              context,
              overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height * 0.6);
        },
      ),
    );
  }
}
