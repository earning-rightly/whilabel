import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

class WhilabelContextMenu {
  static List<Map<String, dynamic>> meunItemContent = [
    {
      "title": "공유하기",
      "value": "share",
      "title_style": TextStylesManager.regular16,
      "icon_path": SvgIconPath.share,
      "icon_color": ColorsManager.white,
    },
    {
      "title": "수정하기",
      "value": "modify",
      "title_style": TextStylesManager.regular16,
      "icon_path": SvgIconPath.modify,
      "icon_color": ColorsManager.white,
    },
    {
      "title": "삭제하기",
      "value": "delete",
      "title_style":
          TextStylesManager.createHadColorTextStyle("R16", ColorsManager.red),
      "icon_path": SvgIconPath.delete,
      "icon_color": ColorsManager.red,
    }
  ];

  static Future<String> showContextMenu(
      BuildContext context, double left, double top) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      color: ColorsManager.black400,
      context: context,
      constraints: BoxConstraints(
        minWidth: 200,
        maxHeight: 140,
        maxWidth: 250,
      ),
      position: RelativeRect.fromRect(
          Rect.fromLTWH(left, top, 30, 30),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height)),
      items: <PopupMenuItem>[
        for (int index = 0; index < meunItemContent.length; index++)
          PopupMenuItem(
//               value: meunItemContent[index]["value"],
            value: meunItemContent[index]["value"],
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  border: Border(
                      bottom:
                          BorderSide(color: ColorsManager.gray200, width: 2))),
              width: 300,
              height: 40,
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        meunItemContent[index]["title"],
                        style: meunItemContent[index]["title_style"],
                      ),
                      SvgPicture.asset(
                        meunItemContent[index]["icon_path"],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
      ],
    );

    return result ?? "";
  }
}





// for (int index = 0; index < meunItemContent.length; index++)
//           PopupMenuItem(
//               value: meunItemContent[index]["value"],
//               padding: EdgeInsets.zero,
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16),
//                 decoration: BoxDecoration(
//                     border: Border(
//                         bottom: BorderSide(
//                             color: ColorsManager.gray200, width: 2))),
//                 width: 1000,
//                 height: 40,
//                 child: Stack(children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         meunItemContent[index]["title"],
//                         style: meunItemContent[index]["title_style"],
//                       ),
//                       SvgPicture.asset(
//                         meunItemContent[index]["icon_path"],
//                       ),
//                       // Icon(
//                       //   Icons.ios_share_outlined,
//                       //   color: Colors.white,
//                       // ),
//                     ],
//                   )
//                 ]),
//               )),