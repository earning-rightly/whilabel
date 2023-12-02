import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/whisky/whisky.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/domain/whisky_brand_distillery/whisky_brand_distillery_repository.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_event.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_state.dart';

class ArchivingPostDetailViewModel with ChangeNotifier {
  final WhiskyBrandDistilleryRepository _whiskyRepository;
  final ArchivingPostRepository _archivingPostRepository;

  ArchivingPostDetailViewModel(
      {required WhiskyBrandDistilleryRepository whiskyBrandDistilleryRepository,
      required ArchivingPostRepository archivingPostRepository})
      : _whiskyRepository = whiskyBrandDistilleryRepository,
        _archivingPostRepository = archivingPostRepository;

  late ArchivingPostDetailState _state = ArchivingPostDetailState(
    whiskyData: Whisky(id: ""),
    distilleryData: Distillery(id: ""),
    currentPostId: "",
  );
  ArchivingPostDetailState get state => _state;

  Future<void> onEvent(ArchivingPostDetailEvnet event,
      {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
            updateUserCritique: updateUserCritique,
            addTasteNoteOnProvider: (tasteNote) async {
              _state = _state.copyWith(tasteNote: tasteNote);
              notifyListeners();
            },
            addStarValueOnProvider: (starValue) async {
              _state = _state.copyWith(starValue: starValue);
              notifyListeners();
            },
            addTasteFeatureOnProvider: (tasteFeature) async {
              _state = _state.copyWith(tasteFeature: tasteFeature);
              notifyListeners();
            })
        .then((_) => {after()});
  }

  Future<Distillery> getDistilleryData(String distilleryId) async {
    final distilleryData =
        await _whiskyRepository.getDistilleryData(distilleryId);

    return distilleryData!;
  }

  Future<Whisky> getInitalData(String barCode, String postId) async {
    final whiskyData =
        await _whiskyRepository.getWhiskyDataWithBarcode(barCode);
    print(whiskyData?.distilleryIds.toString());
    // 데이터 베이스에서 distilleryName이 String이였을 때 사용 했던 코드
    // 현재는 List<String>으로 정상적으로 바뀌어서 사용하지 않음
    //   String test1 = whiskyData?.wbWhisky!.distilleryName ?? "['','']";
    //
    //   List<String> list = test1.split("'");
    //   _whiskyRepository.getDistilleryData(list[1]);
    // }
    if (_state.currentPostId.isEmpty) {
      _state = _state.copyWith(currentPostId: postId);
      notifyListeners();
    }

    return whiskyData!;
  }

// post가 존하기 때문에 상세페이지 이동 가능
  Future<void> updateUserCritique() async {
    ArchivingPost? newArchivingPost =
        await _archivingPostRepository.getArchivingPost(_state.currentPostId);

    newArchivingPost = newArchivingPost!.copyWith(
      starValue: _state.starValue,
      note: _state.tasteNote,
      tasteFeature: _state.tasteFeature,
      modifyAt: Timestamp.now(),
    );
    _archivingPostRepository.updateArchivingPost(newArchivingPost);
  }
}
