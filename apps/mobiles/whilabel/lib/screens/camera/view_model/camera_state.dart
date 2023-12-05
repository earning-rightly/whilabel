import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:whilabel/data/whisky/short_whisky.dart';

part 'camera_state.freezed.dart';

@freezed
class CameraState with _$CameraState {
  factory CameraState({
    required String albumTitle,
    required String barcode,
    required bool isFindWhiskyData,
    required List<ShortWhiskyData> shortWhisyDatas,
    File? barcodeImage,
  }) = _CameraState;
}
