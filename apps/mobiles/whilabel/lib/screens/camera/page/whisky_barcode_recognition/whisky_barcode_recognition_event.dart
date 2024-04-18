import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'whisky_barcode_recognition_event.freezed.dart';

@freezed
abstract class WhiskyBarcodeRecognitionEvent with _$WhiskyBarcodeRecognitionEvent {
  const factory WhiskyBarcodeRecognitionEvent.saveBarcodeImage(File barcodeImage) =
  saveBarcodeImage;

  const factory WhiskyBarcodeRecognitionEvent.searchWhiskeyWithBarcode(String whiskeyBarcode) =
  searchWhiskeyWithBarcode;
}
