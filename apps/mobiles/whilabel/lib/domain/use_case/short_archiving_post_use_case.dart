import 'package:flutter/foundation.dart';
import 'package:whilabel/data/post/same_kind_whisky.dart';
import 'package:whilabel/data/post/short_archiving_post.dart';
import 'package:whilabel/domain/post/same_kind_whisky_repository.dart';
import 'package:uuid/uuid.dart';

class ShortArchivingPostUseCase extends ChangeNotifier {
  final SameKindWhiskyRepository _sameKindWhiskyRepository;

  ShortArchivingPostUseCase({
    required SameKindWhiskyRepository sameKindWhiskyRepository,
  }) : _sameKindWhiskyRepository = sameKindWhiskyRepository;

  void creatSameKindWhiskyDoc({required String userId}) {
    final uuid = Uuid();

    String docId = "${uuid.v1()}^${userId}}";

    final sameKindWhisky =
        SameKindWhisky(docId: docId, userId: userId, sameKindWhiskyMap: {});
    _sameKindWhiskyRepository.insertSameKindWhiskyDoc(sameKindWhisky);
  }

  Future<void> addShortArchivingPost(
      {required String userId,
      required String whiskyName,
      required String imageUrl,
      required String postId}) async {
    final shortArchivingPost = ShortArchivingPost(
        imageUrl: imageUrl, postId: postId, whiskyName: whiskyName);

    final SameKindWhisky sameKindWhisky =
        await _sameKindWhiskyRepository.getSameKindWhisky(userId);

    // final sameKindWhisky = querySnapshot.docs.first.data;
    Map<String, List<ShortArchivingPost>> sameKindWhiskyMap =
        sameKindWhisky.sameKindWhiskyMap.map((key, value) {
      return MapEntry(key, value.map((data) => data.copyWith()).toList());
    });

    // whiskyName이 sameKindWhiskyMap의 key값이면 리스트에 맨뒤에 추가
    if (sameKindWhiskyMap.containsKey(whiskyName)) {
      sameKindWhiskyMap[whiskyName]!.insert(0, shortArchivingPost);
    } else {
      // whiskyName이 sameKindWhiskyMap의 key값이 아니면 새로운 key로 추가
      sameKindWhiskyMap[whiskyName] = [shortArchivingPost];
    }
    final newSameKindWhisky =
        sameKindWhisky.copyWith(sameKindWhiskyMap: sameKindWhiskyMap);

    _sameKindWhiskyRepository.updatSameKindWhisky(
        newSameKindWhisky.docId, newSameKindWhisky);
  }

  Future<Map<String, List<ShortArchivingPost>>> getShortArchivingPostMap(
      {required String uid}) async {
    final sameKindWhisky =
        await _sameKindWhiskyRepository.getSameKindWhisky(uid);

    Map<String, List<ShortArchivingPost>> result = {};
    sameKindWhisky.sameKindWhiskyMap.forEach((key, value) {
      if (value.isNotEmpty) {
        result[key] = value;
      }
    });

    return result;
  }

  Future<void> deleteShortArchivingPost(
      {required String whiskyName,
      required String userid,
      required String archivingPostId}) async {
    final sameKindWhisky =
        await _sameKindWhiskyRepository.getSameKindWhisky(userid);
    Map<String, List<ShortArchivingPost>> sameKindWhiskyMap =
        sameKindWhisky.sameKindWhiskyMap.map((key, value) {
      return MapEntry(key, value.map((data) => data.copyWith()).toList());
    });
    sameKindWhiskyMap[whiskyName]!.removeWhere(
        (shortArchivingPost) => shortArchivingPost.postId == archivingPostId);

    final newSameKindWhisky =
        sameKindWhisky.copyWith(sameKindWhiskyMap: sameKindWhiskyMap);
    // updatSameKindWhisky를 그대로 사용
    _sameKindWhiskyRepository.updatSameKindWhisky(
        newSameKindWhisky.docId, newSameKindWhisky);
  }
}
