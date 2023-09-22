import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';

List<String> iconPath = [
  SvgIconPath.tasteVanilla,
  SvgIconPath.tasteChocolat,
  SvgIconPath.tasteCitric,
  SvgIconPath.tasteDriedFruit,
  SvgIconPath.tasteFreshFruit,
  SvgIconPath.tasteHony,
  SvgIconPath.tasteHusky,
  SvgIconPath.tasteMedicinal,
  SvgIconPath.tasteNutty,
  SvgIconPath.tasteSherried,
  SvgIconPath.tasteSmokey,
  SvgIconPath.tasteTobacco,
];

class TasteFeatureGrid extends StatelessWidget {
  final List<String> tastFeaturs;
  const TasteFeatureGrid({
    Key? key,
    required this.tastFeaturs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GridView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: tastFeaturs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return TasteFeatureBox(tasteFeature: iconPath[index]);
          },
        ),
      ],
    );
  }
}

class TasteFeatureBox extends StatelessWidget {
  final String tasteFeature;
  const TasteFeatureBox({
    Key? key,
    required this.tasteFeature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.black200,
        borderRadius: BorderRadius.all(
          Radius.circular(WhilabelRadius.radius12),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ColorsManager.black300,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              fit: BoxFit.fill,
              tasteFeature,
            ),
          ),
          SizedBox(height: WhilabelSpacing.spac4 + 2),
          Text(
            "셰리함",
            style: TextStylesManager()
                .createHadColorTextStyle("M14", ColorsManager.gray200),
          )
        ],
      ),
    );
  }
}
