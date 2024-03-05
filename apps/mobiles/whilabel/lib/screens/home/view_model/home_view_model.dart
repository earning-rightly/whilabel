import 'dart:async';
import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
import 'package:whilabel/domain/repository/post/archiving_post_repository.dart';
import 'package:whilabel/domain/repository/user/app_user_repository.dart';
import 'package:whilabel/domain/use_case/archiving_post/load_archiving_posts_use_case.dart';
import 'package:whilabel/screens/home/view_model/home_event.dart';
import 'package:whilabel/screens/home/view_model/home_state.dart';

class HomeViewModel with ChangeNotifier {
  final LoadArchivingPostsUseCase _loadArchivingPostUseCase;
  final ArchivingPostRepository _archivingPostRepository;
  // todo AppUserRepository 말고 currentUserSate으로 변경
  final AppUserRepository _appUserRepository;

  HomeViewModel({
    required LoadArchivingPostsUseCase loadArchivingPostUseCase,
    required ArchivingPostRepository archivingPostRepository,
    required AppUserRepository appUserRepository,
  })  : _loadArchivingPostUseCase = loadArchivingPostUseCase,
        _archivingPostRepository = archivingPostRepository,
        _appUserRepository = appUserRepository;

  HomeState get state => _state;
  HomeState _state = HomeState(

    listTypeArchivingPosts: [],
    gridTypeArchivingPost: {},
    listButtonOrder: PostButtonOrder.LATEST, // 처음 초기값은 항상 최근것을 보여주기
  );

  Future<void> onEvent(HomeEvent event, {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
            loadArchivingPost: _loadArchivingPost,
            changeButtonOrder: _changeButtonOrder,
            deleteArchivingPost: _deleteArchivingPost)
        .then((_) => {after()});
  }

  Future<void> _loadArchivingPost(PostButtonOrder listButtonOrder) async {
    final appUser = await _appUserRepository.getCurrentUser();
    if (appUser?.uid != null) {

      // 리스뷰에서 사용될 데이타
      List<ArchivingPost> listTypeArchivingPosts =
          await _loadArchivingPostUseCase.getListArchivingPost(appUser!.uid, listButtonOrder);
      // 그리드 뷰에서 사용될 archivingPosts data
      Map<String,List<ArchivingPost>> gridTypeArchivingPosts =
      await _loadArchivingPostUseCase.getGridArchivingPost(archivingPosts: listTypeArchivingPosts);


      _state = _state.copyWith(
          listTypeArchivingPosts: listTypeArchivingPosts,
          gridTypeArchivingPost: gridTypeArchivingPosts,
      );

      notifyListeners();
    }
    // for (String key in shortArchivingPostMap.keys) {
    //   print(shortArchivingPostMap[key]!.first);
    // }
  }

  Future<void> _changeButtonOrder(PostButtonOrder listButtonOrder) async {
    debugPrint("_changeButtonOrder start");
    _state = state.copyWith(listButtonOrder: listButtonOrder);
    notifyListeners();
    _loadArchivingPost(listButtonOrder);
  }

  Future<void> _deleteArchivingPost(
      String archivingPostId, String userid, String whiskyName) async {
    await _archivingPostRepository.deleteArchivingPost(archivingPostId);


    _loadArchivingPost(PostButtonOrder.LATEST);
  }
}
