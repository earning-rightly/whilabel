import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:photo_gallery/photo_gallery.dart';

part 'camera_event.freezed.dart';

@freezed
abstract class CameraEvent with _$CameraEvent {
  const factory CameraEvent.saveBarcodeImage(File barcodeImage) =
      saveBarcodeImage;
  const factory CameraEvent.searchWhiskeyWithBarcode(String whiskeyBarcode) =
      searchWhiskeyWithBarcode;
  const factory CameraEvent.saveUserWhiskyImageOnNewArchivingPostState(File imageFile) =
      saveUserWhiskyImageOnNewArchivingPostState;
  const factory CameraEvent.searchWhiskyWithName(String whiskyName) =
      SearchWhiskyWithName;
  const factory CameraEvent.addMediums(List<Medium> mediums) =
      addMediums;
  const factory CameraEvent.cleanMediums() =
      cleanMediums;
  const factory CameraEvent.initCamera() =
      initCamera;
}
