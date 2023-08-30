import 'package:whilabel/data/taste/taste_tag.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'taste_vote.freezed.dart';
part 'taste_vote.g.dart';

@freezed
class TasteVote with _$TasteVote {
  factory TasteVote({
    required TasteTag tasteTag,
    required int voteCount,
  }) = _TasteVote;

  factory TasteVote.fromJson(Map<String, dynamic> json) =>
      _$TasteVoteFromJson(json);
}
