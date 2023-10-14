import 'package:freezed_annotation/freezed_annotation.dart';

part 'short_whisky.freezed.dart';
part 'short_whisky.g.dart';

@freezed
class ShortWhiskyData with _$ShortWhiskyData {
  factory ShortWhiskyData({
    required String name,
    required String barcode,
    required String strength,
  }) = _ShortWhiskyData;
  factory ShortWhiskyData.fromJson(Map<String, dynamic> json) =>
      _$ShortWhiskyDataFromJson(json);
}
