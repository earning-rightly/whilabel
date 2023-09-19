import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_feature.dart';

part 'whisky_critique_state.freezed.dart';

@freezed
class WhiskyCritiqueState with _$WhiskyCritiqueState {
  factory WhiskyCritiqueState({
    required String whiskyName,
    required String strength,
    required double starValue,
    String? tasteNote,
    TasteFeature? tasteFeature,
    File? image,
    String? whiskyLocation,
    ArchivingPost? archivingPost,
  }) = _WhiskyCritiqueState;
}
