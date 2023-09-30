import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/post/same_kind_whisky.dart';
import 'package:whilabel/data/post/short_archiving_post.dart';

abstract class SameKindWhiskyRepository {
  Future<void> insertSameKindWhiskyDoc(SameKindWhisky sameKindWhisky);
  Future<void> updatSameKindWhisky(String docId, SameKindWhisky sameKindWhisky);
  Future<SameKindWhisky> getSameKindWhisky(String userId);
  // Future<ArchivingPost?> getArchivingPost(String Postid);
  // ArchivingPost를 삭제하면 같은 postId 삭제
  Future<void> deleteShortArchivingPost(
      String whiskyName, String docId, String postId);
}
