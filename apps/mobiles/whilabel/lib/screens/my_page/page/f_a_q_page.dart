import 'package:flutter/material.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';

class FaqPage extends StatelessWidget {
  FaqPage({super.key});

  final List<Map<String, String>> faqData = [
    {
      "question": "Q1. 인식이 되지 않는 위스키는 어떻게 되는건가요?",
      "answer": "Answer. 인식이 되지 않은 위스키는 위라벨팀에서 등록하신 사진을 보고 판별하여 수동 등록을 지원합니다 :)"
    },
    {
      "question": "Q. 수동 등록되는 위스키는 알림이 오니요?",
      "answer": "Answer. 영업일 기준 3~7일 정도 소요되며, 최대한 빠르게 등록될 수 있게 노력하겠습니다 :)"
    },
    {
      "question": "Q. 위스키 인식은 어떻게 하나요?",
      "answer":
          "Answer. 위스키 기록 과정에서 촬영하시거나 갤러리에서 등록해 주시는 바코드를 통해 최대한 정확하게 인식하기위해 노력하고 있습니다 :)",
    },
  ];

  final String question1 = "Q. 인식이 되지 않는 위스키는 어떻게 되는건가요?";
  final String question2 = "Q. 수동 등록되는 위스키는 알림이 오니요?";
  final String question3 = "Q. 위스키 인식은 어떻게 하나요?";

  final String answer1 =
      "A. 인식이 되지 않은 위스키는 위라벨팀에서 등록하신 사진을 보고 판별하여 수동 등록을 지원합니다 :)";
  final String answer2 = "A. 영업일 기준 3~7일 정도 소요되며, 최대한 빠르게 등록될 수 있게 노력하겠습니다 :)";
  final String answer3 =
      "A. 위스키 기록 과정에서 촬영하시거나 갤러리에서 등록해 주시는 바코드를 통해 최대한 정확하게 인식하기위해 노력하고 있습니다 :)";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("FAQ"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              for (Map<String, String> data in faqData)
                SpreadListTitle(
                  title: data["question"]!,
                  readMoreText: data["answer"]!,
                )
            ],
          ),
        )),
      ),
    );
  }
}

class SpreadListTitle extends StatefulWidget {
  final String title;
  final String readMoreText;
  const SpreadListTitle({
    Key? key,
    required this.title,
    required this.readMoreText,
  }) : super(key: key);

  @override
  State<SpreadListTitle> createState() => _SpreadListTitleState();
}

class _SpreadListTitleState extends State<SpreadListTitle> {
  bool isTab = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.title,
            style: TextStylesManager()
                .createHadColorTextStyle("B16", ColorsManager.gray500),
          ),
          onTap: () {
            setState(() {
              isTab = !isTab;
            });
          },
        ),
        if (isTab)
          Container(
            color: ColorsManager.black200,
            // margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Text(
              widget.readMoreText.split(".").join("\n"),
              style: TextStylesManager()
                  .createHadColorTextStyle("R16", ColorsManager.gray500),
            ),
          )
      ],
    );
  }
}
