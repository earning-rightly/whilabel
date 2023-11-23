import 'package:whilabel/data/post/same_kind_whisky.dart';
import 'package:whilabel/data/post/short_archiving_post.dart';
import 'package:whilabel/domain/post/same_kind_whisky_repository.dart';

class FirestoreSameKindWhiskyRepositoryImple
    implements SameKindWhiskyRepository {
  final SameKindWhiskyCollectionReference _sameKindWhiskyRef;

  FirestoreSameKindWhiskyRepositoryImple(
      {required SameKindWhiskyCollectionReference sameKindWhiskyRef})
      : _sameKindWhiskyRef = sameKindWhiskyRef;

  @override
  Future<void> deleteShortArchivingPost(
      String whiskyName, String userid, String ArchivingPostId) async {
    // TODO: implement deleteShortArchivingPost
    // final sameKindWhisky = await getSameKindWhisky(userid);
    // Map<String, List<ShortArchivingPost>> sameKindWhiskyMap =
    //     sameKindWhisky.sameKindWhiskyMap.map((key, value) {
    //   return MapEntry(key, value.map((data) => data.copyWith()).toList());
    // });
    // sameKindWhiskyMap[whiskyName]!.removeWhere(
    //     (shortArchivingPost) => shortArchivingPost.postId == ArchivingPostId);

    // final newSameKindWhisky =
    //     sameKindWhisky.copyWith(sameKindWhiskyMap: sameKindWhiskyMap);

    // await _sameKindWhiskyRef.doc(sameKindWhisky.docId).set(newSameKindWhisky);
  }

  @override
  Future<SameKindWhisky> getSameKindWhisky(String userId) async {
    // TODO: implement getSameKindWhisky
    final querySnapshot =
        await _sameKindWhiskyRef.whereUserId(isEqualTo: userId).get();

    if (querySnapshot.docs.isEmpty) {
      return SameKindWhisky(
        docId: "empty",
        userId: userId,
        sameKindWhiskyMap: <String, List<ShortArchivingPost>>{}
      );
    }

    return querySnapshot.docs.first.data;
  }

  @override
  Future<void> insertSameKindWhiskyDoc(SameKindWhisky sameKindWhisky) async {
    // TODO: implement insertSameKindWhiskyDoc
    // throw UnimplementedError();
    _sameKindWhiskyRef.doc(sameKindWhisky.docId).set(sameKindWhisky);
  }

  @override
  Future<void> updatSameKindWhisky(
      String docId, SameKindWhisky sameKindWhisky) async {
    await _sameKindWhiskyRef.doc(docId).set(sameKindWhisky);
  }
  //   final querySnapshot =
  //       await _sameKindWhiskyRef.whereUserId(isEqualTo: userId).get();

  //   final sameKindWhisky = querySnapshot.docs.first.data;
  //   Map<String, List<ShortArchivingPost>> sameKindWhiskyMap =
  //       querySnapshot.docs.first.data.sameKindWhiskyMap.map((key, value) {
  //     return MapEntry(key, value.map((data) => data.copyWith()).toList());
  //   });

  //   // whiskyName이 sameKindWhiskyMap의 key값이면 리스트에 맨뒤에 추가
  //   if (sameKindWhiskyMap.containsKey(shortArchivingPosts.whiskyName)) {
  //     sameKindWhiskyMap[shortArchivingPosts.whiskyName]!
  //         .add(shortArchivingPosts);
  //   } else {
  //     // whiskyName이 sameKindWhiskyMap의 key값이 아니면 새로운 key로 추가
  //     sameKindWhiskyMap[shortArchivingPosts.whiskyName] = [shortArchivingPosts];
  //   }
  //   final newSameKindWhisky =
  //       sameKindWhisky.copyWith(sameKindWhiskyMap: sameKindWhiskyMap);

  //   // SameKindWhisky을 Firestore에 업데이트
  //   await _sameKindWhiskyRef
  //       .doc(newSameKindWhisky.docId)
  //       .set(newSameKindWhisky);
  // }
}
