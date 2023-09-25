import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/provider_manager.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/create_star_rating.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';
import 'package:whilabel/screens/_global/widgets/text_field_length_counter.dart';
import 'package:whilabel/screens/_global/widgets/whilabel_divier.dart';
import 'package:whilabel/screens/home/grid/widgets/app_bars.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_event.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_view_model.dart';
import 'package:whilabel/screens/whisky_critique/widget/critique_view_whisky_Info_footer.dart';
import 'package:whilabel/screens/whisky_critique/widget/flavor_recorder.dart';

// ignore: must_be_immutable
class WhiskyCritiqueView extends StatelessWidget {
  WhiskyCritiqueView({super.key});

  final tastingNoteTextContoller = TextEditingController();
  final maxTastingNoteLenght = 1000;

  @override
  Widget build(BuildContext context) {
    const double initalStarValue = 3;
    return Scaffold(
      appBar: createScaffoldAppBar(context, SvgIconPath.close, "나의 평가"),
      body: ChangeNotifierProvider<WhiskyCritiqueViewModel>(
        create: (BuildContext context) =>
            ProvidersManager.callWhiskyCritiqueViewModel(),
        child: SafeArea(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Builder(
                builder: (context) {
                  final viewModel = context.watch<WhiskyCritiqueViewModel>();
                  return SingleChildScrollView(
                    padding: WhilabelPadding.basicPadding,
                    scrollDirection: Axis.vertical,
                    child: SizedBox(
                      height: MediaQuery.of(context).size.width * 2.1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 104,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("위스키를 평가해주세요",
                                    style: TextStylesManager.bold20),
                                SizedBox(height: WhilabelSpacing.spac8),
                                // 별점
                                Text(
                                  "탭해서 평가해 주세요",
                                  style: TextStylesManager()
                                      .createHadColorTextStyle(
                                          "B14", ColorsManager.gray),
                                ),
                                SizedBox(height: WhilabelSpacing.spac16),
                                createStarRating(initalStarValue, false,
                                    onRatingUpdate: (double value) {
                                  viewModel.onEvent(WhiskyCritiqueEvnet
                                      .addStarValueOnProvider(value));
                                })
                              ],
                            ),
                          ),
                          SizedBox(height: (WhilabelSpacing.spac24)),
                          const BasicDivider(),
                          SizedBox(height: (WhilabelSpacing.spac24)),
                          // 테이스팅 노트
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "테이스팅 노트 (선택))",
                                style: TextStylesManager.bold16,
                              ),
                              SizedBox(height: WhilabelSpacing.spac12),
                              TextField(
                                style: TextStylesManager()
                                    .createHadColorTextStyle(
                                        "R16", ColorsManager.gray500),
                                decoration: createLargeTextFieldStyle(""),
                                controller: tastingNoteTextContoller,
                                scrollPadding:
                                    EdgeInsets.symmetric(vertical: 20),
                                maxLines: 7,
                                onChanged: (text) {
                                  viewModel.onEvent(
                                    WhiskyCritiqueEvnet.addTastNoteOnProvider(
                                        text),
                                  );
                                },
                                maxLength: maxTastingNoteLenght,
                                buildCounter: (
                                  _, {
                                  required currentLength,
                                  maxLength,
                                  required isFocused,
                                }) =>
                                    TextFieldLengthCounter(
                                  currentLength: currentLength,
                                  maxLength: maxLength!,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: (WhilabelSpacing.spac24)),
                          const BasicDivider(),
                          SizedBox(height: (WhilabelSpacing.spac24)),
                          // 맛 평가
                          FlavorRecorder(
                            onChangeBodyRate: (double value) {
                              TasteFeature tasteFeature = viewModel
                                  .state.tasteFeature!
                                  .copyWith(bodyRate: value.toInt());

                              viewModel.onEvent(
                                WhiskyCritiqueEvnet.addTasteFeatureOnProvider(
                                    tasteFeature),
                              );
                            },
                            onChangeFlavorRate: (double value) {
                              TasteFeature tasteFeature = viewModel
                                  .state.tasteFeature!
                                  .copyWith(flavorRate: value.toInt());

                              viewModel.onEvent(
                                WhiskyCritiqueEvnet.addTasteFeatureOnProvider(
                                    tasteFeature),
                              );
                            },
                            onChangePeatRate: (double value) {
                              TasteFeature tasteFeature = viewModel
                                  .state.tasteFeature!
                                  .copyWith(peatRate: value.toInt());

                              viewModel.onEvent(
                                WhiskyCritiqueEvnet.addTasteFeatureOnProvider(
                                    tasteFeature),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CritiqueViewWhiskyInfoFooter(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
