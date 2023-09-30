import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/post/short_archiving_post.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/domain/use_case/short_archiving_post_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';

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
  final ArchivingPostRepository _archivingPostRepository;
  final AppUserRepository _appUserRepository;
  final ShortArchivingPostUseCase _shortArchivingPostUseCase;
  WhiskyNewArchivingPostUseCase({
    required ArchivingPostRepository archivingPostRepository,
    required AppUserRepository appUserRepository,
    required ShortArchivingPostUseCase shortArchivingPostUseCase,
  })  : _archivingPostRepository = archivingPostRepository,
        _appUserRepository = appUserRepository,
        _shortArchivingPostUseCase = shortArchivingPostUseCase;

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

  void storeImageFile(File imagePath) {
    _state = _state.copyWith(images: imagePath);
    notifyListeners();
  }

  void storeBarcode(String barcode) {
    _state = _state.copyWith(barcode: barcode);
    notifyListeners();
  }

  void storeTasteNote(String tastNote) {
    ArchivingPost archivingPost = _state.archivingPost.copyWith(note: tastNote);
    _state = _state.copyWith(archivingPost: archivingPost);
    notifyListeners();
  }

  void storeStarValue(double starValue) {
    ArchivingPost archivingPost =
        _state.archivingPost.copyWith(starValue: starValue.toDouble());
    _state = _state.copyWith(archivingPost: archivingPost);
    notifyListeners();
  }

  void storeTasteFeature(TasteFeature tasteFeature) {
    ArchivingPost archivingPost =
        _state.archivingPost.copyWith(tasteFeature: tasteFeature);
    _state = _state.copyWith(archivingPost: archivingPost);
    notifyListeners();
  }

  void storeArchivingPost(ArchivingPost archivingPost) {
    _state = _state.copyWith(archivingPost: archivingPost);
    notifyListeners();
  }

  WhiskyNewArchivingPostUseCaseState getState() {
    return state;
  }

  Future<void> SaveNewArchivingPost(String uid) async {
    final timeStampNow = Timestamp.now();
    final uuid = Uuid();
    String postId = "${uuid.v1()}^${uid}}";
    final appUser = await _appUserRepository.getCurrentUser();

    final downloadUrl = await _privateSaveImageOnStorage(postId, uid);

    ArchivingPost newArchivingPost = _state.archivingPost.copyWith(
      postId: postId,
      imageUrl: downloadUrl,
      userId: uid,
      createAt: timeStampNow,
      modifyAt: timeStampNow,
    );

    try {
      await _archivingPostRepository.insertArchivingPost(newArchivingPost);
      // downloadUrl이 생성이 되는 곳에서 실행하는 것이 오류가 없을 것으로 판단하여서
      // 여기에 위치시켰습니다
      await _shortArchivingPostUseCase.addShortArchivingPost(
        userId: uid,
        whiskyName: newArchivingPost.whiskyName,
        imageUrl: downloadUrl,
        postId: postId,
      );
      // final isWhiskySaved = await _hasWhiskyBeenSaved(
      //   imageUrl: downloadUrl,
      //   postId: postId,
      //   whiskyName: _state.archivingPost.whiskyName,

      // );

      // await _appUserRepository.updateUser(
      //     uid, appUser);
    } catch (error) {
      debugPrint("archivingPost를 저장하는 과정에서 문제가 생겼습니다");
    }
  }

  Future<String> _privateSaveImageOnStorage(
      String imageName, String uid) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    // final appUser = await _currentUserStatus.getAppUser();
    final imgageStoragePath = "post/archiving_post/${uid}/$imageName.jpg";
    String downloadUrl = "";

    try {
      Reference ref = _storage.ref().child(imgageStoragePath);
      UploadTask uploadTask = ref.putFile(_state.images!);
      TaskSnapshot snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      debugPrint("사진 저장 과정에서 문제가 발생하였습니다");
      debugPrint("$error");
    }
    return downloadUrl;
  }

  Future<Map<String, List<ShortArchivingPost>>> _hasWhiskyBeenSaved({
    required String whiskyName,
    required postId,
    required imageUrl,
    required Map<String, List<ShortArchivingPost>> sameKindWhiskies,
  }) async {
    Map<String, List<ShortArchivingPost>> result = Map.from(sameKindWhiskies);

    for (var key in sameKindWhiskies.keys) {
      // sameKindWhiskies[key];
      if (key == whiskyName) {
        result[whiskyName]!.add(ShortArchivingPost(
          whiskyName: whiskyName,
          imageUrl: imageUrl,
          postId: postId,
        ));
        return result;
      }
    }
    result[whiskyName] = [
      ShortArchivingPost(
        whiskyName: whiskyName,
        imageUrl: imageUrl,
        postId: postId,
      )
    ];
    return result;
  }
}
