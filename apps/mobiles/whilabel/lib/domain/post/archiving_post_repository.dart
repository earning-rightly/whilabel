import 'package:whilabel/data/post/archiving_post.dart';

abstract class ArchivingPostRepository {
  Future<void> insertArchivingPost(ArchivingPost archivingPost);
  Future<void> updateArchivingPost(ArchivingPost archivingPost);
  Future<List<ArchivingPost>> getArchivingPosts(String uid);
  Future<ArchivingPost?> getArchivingPost(String id);
  Future<void> deleteArchivingPost(String postId);
}
