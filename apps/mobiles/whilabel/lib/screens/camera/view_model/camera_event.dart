import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_event.freezed.dart';

@freezed
abstract class CarmeraEvent with _$CarmeraEvent {
  const factory CarmeraEvent.saveBarcodeImage(File barcodeImage) =
      saveBarcodeImage;
  const factory CarmeraEvent.searchWhiskeyWithBarcode(String whiskeyBarcode) =
      searchWhiskeyWithBarcode;
  const factory CarmeraEvent.saveUserWhiskyImageOnNewArchivingPostState(File imageFile) =
      saveUserWhiskyImageOnNewArchivingPostState;
  const factory CarmeraEvent.searchWhiskyWithName(String whiskyName) =
      SearchWhiskyWithName;
}
