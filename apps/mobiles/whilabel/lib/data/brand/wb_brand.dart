import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';

// This doesn't exist yet...! See "Next Steps"
part 'wb_brand.g.dart';

/// A custom JsonSerializable annotation that supports decoding objects such
/// as Timestamps and DateTimes.
/// This variable can be reused between different models
const firestoreSerializable = JsonSerializable(
  converters: firestoreJsonConverters,
  // The following values could alternatively be set inside your `build.yaml`
  explicitToJson: true,
  createFieldMap: true,
);

@firestoreSerializable
class WbBrand {
  WbBrand({
    required this.id,
    this.name,
    this.country,
    this.link,
    this.whiskyCount,
    this.voteCount,
    this.rating,
  });

  final String id; // wb 브랜드 id - 81707
  final String? name; // 브랜드명 - Aberlour
  final String? country; // 나라 - Scotland
  final String?
      link; // wb 브랜드 url - https://www.whiskybase.com/whiskies/brand/81707
  final int? whiskyCount; // 위스키 수 - 3
  final int? voteCount; // 투표 수 - 143
  final double? rating; // 점수 - 35.03

  factory WbBrand.fromJson(Map<String, Object?> json) =>
      _$WbBrandFromJson(json);

  Map<String, Object?> toJson() => _$WbBrandToJson(this);
}

@Collection<WbBrand>('wb_brand')
final wbDistilleryRef = WbBrandCollectionReference();
