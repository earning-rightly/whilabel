import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
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
    debugPrint("whisky barcode ===> $whiskeyBarcode");
    final ArchivingPost? archivingPost =
        await _searchWhiskeyDataUseCase.useWhiskyBarcode(whiskeyBarcode);

    if (archivingPost != null) {
      _archivingPostStatus.storeArchivingPost(archivingPost);
      // 검색한 위스키가 whisky collection DB에 있다면 true로 변환
      _state = _state.copyWith(isFindWhiskyData: true);
    } else {
      _state = _state.copyWith(isFindWhiskyData: false);
    }
    notifyListeners();
  }

  Future<void> searchWhiskyWithName(String whiskyName) async {
    final shortWhiskyDatas =
        await _searchWhiskeyDataUseCase.useWhiskyName(whiskyName);

    _state = _state.copyWith(shortWhisyDatas: shortWhiskyDatas);
    notifyListeners();
  }

  Future<void> saveImageFileOnProvider(File imageFile) async {
    final imageFileSize = await _getFileSize(imageFile.path, 1);

    // image가 1.3MBx 작으면 바로 DB에 등록
    if (imageFileSize <= 1.3) {
      _archivingPostStatus.storeImageFile(imageFile);
    } else {
      final newImageFile = await FlutterNativeImage.compressImage(
          imageFile.path,
          quality: 100,
          targetHeight: 1411,
          targetWidth: 1058);
      _archivingPostStatus.storeImageFile(newImageFile);
    }
  }

  Future<void> useBarCodeScanner(BuildContext context) async {
    notifyListeners();
  }

  Future<double> _getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return 0;

    var i = (log(bytes) / log(1024)).floor();
    // double.parse(targetNum)
    return double.parse((bytes / pow(1024, i)).toStringAsFixed(2));
  }
}
