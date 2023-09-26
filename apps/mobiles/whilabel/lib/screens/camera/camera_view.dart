import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:whilabel/mock_data/mock_camera_route.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/image_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';

class CameraView extends StatelessWidget {
  CameraView({super.key});
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    final suggestions = List.generate(10, (index) => 'suggestion $index');

    return SafeArea(
        child: Padding(
      padding: WhilabelPadding.onlyHoizBasicPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(top: 32),
              child: Text(
                "위스키 기록",
                style: TextStylesManager()
                    .createHadColorTextStyle("B24", ColorsManager.gray500),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SizedBox(
              child: Column(
                children: [
                  Image.asset(
                    cameraViewPngImage,
                  ),
                  SizedBox(height: WhilabelSpacing.spac32),
                  Text(
                    "오늘 마신 위시키를 기록해볼까요?",
                    style: TextStylesManager()
                        .createHadColorTextStyle("B20", ColorsManager.gray500),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: WhilabelSpacing.spac24),
                  Row(
                    children: [
                      Expanded(flex: 10, child: SizedBox()),
                      Expanded(
                        flex: 34,
                        child: LongTextButton(
                          buttonText: "위스키 기록하기",
                          color: ColorsManager.brown100,
                          onPressedFunc: () {
                            // todo 테스트로 사용할 루트 나중에 다시 바꿀예정
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MockCameraRoute(),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(flex: 10, child: SizedBox()),
                    ],
                  ),
                  SearchField(
                    searchStyle: TextStylesManager()
                        .createHadColorTextStyle("B16", ColorsManager.gray500),
                    // suggestions: countries
                    //     .map(
                    //       (e) => SearchFieldListItem<Country>(
                    //         e.name,
                    //         item: e,
                    //         // Use child to show Custom Widgets in the suggestions
                    //         // defaults to Text widget
                    //         child: Padding(
                    //           padding: const EdgeInsets.all(8.0),
                    //           child: Row(
                    //             children: [
                    //               CircleAvatar(
                    //                 backgroundImage: NetworkImage(e.flag),
                    //               ),
                    //               SizedBox(
                    //                 width: 10,
                    //               ),
                    //               Text(
                    //                 e.name,
                    //                 style: TextStylesManager()
                    //                     .createHadColorTextStyle(
                    //                         "B16", ColorsManager.black100),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     )
                    //     .toList(),

                    // -------------
                    key: const Key('searchfield'),
                    focusNode: focus,
                    suggestionState: Suggestion.expand,
                    onSuggestionTap: (SearchFieldListItem<String> x) {
                      focus.unfocus();
                    },

                    suggestions: suggestions
                        .map((e) => SearchFieldListItem<String>(e,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(e,
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.red)),
                            )))
                        .toList(),
                    onSearchTextChanged: (query) {
                      final filter = suggestions
                          .where((element) => element
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                          .toList();
                      return filter
                          .map((e) => SearchFieldListItem<String>(e,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(e,
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.red)),
                              )))
                          .toList();
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}

List<Country> countries = [
  for (int i = 0; i < 4; i++) Country(name: "1000$i", flag: "한국", num: i)
];

class Country {
  final String name;
  final int num;
  final String flag;
  Country({
    required this.name,
    required this.num,
    required this.flag,
  });
}
