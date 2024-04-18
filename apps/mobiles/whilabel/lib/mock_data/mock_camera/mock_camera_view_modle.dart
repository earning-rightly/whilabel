import 'dart:io';

import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:whilabel/domain/use_case/scan_whisky_barcode_use_case.dart';
import 'package:whilabel/domain/use_case/search_whisky_data_use_case.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/screens/camera/view_model/camera_state.dart';




class MockCameraViewModel with ChangeNotifier {
  final SearchWhiskeyDataUseCase _searchWhiskeyDataUseCase;
  final WhiskyNewArchivingPostUseCase _archivingPostStatus;
  final ScanWhiskyBarcodeUseCase _scanWhiskyBarCodeUseCase;

  MockCameraViewModel(
      {required SearchWhiskeyDataUseCase searchWhiskeyDataUseCase,
        required WhiskyNewArchivingPostUseCase archivingPostStatus,
        required ScanWhiskyBarcodeUseCase scanWhiskyBarcodeUseCase})
      : _searchWhiskeyDataUseCase = searchWhiskeyDataUseCase,
        _archivingPostStatus = archivingPostStatus,
        _scanWhiskyBarCodeUseCase = scanWhiskyBarcodeUseCase;

  CameraState get state => _state;
  CameraState _state = CameraState(
      albumTitle: "",
      isFindWhiskyData: false,
      shortWhisyDatas: [],
      mediums: [],
      cameras: <CameraDescription>[]);


  Future<void> mockCleanMediums() async {
    _state = _state.copyWith(mediums: [], barcode: null);
    // _state = _state.copyWith(mediums: [], barcode: "");
    notifyListeners();
  }

  Future<void> mockBarcodeLibaryTest(File imageFile, {int level = 0}) async {
    final tempDir = await getTemporaryDirectory();
    File? resizeImage =
    await _scanWhiskyBarCodeUseCase.resizeImage(imageFile,tempDir.path, level: level);

    if (resizeImage != null) {
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        String imageName = imageFile.path
            .split('/')
            .last;

        String? scanResult =
        await _scanWhiskyBarCodeUseCase.scanBarcodeImage(resizeImage.path);
        print(
            "cameraViewModel code scan barcode type ==> ${scanResult
                .runtimeType}");

        print(
            "cameraViewModel code scanBarcode show scan result ==> $scanResult");
        await _mockPrivateSaveImageOnStorage("$imageName+$level", resizeImage);


        if (scanResult == null) {
          print(" ######  resize를 다시 시도합니다. 현재 level: $level  #####");
          if (level <= 5)
            mockBarcodeLibaryTest(imageFile, level: level + 1);
          else _state = _state.copyWith(barcode: "");
        }
        else _state = _state.copyWith(barcode: scanResult);
        notifyListeners();
      });
    }
  }


  Future<String> _mockPrivateSaveImageOnStorage(String imageName,
      File image) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    final imgageStoragePath = "mock/barcode/$imageName";
    String downloadUrl = "";

    try {
      Reference ref = _storage.ref().child(imgageStoragePath);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      debugPrint("사진 저장 과정에서 문제가 발생하였습니다");
      debugPrint("$error");
    }
    return downloadUrl;
  }
}