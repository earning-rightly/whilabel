import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';

part 'home_event.freezed.dart';

@freezed
abstract class HomeEvent with _$HomeEvent {
  const factory HomeEvent.loadArchivingPost(PostButtonOrder postButtonOrder) =
      LoadArchivingPost;
  const factory HomeEvent.changeButtonOrder(PostButtonOrder postButtonOrder) =
      ChangeButtonOrder;
  const factory HomeEvent.deleteArchivingPost(String postId) =
      saveCurrentArchivingPost;
}
