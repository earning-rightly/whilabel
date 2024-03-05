import 'package:firebase_storage/firebase_storage.dart';
import 'package:whilabel/data/post/archiving_post.dart';

import 'archiving_post_repository.dart';

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
  Future<ArchivingPost?> getArchivingPost(String postId) async {
    final querySnapshot =
        await _archivingPostRef.wherePostId(isEqualTo: postId).get();
    return querySnapshot.docs.first.data;
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

// https://firebasestorage.googleapis.com/v0/b/whilabel.appspot.com/o/
// post%2Farchiving_post%2Fkakao:2964055896%2F56d7fc10-c497-1cfd-899b-e5bdb25866f5%5Ekakao:2964055896%7D.jpg
// ?alt=media&token=5d74b9da-6a6d-4c91-a8c5-e01f3e160fb6
  @override
  Future<void> deleteArchivingPost(String postId) async {
    final querySnapshot =
        await _archivingPostRef.wherePostId(isEqualTo: postId).get();
    ArchivingPost archivingPost = querySnapshot.docs.first.data;
    String filePath = archivingPost.imageUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/whilabel.appspot.com/o/'),
        '');

    // archivingPost.
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    filePath = filePath.replaceAll(new RegExp(r'%5E'), '^');
    filePath = filePath.replaceAll(new RegExp(r"%7D"), '}');

    final storageRef = FirebaseStorage.instance.ref();
    final desertRef = storageRef.child(filePath);

    try {
      await desertRef.delete();
    } catch (e) {
      print("$e");
      print(filePath);
    }
    _archivingPostRef.doc(postId).delete().then(
          (doc) => print("Document deleted"),
          onError: (e) => print("Error updating document $e"),
        );
  }
}
