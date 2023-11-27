import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';

class LoadArchivingPostsUseCase {
  final ArchivingPostRepository archivingPostRepository;

  LoadArchivingPostsUseCase({
    required this.archivingPostRepository,
  });

  Future<List<ArchivingPost>> getListArchivingPost(
      String uerId, PostButtonOrder postButtonOrder) async {
    List<ArchivingPost> archivingPosts =
        await archivingPostRepository.getArchivingPosts(uerId); //

    // getGridArchivingPost(archivingPosts: archivingPosts, uid: "123");

    switch (postButtonOrder) {
      case PostButtonOrder.LATEST:
        archivingPosts.sort(
          (ArchivingPost a, ArchivingPost b) =>
              a.createAt!.compareTo(b.createAt!),
        );
        archivingPosts = archivingPosts.reversed.toList();
        break;

      case PostButtonOrder.OLDEST:
        archivingPosts.sort(
          (ArchivingPost a, ArchivingPost b) =>
              a.createAt!.compareTo(b.createAt!),
        );
        break;

      case PostButtonOrder.HiGHEST_RATING:
        archivingPosts.sort(
          (ArchivingPost a, ArchivingPost b) =>
              a.starValue.compareTo(b.starValue),
        );
        archivingPosts = archivingPosts.reversed.toList();
        break;

      case PostButtonOrder.LOWEST_RATiNG:
        archivingPosts.sort(
          (ArchivingPost a, ArchivingPost b) =>
              a.starValue.compareTo(b.starValue),
        );
        break;

      default:
        debugPrint("postButtonOrder 값empty 입니다.");
        break;

      // return Pair(false, false);
    }
    return archivingPosts;
  }


   Future <Map<String,List<ArchivingPost>>> getGridArchivingPost(
      {required List<ArchivingPost> archivingPosts}) async {

     // 깊은 복사를 사용해서 파라미터로 받는 데이터를 건들지 않게 한다.
     // 언제나 archivingPosts의 원소들을 최신 순으로 정렬한 다음에 데이터 정렬 시작
     List<ArchivingPost> _archivingPosts = [...archivingPosts];
     _archivingPosts.sort(
           (ArchivingPost a, ArchivingPost b) =>
           a.createAt!.compareTo(b.createAt!),
     );
     _archivingPosts = _archivingPosts.reversed.toList();

     // 1차원 리스트를 2차원 리스트로 변환 하는데 2차원 리스트에 원소를 whiksyName으로 그룹핑한다.
     Map<String,List<ArchivingPost>> groupedArchivingPosts = _archivingPosts
         .groupBy((_archivingPost) => _archivingPost.whiskyName)
         .toMap();

    return groupedArchivingPosts;
  }


}
