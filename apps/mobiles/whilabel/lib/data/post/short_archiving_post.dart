import 'package:freezed_annotation/freezed_annotation.dart';

part 'short_archiving_post.freezed.dart';
part 'short_archiving_post.g.dart';

// ArchivingPost에 데이터 중 일부르르 져와서 가공한다.
// ShortArchivingPost의 postId는 원본 ArchivingPost의 postId입니다
@freezed
class ShortArchivingPost with _$ShortArchivingPost {
  factory ShortArchivingPost({
    required String imageUrl,
    required String whiskyName,
    required String postId,
  }) = _ShortArchivingPost;

  factory ShortArchivingPost.fromJson(Map<String, dynamic> json) =>
      _$ShortArchivingPostFromJson(json);
}
