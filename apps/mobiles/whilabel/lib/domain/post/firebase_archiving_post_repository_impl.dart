import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';

class FirestoreArchivingPostRepositoryImple implements ArchivingPostRepository {
  final ArchivingPostCollectionReference _archivingPostRef;

  FirestoreArchivingPostRepositoryImple(
    this._archivingPostRef,
  );
  @override
  Future<void> insertArchivingPost(ArchivingPost archivingPost) async {
    _archivingPostRef.doc(archivingPost.postId).set(archivingPost);
  }

  @override
  Future<List<ArchivingPost>> getArchivingPosts(String userID) async {
    List<ArchivingPost> archivingPostList = [];
    final querySnapshot =
        await _archivingPostRef.whereUserId(isEqualTo: userID).get();

    for (ArchivingPostQueryDocumentSnapshot eachSnaoshot
        in querySnapshot.docs) {
      final ArchivingPost data = eachSnaoshot.data;
      archivingPostList.add(data);
    }
    return archivingPostList;
  }

  @override
  Future<ArchivingPost?> getArchivingPost(String uid, String postId) {
    // TODO: implement getArchivingPost
    throw UnimplementedError();
  }
}
