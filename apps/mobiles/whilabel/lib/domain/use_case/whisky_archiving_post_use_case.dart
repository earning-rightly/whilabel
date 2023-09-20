import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_feature.dart';

part 'whisky_archiving_post_use_case.freezed.dart';

@freezed
class WhiskyNewArchivingPostUseCaseState
    with _$WhiskyNewArchivingPostUseCaseState {
  factory WhiskyNewArchivingPostUseCaseState({
    required String barcode,
    required ArchivingPost archivingPost,
    File? images,
  }) = _WhiskyNewArchivingPostUseCaseState;
}

/*carmeraView에서는 이미지와 위스키 정보를 받아오고
 WhiskeyCritiqueView에서는 DB에 ArchivingPost 저장 */

class WhiskyNewArchivingPostUseCase extends ChangeNotifier {
  WhiskyNewArchivingPostUseCaseState get state => _state;
  WhiskyNewArchivingPostUseCaseState _state =
      WhiskyNewArchivingPostUseCaseState(
    barcode: "",
    archivingPost: ArchivingPost(
      whiskyId: "",
      barcode: "",
      whiskyName: "",
      postId: "",
      userId: "",
      createAt: Timestamp.now(),
      imageUrl: "",
      starValue: 0,
      note: "",
      tasteFeature: TasteFeature(bodyRate: 0, flavorRate: 0, peatRate: 0),
    ),
  );

  void saveImageFile(File imagePath) {
    _state = _state.copyWith(images: imagePath);
    notifyListeners();
  }

  void saveBarcode(String barcode) {
    _state = _state.copyWith(barcode: barcode);
    notifyListeners();
  }

  void saveTastNote(String tastNote) {
    ArchivingPost archivingPost = _state.archivingPost.copyWith(note: tastNote);
    _state = _state.copyWith(archivingPost: archivingPost);
    notifyListeners();
  }

  void saveStarValue(int starValue) {
    ArchivingPost archivingPost =
        _state.archivingPost.copyWith(starValue: starValue.toDouble());
    _state = _state.copyWith(archivingPost: archivingPost);
    notifyListeners();
  }

  void saveTasteFeature(TasteFeature tasteFeature) {
    ArchivingPost archivingPost =
        _state.archivingPost.copyWith(tasteFeature: tasteFeature);
    _state = _state.copyWith(archivingPost: archivingPost);
    notifyListeners();
  }

  void saveArchivingPost(ArchivingPost archivingPost) {
    _state = _state.copyWith(archivingPost: archivingPost);
    notifyListeners();
  }

  WhiskyNewArchivingPostUseCaseState getState() {
    return state;
  }
}
