import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/post/short_archiving_post.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/domain/use_case/short_archiving_post_use_case.dart';
import 'package:whilabel/domain/use_case/sort_archiving_post_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/screens/home/view_model/home_event.dart';
import 'package:whilabel/screens/home/view_model/home_state.dart';

class HomeViewModel with ChangeNotifier {
  final LoadArchivingPostUseCase _loadArchivingPostUseCase;
  final ArchivingPostRepository _archivingPostRepository;
  final ShortArchivingPostUseCase _shortArchivingPostUseCase;
  final AppUserRepository _appUserRepository;

  HomeViewModel({
    required LoadArchivingPostUseCase loadArchivingPostUseCase,
    required ArchivingPostRepository archivingPostRepository,
    required ShortArchivingPostUseCase shortArchivingPostUseCase,
    required AppUserRepository appUserRepository,
  })  : _loadArchivingPostUseCase = loadArchivingPostUseCase,
        _archivingPostRepository = archivingPostRepository,
        _shortArchivingPostUseCase = shortArchivingPostUseCase,
        _appUserRepository = appUserRepository;

  HomeState get state => _state;
  HomeState _state = HomeState(
    archivingPosts: [],
    listButtonOrder: PostButtonOrder.LATEST, // 처음 초기값은 항상 최근것을 보여주기
    shortArchivingPostMap: {},
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
    List<ArchivingPost> archivingPosts =
        await _loadArchivingPostUseCase.call(appUser!.uid, listButtonOrder);
    Map<String, List<ShortArchivingPost>> shortArchivingPostMap =
        await _shortArchivingPostUseCase.getShortArchivingPostMap(
            uid: appUser.uid);
    // for (String key in shortArchivingPostMap.keys) {
    //   print(shortArchivingPostMap[key]!.first);
    // }

    _state = _state.copyWith(
        archivingPosts: archivingPosts,
        shortArchivingPostMap: shortArchivingPostMap);
    notifyListeners();
  }

  Future<void> _changeButtonOrder(PostButtonOrder listButtonOrder) async {
    print("_changeButtonOrder start");
    _state = state.copyWith(listButtonOrder: listButtonOrder);
    notifyListeners();
    _loadArchivingPost(listButtonOrder);
  }

  Future<void> _deleteArchivingPost(
      String archivingPostId, String userid, String whiskyName) async {
    await _archivingPostRepository.deleteArchivingPost(archivingPostId);
    _shortArchivingPostUseCase.deleteShortArchivingPost(
        whiskyName: whiskyName,
        userid: userid,
        archivingPostId: archivingPostId);

    _loadArchivingPost(PostButtonOrder.LATEST);
  }
}
