import 'package:whilabel/data/post/archiving_post.dart';

abstract class SameKindWhiskyRepository {
  Future<void> insertNewData(ArchivingPost archivingPost);
  Future<void> updateDoc(ArchivingPost archivingPost);
  Future<List<ArchivingPost>> getData(String uid);
  // Future<ArchivingPost?> getArchivingPost(String Postid);
  Future<void> deleteData(String postId);
}
