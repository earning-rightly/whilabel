import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/taste/taste_vote.dart';
import 'package:whilabel/data/whisky/wb_whisky.dart';
import 'package:whilabel/data/whisky/whisky_category.dart';

// This doesn't exist yet...! See "Next Steps"
part 'whisky.g.dart';

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
class Whisky {
  Whisky({
    required this.id,
    required this.barcode,
    required this.createdAt,
    required this.creator,
    required this.modifiedAt,
    required this.modifier,
    this.name,
    this.strength,
    this.imageUrl,
    this.price,
    this.priceUnit,
    this.distilleryId,
    this.category,
    this.tasteVotes,
    this.wbId,
    this.wbWhisky,
  });

  final String id; // 증류소 id (guid 사용)
  final String barcode;

  // 관리용 필드
  final Timestamp createdAt; // 생성일
  final String creator; // 생성자
  final Timestamp modifiedAt; // 수정일
  final String modifier; // 수정인

  // 관리자 '만' 수정할 수 있는 필드
  final String? name; // 위스키 이름
  final double? strength; // 도수 - 43.0
  final String? imageUrl; // 대표 사진
  final double? price; // 가격 - 83.8
  final String? priceUnit; // 가격 단위 - 달러 유로 etc..

  final String? distilleryId;
  final WhiskyCategory? category; // 종류 - Blended Malt / Single Malt ...

  final List<TasteVote>? tasteVotes;

  // 배치가 생성할 필드 (만약 이미 존재하는 위스키면 이 필드만 변경)
  final String? wbId; // wb 위스키 id
  final WbWhisky? wbWhisky;

  factory Whisky.fromJson(Map<String, Object?> json) => _$WhiskyFromJson(json);

  Map<String, Object?> toJson() => _$WhiskyToJson(this);
}

@Collection<Whisky>('whisky')
final whiskyRef = WhiskyCollectionReference();
