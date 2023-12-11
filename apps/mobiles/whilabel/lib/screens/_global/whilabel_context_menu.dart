import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:http/http.dart' as http;
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
  static List<Map<String, dynamic>> meunItemContentSub = [
    {
      "title": "공유하기",
      "value": "share",
      "title_style": TextStylesManager.regular16,
      "icon_path": SvgIconPath.share,
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
  /// ContextMenu창을 만들어주는 함수
  static Future<String> showContextMenu(
      BuildContext context, double left, double top, ) async {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject();

    final result = await showMenu(

      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      color: ColorsManager.black400,
      context: context,
      constraints: BoxConstraints(
        minWidth: 250.w, maxWidth: 274.w,
        // minHeight:133, maxHeight: 157,
        ),
      position: RelativeRect.fromRect(
          Rect.fromLTWH(left, top, 30, 30),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height)),
      items: <PopupMenuItem>[
        for (int index = 0; index < meunItemContent.length; index++)
          PopupMenuItem(
            value: meunItemContent[index]["value"],
            padding: EdgeInsets.zero,
            child: Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              alignment: Alignment.center,
              height: 44,
              // MenuItem 구분선
              decoration: BoxDecoration(
                  border: index == meunItemContent.length -1 ? null
                      : Border(bottom: BorderSide(color: ColorsManager.gray200, width: 0.5),)
              ),
              child: Row(
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
              ),
            ),
          ),
      ],
    );

    return result ?? "";
  }




  static Future<String> showContextMenuSub(
      BuildContext context, double left, double top,) async {
    final RenderObject? overlay =
    Overlay.of(context).context.findRenderObject();
    // int itemCount;

    final result = await showMenu(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
      color: ColorsManager.black400,
      context: context,
      constraints: BoxConstraints(
        minWidth: 250.w, maxWidth: 274.w,
        // minHeight:133, maxHeight: 157,157
      ),
      position: RelativeRect.fromRect(
          Rect.fromLTWH(left, top, 30, 30),
          Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
              overlay.paintBounds.size.height)),
      items: <PopupMenuItem>[
        for (int index = 0; index < meunItemContentSub.length; index++)
          PopupMenuItem(
            value: meunItemContentSub[index]["value"],
            padding: EdgeInsets.zero,
            child: Container(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 0),
              alignment: Alignment.center,
              height: 44,
              // MenuItem 구분선
              decoration: BoxDecoration(
                  border: index == meunItemContentSub.length -1 ? null
                      : Border(bottom: BorderSide(color: ColorsManager.gray200, width: 0.5),)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    meunItemContentSub[index]["title"],
                    style: meunItemContentSub[index]["title_style"],
                  ),
                  SvgPicture.asset(
                    meunItemContentSub[index]["icon_path"],
                  ),
                ],
              ),
            ),
          ),
      ],
    );

    return result ?? "";
  }



  static void sharePostWhiskeyImage(String imageUrl) async{

    DateTime dt = DateTime.now();
    int timestamp = dt.millisecondsSinceEpoch;

    try{
      //  `http` 패키지를 사용하여 이미지를 다운로드합니다.
      final http.Response response = await http.get(Uri.parse(imageUrl));
      // getTemporaryDirectory()을 이용하여 캐쉬메모리 저장소 path를 가져옵니다
      final Directory directory = await getTemporaryDirectory();
      // 사진파일을 캐쉬메모리에 저장하고 그 정보를 file 변수에 담습니다.
      final File file = await File('${directory.path}/$timestamp.png').writeAsBytes(response.bodyBytes);
      // Share패키지를 이용해서 os에 내장된 공유 기능을 사용합니다.
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: "<Whilabel> 즐거움 위스키 생활!! 사진을 공유합니다",
      );
    }

    catch(e){
      debugPrint("공유기능 사용중에 에러 발생\n ====> $e");
    }
  }
}



//           PopupMenuItem(
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