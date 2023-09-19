import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_state.freezed.dart';

@freezed
class CameraState with _$CameraState {
  factory CameraState({
    required String albumTitle,
    required String barcode,
    required bool isFindWhiskyData,
    File? images,
  }) = _CameraState;
}
