import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/domain/use_case/search_whisky_data_use_case.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_state.dart';

class CarmeraViewModel with ChangeNotifier {
  final SearchWhiskeyDataUseCase _searchWhiskeyDataUseCase;
  final WhiskyNewArchivingPostUseCase _archivingPostStatus;

  CarmeraViewModel(
      {required SearchWhiskeyDataUseCase searchWhiskeyDataUseCase,
      required WhiskyNewArchivingPostUseCase archivingPostStatus})
      : _searchWhiskeyDataUseCase = searchWhiskeyDataUseCase,
        _archivingPostStatus = archivingPostStatus;

  CameraState get state => _state;
  CameraState _state = CameraState(
      albumTitle: "",
      barcode: "",
      isFindWhiskyData: false,
      shortWhisyDatas: []);

  Future<void> onEvent(CarmeraEvent event, {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
          searchWhiskeyWithBarcode: searchWhiskeyWithBarcode,
          searchWhiskyWithName: searchWhiskyWithName,
          useBarCodeScanner: useBarCodeScanner,
          saveImageFile: saveImageFileOnProvider,
        )
        .then((_) => {after()});
  }

  Future<void> searchWhiskeyWithBarcode(String whiskeyBarcode) async {
    final ArchivingPost? archivingPost =
        await _searchWhiskeyDataUseCase.useWhiskyBarcode(whiskeyBarcode);

    if (archivingPost != null) {
      _archivingPostStatus.storeArchivingPost(archivingPost);
      // 검색한 위스키가 DB에 있다면 true로 변환
      _state = _state.copyWith(isFindWhiskyData: true);

      notifyListeners();
    }
  }

  Future<void> saveImageFileOnProvider(File imageFile) async {
    _archivingPostStatus.storeImageFile(imageFile);
  }

  Future<void> useBarCodeScanner(BuildContext context) async {
    notifyListeners();
  }

  Future<void> searchWhiskyWithName(String whiskyName) async {
    final shortWhiskyDatas =
        await _searchWhiskeyDataUseCase.useWhiskyName(whiskyName);
    _state = _state.copyWith(shortWhisyDatas: shortWhiskyDatas);
    notifyListeners();
  }
}
