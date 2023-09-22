import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/screens/home/view_model/home_state.dart';

class HomeViewModel with ChangeNotifier {
  final ArchivingPostRepository _archivingPostRepository;
  HomeViewModel({required ArchivingPostRepository archivingPostRepository})
      : _archivingPostRepository = archivingPostRepository;

  HomeState get state => _state;
  HomeState _state = HomeState(archivingPosts: []);

  Future<void> loadArchivingPost(String uid) async {
    final List<ArchivingPost> archivingPosts =
        await _archivingPostRepository.getArchivingPosts(uid);

    _state = _state.copyWith(archivingPosts: archivingPosts);
    notifyListeners();
  }
}
