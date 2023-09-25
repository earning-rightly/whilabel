import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';

class LoadArchivingPostUseCase {
  final ArchivingPostRepository archivingPostRepository;
  final CurrentUserStatus currentUserStatus;
  LoadArchivingPostUseCase({
    required this.archivingPostRepository,
    required this.currentUserStatus,
  });

  Future<List<ArchivingPost>> call(
    PostButtonOrder postButtonOrder,
  ) async {
    final appUser = await currentUserStatus.getAppUser();
    List<ArchivingPost> archivingPosts =
        await archivingPostRepository.getArchivingPosts(appUser!.uid); //

    switch (postButtonOrder) {
      case PostButtonOrder.LATEST:
        archivingPosts.sort(
          (ArchivingPost a, ArchivingPost b) =>
              a.createAt!.compareTo(b.createAt!),
        );
        archivingPosts = archivingPosts.reversed.toList();

        break;
      case PostButtonOrder.OLDES:
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
