import 'dart:io';
import 'package:camera/camera.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_gallery/photo_gallery.dart';
import 'package:whilabel/data/whisky/short_whisky.dart';

part 'camera_state.freezed.dart';

@freezed
class CameraState with _$CameraState {
  factory CameraState({
    required String albumTitle,
    required String barcode,
    required bool isFindWhiskyData,
    required List<ShortWhiskyData> shortWhisyDatas,
    required List<Medium> mediums,
    required List<CameraDescription> cameras,
    File? barcodeImage,
  }) = _CameraState;
}
