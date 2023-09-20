import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/taste/taste_feature.dart';

part 'archiving_post_detail_event.freezed.dart';

@freezed
abstract class ArchivingPostDetailEvnet with _$ArchivingPostDetailEvnet {
  const factory ArchivingPostDetailEvnet.updateUserCritique() =
      UpdateUserCritique;
  const factory ArchivingPostDetailEvnet.addTasteNoteOnProvider(
      String tasteNote) = AddTasteNoteOnProvider;
  const factory ArchivingPostDetailEvnet.addStarValueOnProvider(double value) =
      AddStarValueOnProvider;
  const factory ArchivingPostDetailEvnet.addTasteFeatureOnProvider(
      TasteFeature tasteFeature) = AddTasteFeatureOnProvider;
}
