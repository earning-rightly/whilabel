import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';

part 'whisky_critique_state.freezed.dart';

@freezed
class WhiskyCritiqueState with _$WhiskyCritiqueState {
  factory WhiskyCritiqueState({
    required WhiskyNewArchivingPostUseCaseState
        whiskyNewArchivingPostUseCaseState,
    required double starValue,
    String? tasteNote,
    TasteFeature? tasteFeature,
  }) = _WhiskyCritiqueState;
}
