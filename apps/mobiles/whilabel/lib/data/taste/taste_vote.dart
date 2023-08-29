import 'package:whilabel/data/taste/taste_tag.dart';

class TasteVote {
  TasteVote({
    required this.tasteTag,
    required this.voteCount
  });

  final TasteTag tasteTag;
  final int voteCount;
}