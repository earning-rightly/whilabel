import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/screens/_global/widgets/text_field_length_counter.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_event.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_view_model.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/create_star_rating.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';
import 'package:whilabel/screens/whisky_critique/widget/flavor_recorder.dart';

// ignore: must_be_immutable
class UserCritiqueContainer extends StatelessWidget {
  final bool isModify;
  final TextEditingController tasteNoteController;
  final TasteFeature initalTasteFeature;
  final double initalStarValue;
  int tasteNoteMaxLine = 2;
  UserCritiqueContainer({
    Key? key,
    required this.isModify,
    required this.tasteNoteController,
    required this.initalTasteFeature,
    required this.initalStarValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArchivingPostDetailViewModel>();

    // if (isModify)
    return Container(
      padding: EdgeInsets.only(
        top: 15,
        bottom: 15,
        left: 10,
        right: 10,
      ),
      decoration: BoxDecoration(
        color: isModify ? ColorsManager.black200 : ColorsManager.black200,
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
        border:
            isModify ? Border.all(width: 2, color: ColorsManager.orange) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("별점", style: TextStylesManager.bold14),
          createStarRating(initalStarValue, !isModify,
              onRatingUpdate: (starValue) {
            print("change StarValue $starValue");
            viewModel.onEvent(
              ArchivingPostDetailEvnet.addStarValueOnProvider(starValue),
            );
          }),
          SizedBox(height: 20),
          Text("테이스팅 노트", style: TextStylesManager.bold14),
          TextFormField(
            decoration: createLargeTextFieldStyle("당신의 의견을 기다릴게요"),
            // initialValue: tasteNoteController,
            controller: tasteNoteController,
            maxLines: isModify ? 7 : tasteNoteMaxLine,
            style: isModify
                ? TextStylesManager.regular16
                : TextStylesManager.createHadColorTextStyle(
                    "R16", ColorsManager.gray200),
            enabled: isModify,
            maxLength: 1000,
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

            onChanged: (text) {
              viewModel.onEvent(
                ArchivingPostDetailEvnet.addTasteNoteOnProvider(
                    tasteNoteController.text),
              );
            },
          ),
          SizedBox(height: WhilabelSpacing.space24),
          Text("맛 평가 (선택))", style: TextStylesManager.bold14),
          SizedBox(height: WhilabelSpacing.space16),
          Container(
            decoration: BoxDecoration(
              color: ColorsManager.black100,
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: FlavorRecorder(
              disable: !isModify,
              tastFeature: initalTasteFeature,
              onChangeBodyRate: (double value) {
                TasteFeature tasteFeature = viewModel.state.tasteFeature == null
                    ? initalTasteFeature.copyWith(bodyRate: value.toInt())
                    : viewModel.state.tasteFeature!
                        .copyWith(bodyRate: value.toInt());

                viewModel.onEvent(
                  ArchivingPostDetailEvnet.addTasteFeatureOnProvider(
                      tasteFeature),
                );
              },
              onChangeFlavorRate: (double value) {
                TasteFeature tasteFeature = viewModel.state.tasteFeature == null
                    ? initalTasteFeature.copyWith(flavorRate: value.toInt())
                    : viewModel.state.tasteFeature!
                        .copyWith(flavorRate: value.toInt());

                viewModel.onEvent(
                  ArchivingPostDetailEvnet.addTasteFeatureOnProvider(
                      tasteFeature),
                );
              },
              onChangePeatRate: (double value) {
                TasteFeature tasteFeature = viewModel.state.tasteFeature == null
                    ? initalTasteFeature.copyWith(peatRate: value.toInt())
                    : viewModel.state.tasteFeature!
                        .copyWith(peatRate: value.toInt());

                // .copyWith(peatRate: value.toInt());

                viewModel.onEvent(
                  ArchivingPostDetailEvnet.addTasteFeatureOnProvider(
                      tasteFeature),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
