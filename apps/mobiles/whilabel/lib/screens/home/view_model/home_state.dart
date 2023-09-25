import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  factory HomeState({
    required List<ArchivingPost> archivingPosts,
    required PostButtonOrder listButtonOrder,
    ArchivingPost? currentArchivingPost,
  }) = _HomeState;
}
