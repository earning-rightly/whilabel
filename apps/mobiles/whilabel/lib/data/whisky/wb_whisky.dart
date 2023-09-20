import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/taste/taste_vote.dart';
import 'package:whilabel/data/whisky/whisky_category.dart';

// This doesn't exist yet...! See "Next Steps"
part 'wb_whisky.g.dart';

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
class WbWhisky {
  WbWhisky(
      {required this.wbID,
      required this.barcode,
      required this.name,
      this.strength,
      this.imageUrl,
      this.price,
      this.priceUnit,
      this.wbDistilleryIds,
      this.distilleryName,
      this.category,
      this.tasteVotes,
      required this.batchedAt,
      required this.batchId,
      this.bottler,
      this.bottleCode,
      this.bottledYear,
      this.size,
      this.label,
      this.market,
      this.voteCount,
      this.rating});

  // 위라밸 데이터에서 공유할 부분
  final String wbID; // wb 증류소 id - 90642
  final String? barcode;
  final String name; // 위스키 이름 - Aberlour

  final String? strength; // 도수 - 43.0
  final String? imageUrl; // 대표 사진
  final double? price; // 가격 - 83.8
  final String? priceUnit; // 가격 단위 - 달러 유로 etc..

  final List<String>? wbDistilleryIds; // wb 증류소 id - 90642
  final String? distilleryName;

  final WhiskyCategory? category; // 종류 - Blended Malt / Single Malt ...

  final List<TasteVote>? tasteVotes;

  // 관리용 필드
  final Timestamp? batchedAt; // 데이터 생성 배치가 돈 시각
  final String? batchId; // 데이터 배치 종류

  // 일단 가지고 있을 필드
  final String? bottler;
  final String? bottleCode;
  final String? bottledYear;
  final String? size; // 용량 - 750 ml
  final String? label;
  final String? market; // 파는 나라..?
  final int? voteCount; // 투표 수 - 55
  final double? rating; // 투표 점수 - 23.4

  factory WbWhisky.fromJson(Map<String, Object?> json) =>
      _$WbWhiskyFromJson(json);

  Map<String, Object?> toJson() => _$WbWhiskyToJson(this);
}
