import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';

// ignore: must_be_immutable
class EachListArchivingPostCard extends StatelessWidget {
  final ArchivingPost archivingPost;
  EachListArchivingPostCard({super.key, required this.archivingPost});
  String creatDate = "";

  void initState() {
    final DateTime date1 = DateTime.fromMicrosecondsSinceEpoch(
        archivingPost.createAt!.microsecondsSinceEpoch);

    creatDate = DateFormat("yyyy.MM.dd").format(date1);
  }

  @override
  Widget build(BuildContext context) {
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
                          minimumSize: Size.zero,
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {},
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
