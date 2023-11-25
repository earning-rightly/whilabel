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


   Future <List<List<ArchivingPost>>> getGridArchivingPost(
      {required List<ArchivingPost> archivingPosts}) async {
    // final sameKindWhisky =
    // await _sameKindWhiskyRepository.getSameKindWhisky(uid);


    //  dynamic을 사용해서 List<ArchivingPost>와 modifyAt을 추가해서
    // grid view에서 최근에 추가한 위스키가 커버 사진이 되고 최근에 먹은 위스키 종류가 맨 위에 올라오게 하자
    // List<List<ArchivingPost>> result = [];
    // sameKindWhisky.sameKindWhiskyMap.forEach((key, value) {
    //   if (value.isNotEmpty) {
    //     result[key] = value;
    //   }
    // });

    // for (ArchivingPost archivingPost in archivingPosts){
    //   if (archivingPost.whiskyName in result.is.)
    // }
    List<List<ArchivingPost>> groupedArchivingPosts = archivingPosts
        .groupBy((archivingPost) => archivingPost.whiskyName)
        .values
        .toList();

    for (List<ArchivingPost> groupedArchivingPost in groupedArchivingPosts) {
      // groupedArchivingPost를 ArchivingPost.creatAt으로 정렬합니다.
      groupedArchivingPost.sort((a, b) => a.createAt!.compareTo(b.createAt!));
    }

    for (List<ArchivingPost> a in groupedArchivingPosts){
      for (ArchivingPost aa in a)
        print("whiskey creatAt ==> ${aa.whiskyName} /${DateTime.parse(aa.createAt!.toDate().toString())}");

      // print("정렬된 위스키 이름  ==> ${aa.createAt}", );


    }


    return groupedArchivingPosts;
  }

  int compareStarValue(ArchivingPost a, ArchivingPost b) {
    // score를 기준으로 정렬
    int scoreComparison = a.starValue.compareTo(b.starValue);

    return scoreComparison;

    // score가 같으면 age를 기준으로 정렬
    // int ageComparison = a.createAt!.compareTo(b.createAt!);
    // if (ageComparison != 0) {
    //   return ageComparison;
    // }

    // // score와 age가 같으면 birth를 기준으로 정렬
    // return a.birth.compareTo(b.birth);
  }
}
