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
  Future<void> updateArchivingPost(ArchivingPost archivingPost) async {
    final querySnapshot = await _archivingPostRef
        .wherePostId(isEqualTo: archivingPost.postId)
        .get();

    // 쿼리 결과는 반드시 1개만 존재해야 함.
    assert(querySnapshot.docs.length == 1);
    final docId = querySnapshot.docs.first.id;

    _archivingPostRef.doc(docId).set(archivingPost);
  }

  @override
  Future<ArchivingPost?> getArchivingPost(String postId) async {
    final querySnapshot =
        await _archivingPostRef.wherePostId(isEqualTo: postId).get();
    return querySnapshot.docs.first.data;
  }
}
