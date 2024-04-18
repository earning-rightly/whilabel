import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/domain/use_case/scan_whisky_barcode_use_case.dart';
import 'package:whilabel/domain/use_case/search_whisky_data_use_case.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_recognition/whisky_barcode_recongnition_state.dart';

import 'whisky_barcode_recognition_event.dart';

class WhiskyBarcodeRecognitionViewModel with ChangeNotifier {
  final SearchWhiskeyDataUseCase _searchWhiskeyDataUseCase;
  final ScanWhiskyBarcodeUseCase _scanWhiskyBarCodeUseCase;
  final WhiskyNewArchivingPostUseCase _whiskyNewArchivingPostUseCase;

  WhiskyBarcodeRecognitionViewModel(
      {required ScanWhiskyBarcodeUseCase scanWhiskyBarcodeUseCase,
      required SearchWhiskeyDataUseCase searchWhiskeyDataUseCase,
      required WhiskyNewArchivingPostUseCase whiskyNewArchivingPostUseCase})
      : _scanWhiskyBarCodeUseCase = scanWhiskyBarcodeUseCase,
        _searchWhiskeyDataUseCase = searchWhiskeyDataUseCase,
        _whiskyNewArchivingPostUseCase = whiskyNewArchivingPostUseCase;
  Timer? delay;

  WhiskyBarcodeRecognitionState get state => _state;
  WhiskyBarcodeRecognitionState _state =
      WhiskyBarcodeRecognitionState(isFindWhiskyData: false);

  Future<void> onEvent(WhiskyBarcodeRecognitionEvent event,
      {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
          searchWhiskeyWithBarcode: searchWhiskeyWithBarcode,
          saveBarcodeImage: (File a) {},
        )
        ?.then((_) => {after()}); //todo .then 사용하기
  }

  Future<String?> scanBarcode(File imageFile, String path, {int level = 0}) async {

    File? resizeImage = await _scanWhiskyBarCodeUseCase
        .resizeImage(imageFile, path, level: level);

    if (resizeImage != null) {
      await Future.delayed(const Duration(milliseconds: 600), () async {
        String? scanResult =
            await _scanWhiskyBarCodeUseCase.scanBarcodeImage(resizeImage.path);


        if (scanResult == null) {
          print(" ######  resize를 다시 시도합니다. 현재 level: $level  #####");

          if (level <= 3)
            scanBarcode(imageFile, path, level: level + 1);
          else
            _state = _state.copyWith(barcode: "");
        } else
          _state = _state.copyWith(barcode: scanResult);
        // return scanResult;
        notifyListeners();
      });
    }

  }

  Future<void> searchWhiskeyWithBarcode(String whiskeyBarcode) async {
    debugPrint("whisky barcode ===> $whiskeyBarcode");
    final ArchivingPost? archivingPost =
        await _searchWhiskeyDataUseCase.useWhiskyBarcode(whiskeyBarcode);

    if (archivingPost != null) {
      _whiskyNewArchivingPostUseCase.storeArchivingPost(archivingPost);
      // 검색한 위스키가 whisky collection DB에 있다면 true로 변환
      _state = _state.copyWith(isFindWhiskyData: true);
    } else {
      _state = _state.copyWith(isFindWhiskyData: false);
    }
    notifyListeners();
  }

}
