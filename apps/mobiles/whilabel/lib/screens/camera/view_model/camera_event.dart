import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'camera_event.freezed.dart';

@freezed
abstract class CarmeraEvent with _$CarmeraEvent {
  const factory CarmeraEvent.useBarCodeScanner(BuildContext context) =
      useBarCodeScanner;
  const factory CarmeraEvent.searchWhiskeyWithBarcode(String whiskeyBarcode) =
      searchWhiskeyWithBarcode;
  const factory CarmeraEvent.saveImageFile(File imageFile) = saveImageFile;
  const factory CarmeraEvent.searchWhiskyWithName(String whiskyName) =
      SearchWhiskyWithName;
}
