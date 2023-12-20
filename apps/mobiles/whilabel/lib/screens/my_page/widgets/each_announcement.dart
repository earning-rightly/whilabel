import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';



class EachAnnouncement extends StatelessWidget {
  final String title;
  final String body;
  final String whiskyName;

  const EachAnnouncement({
    Key? key,
    required this.title,
    required this.body,
    required this.whiskyName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 50,
        width: 50,
        child: Image.asset(
          playstoreImage,
          fit: BoxFit.fill,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStylesManager.createHadColorTextStyle(
                "M12", ColorsManager.gray),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Text(
              body,
              style: TextStylesManager.createHadColorTextStyle(
                  "M16", ColorsManager.gray300),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            whiskyName,
            style: TextStylesManager.createHadColorTextStyle(
                "M12", ColorsManager.brown100),
          )
        ],
      ),
    );
  }
}

