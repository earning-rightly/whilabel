import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 15,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: isModify ? ColorsManager.black200 : ColorsManager.black200,
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        border:
            isModify ? Border.all(width: 2, color: ColorsManager.orange) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("별점", style: TextStylesManager.bold14),
          const SizedBox(height: 8),
          createStarRating(initalStarValue, !isModify,
              onRatingUpdate: (starValue) {
            debugPrint("change StarValue $starValue");
            viewModel.onEvent(
              ArchivingPostDetailEvnet.addStarValueOnProvider(starValue),
            );
          }),
           SizedBox(height:  WhilabelSpacing.space24.h),
          const Text("테이스팅 노트", style: TextStylesManager.bold14),
          const SizedBox(height: 8),
          if (isModify)
            TextFormField(
              decoration: createLargeTextFieldStyle("당신의 의견을 기다릴게요"),
              // initialValue: tasteNoteController,
              controller: tasteNoteController,
              maxLines: 7,
              style: TextStylesManager.regular16,
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
            )
          else
            Text(
                tasteNoteController.text,
                style: TextStylesManager.createHadColorTextStyle("R16", ColorsManager.gray200)
            )
          ,
          SizedBox(height: WhilabelSpacing.space24.h),
          const Text("맛 평가", style: TextStylesManager.bold14),
          SizedBox(height: WhilabelSpacing.space16),
          Container(
            decoration: const BoxDecoration(
              color: ColorsManager.black100,
              borderRadius: BorderRadius.all(
                Radius.circular(16),
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
