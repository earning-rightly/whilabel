import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/taste/taste_feature.dart';

part 'whisky_critique_event.freezed.dart';

@freezed
abstract class WhiskyCritiqueEvnet with _$WhiskyCritiqueEvnet {
  const factory WhiskyCritiqueEvnet.saveArchivingPostOnDb(
          double starValue, String note, TasteFeature tasteFeature) =
      SaveArchivingPostOnDb;
  const factory WhiskyCritiqueEvnet.addTastNoteOnProvider(String tasteNote) =
      AddTastNoteOnProvider;
  const factory WhiskyCritiqueEvnet.addStarValueOnProvider(double value) =
      AddStarValueOnProvider;
  const factory WhiskyCritiqueEvnet.addTasteFeatureOnProvider(
      TasteFeature tasteFeature) = AddTasteFeatureOnProvider;
}
