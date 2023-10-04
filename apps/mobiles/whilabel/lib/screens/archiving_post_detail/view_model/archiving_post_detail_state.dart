import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/data/whisky/whisky.dart';

part 'archiving_post_detail_state.freezed.dart';

@freezed
class ArchivingPostDetailState with _$ArchivingPostDetailState {
  factory ArchivingPostDetailState({
    required Whisky whiskyData,
    required Distillery distilleryData,
    required String currentPostId,
    double? starValue,
    String? tasteNote,
    TasteFeature? tasteFeature,
  }) = _ArchivingPostDetailState;
}
