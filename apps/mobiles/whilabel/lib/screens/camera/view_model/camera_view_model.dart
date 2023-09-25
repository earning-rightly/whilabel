import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/domain/use_case/search_whisky_barcode_use_case.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_state.dart';

class CarmeraViewModel with ChangeNotifier {
  final SearchWhiskeyBarcodeUseCase _searchWhiskeyBarcodeUseCase;
  final WhiskyNewArchivingPostUseCase _archivingPostStatus;

  CarmeraViewModel(
      {required SearchWhiskeyBarcodeUseCase searchWhiskeyBarcodeUseCase,
      required WhiskyNewArchivingPostUseCase archivingPostStatus})
      : _searchWhiskeyBarcodeUseCase = searchWhiskeyBarcodeUseCase,
        _archivingPostStatus = archivingPostStatus;

  CameraState get state => _state;
  CameraState _state =
      CameraState(albumTitle: "", barcode: "", isFindWhiskyData: false);

  Future<void> onEvent(CarmeraEvent event, {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
          searchWhiskeyWithBarcode: searchWhiskeyWithBarcode,
          useBarCodeScanner: useBarCodeScanner,
          saveImageFile: saveImageFileOnProvider,
        )
        .then((_) => {after()});
  }

  Future<void> searchWhiskeyWithBarcode(String whiskeyBarcode) async {
    final ArchivingPost? archivingPost = await _searchWhiskeyBarcodeUseCase
        .getSearchedWhiskyDataResult(whiskeyBarcode);

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
}
