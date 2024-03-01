import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/domain/use_case/scan_whisky_barcode_use_case.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/domain/use_case/search_whisky_data_use_case.dart';
import 'package:whilabel/screens/camera/view_model/camera_event.dart';
import 'package:whilabel/screens/camera/view_model/camera_state.dart';

class CameraViewModel with ChangeNotifier {
  final SearchWhiskeyDataUseCase _searchWhiskeyDataUseCase;
  final WhiskyNewArchivingPostUseCase _archivingPostStatus;
  final ScanWhiskyBarcodeUseCase _scanWhiskyBarCodeUseCase;

  CameraViewModel(
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
      cameras: <CameraDescription>[]
  );
  Future<void> onEvent(CameraEvent event, {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
          initCamera: initCamera,
          addMediums: addMediums,
          cleanCameraState: cleanCameraState,
          searchWhiskeyWithBarcode: searchWhiskeyWithBarcode,
          searchWhiskyWithName: searchWhiskyWithName,
          saveBarcodeImage: saveBarcodeImage,
          saveUserWhiskyImageOnNewArchivingPostState:
              saveUserWhiskyImageOnNewArchivingPostState,
        )
        .then((_) => {after()});
  }

  Future<void> initCamera() async{
    /// state.cameras를 초기화한다.
    WidgetsFlutterBinding.ensureInitialized();
    final _camera = await availableCameras();

    _state = _state.copyWith(cameras: _camera);
    notifyListeners();
  }

  Future<void> scanBarcode(File imageFile, {int level = 0}) async {
    File? resizeImage =
    await _scanWhiskyBarCodeUseCase.resizeImage(imageFile, level: level);

    if (resizeImage != null) {
      await Future.delayed(const Duration(milliseconds: 1000), () async {
        String? scanResult =
        await _scanWhiskyBarCodeUseCase.scanBarcodeImage(resizeImage.path);

        if (scanResult == null) {
          print(" ######  resize를 다시 시도합니다. 현재 level: $level  #####");
          if (level <= 5) scanBarcode(imageFile, level: level+1);
          else _state = _state.copyWith(barcode: "");
        }
        else _state = _state.copyWith(barcode: scanResult);
        notifyListeners();
      });
    }
  }



  Future<void> cleanCameraState() async{

    _state = _state.copyWith(mediums: [], barcode: null);
    notifyListeners();
  }

  Future<void> addMediums(List<Medium> mediums) async{
    if (mediums.isNotEmpty){
      _state = _state.copyWith(mediums: mediums);
      notifyListeners();
    }
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

  Future<void> saveUserWhiskyImageOnNewArchivingPostState(File imageFile) async {
    final imageFileSize = await _getFileSize(imageFile.path, 1);

    // image가 1.3MBx Provider에 저장
    if (imageFileSize <= 1.3) {
      _archivingPostStatus.saveImageFile(imageFile);
    } else {
      final newImageFile = await FlutterNativeImage.compressImage(
          imageFile.path,
          quality: 100,
          targetHeight: 1411,
          targetWidth: 1058);
      _archivingPostStatus.saveImageFile(newImageFile);
    }
  }

  // 사용 안할거 같기 때문에 다시 원상태로 복귀가능
  // Future<void> useBarCodeScanner(BuildContext context) async {
  //   notifyListeners();
  // }
  Future<void> saveBarcodeImage(File barcodeImage) async {
    _state = _state.copyWith(
      barcodeImage: barcodeImage
    );
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
