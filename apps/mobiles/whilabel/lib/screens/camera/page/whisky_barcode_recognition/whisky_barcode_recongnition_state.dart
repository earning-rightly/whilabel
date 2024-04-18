import 'package:freezed_annotation/freezed_annotation.dart';


part 'whisky_barcode_recongnition_state.freezed.dart';

@freezed
class WhiskyBarcodeRecognitionState with _$WhiskyBarcodeRecognitionState {
  factory WhiskyBarcodeRecognitionState({
    required bool isFindWhiskyData,
     String? barcode,

  }) = _WhiskyBarcodeRecognitionState;
}
