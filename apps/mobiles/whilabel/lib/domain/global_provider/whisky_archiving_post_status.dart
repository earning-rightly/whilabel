import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_feature.dart';

part 'whisky_archiving_post_status.freezed.dart';
// part 'whiskyNew_archiving_post_status.g.dart';

@freezed
class WhiskyNewArchivingPostState with _$WhiskyNewArchivingPostState {
  factory WhiskyNewArchivingPostState({
    required String barcode,
    required ArchivingPost archivingPost,
    File? images,
    // required WbBrand wbBrand,
    // required WbDistillery wbDistillery,
    // required TasteFeature tasteFeature,
  }) = _WhiskyNewArchivingPostState;
}

// global로 사용할 예정
// carmeraView에서는 이미지와 위스키 정보를 받아오고
// WhiskeyCritiqueView에서는 DB에 ArchivingPost 저장
// WhiskeyRegisterView에서는 수정후 저장 ------> 고민
class WhiskyNewArchivingPostStatus extends ChangeNotifier {
  // final AppUserRepository _repository;

  // WhiskyNewArchivingPostState get userState => _userState;
  // WhiskyNewArchivingPostState _whiskyNewArchivingPostState = WhiskyNewArchivingPostState();

  // CurrentUserStatus(this._repository) {
  //   updateUserState();
  // }

  WhiskyNewArchivingPostState get state => _state;
  WhiskyNewArchivingPostState _state = WhiskyNewArchivingPostState(
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

  WhiskyNewArchivingPostState getState() {
    return state;
  }
}
