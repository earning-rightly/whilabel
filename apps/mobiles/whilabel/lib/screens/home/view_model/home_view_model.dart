import 'dart:async';

import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/domain/use_case/sort_archiving_post_use_case.dart';
import 'package:whilabel/screens/home/view_model/home_event.dart';
import 'package:whilabel/screens/home/view_model/home_state.dart';

class HomeViewModel with ChangeNotifier {
  final LoadArchivingPostUseCase _loadArchivingPostUseCase;
  final ArchivingPostRepository _archivingPostRepository;

  HomeViewModel({
    required LoadArchivingPostUseCase loadArchivingPostUseCase,
    required ArchivingPostRepository archivingPostRepository,
  })  : _loadArchivingPostUseCase = loadArchivingPostUseCase,
        _archivingPostRepository = archivingPostRepository;

  HomeState get state => _state;
  HomeState _state = HomeState(
    archivingPosts: [],
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
    List<ArchivingPost> archivingPosts =
        await _loadArchivingPostUseCase.call(listButtonOrder);

    _state = _state.copyWith(archivingPosts: archivingPosts);
    notifyListeners();
  }

  Future<void> _changeButtonOrder(PostButtonOrder listButtonOrder) async {
    print("_changeButtonOrder start");
    _state = state.copyWith(listButtonOrder: listButtonOrder);
    notifyListeners();
    _loadArchivingPost(listButtonOrder);
  }

  Future<void> _deleteArchivingPost(String postId) async {
    await _archivingPostRepository.deleteArchivingPost(postId);

    _loadArchivingPost(PostButtonOrder.LATEST);
  }
}
