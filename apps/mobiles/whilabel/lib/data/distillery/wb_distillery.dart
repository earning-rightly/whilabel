import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';

// This doesn't exist yet...! See "Next Steps"
part 'wb_distillery.g.dart';

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
class WbDistillery {
  WbDistillery({
    required this.wbId,
    required this.name,
    this.link,
    this.country,
    this.address,
    required this.batchedAt,
    required this.batchId,
    this.whiskyCount,
    this.voteCount,
    this.rating,
    this.wbLink,
    this.closed,
    this.founded,
    this.owner,
    this.spiritStills,
    this.status,
    this.viewCount,
    this.wbRanking,
    this.washStills,
  });

  // 위라밸 데이터에서 공유할 부분
  final String wbId; // wb 증류소 id - 90642
  final String name; // 위스키 이름 - Aberlour
  final String? link; // 증류소 공식 url - aberlour.com
  final String? country; // 나라 - Scotland
  final String?
      address; // 증류소 상세 주소 - PA42 7EA Port Ellen, Islay > Scotland  Islay

  // 관리용 필드
  final Timestamp batchedAt; // 데이터 생성 배치가 돈 시각
  final String batchId; // 데이터 배치 종류

  // 일단 가지고 있을 필드
  final int? whiskyCount; // 위스키 갯수 - 1325
  final int? voteCount; // 투표 수 - 55
  final double? rating; // 투표 점수 - 23.4
  final String?
      wbLink; // wb 증류소 페이지 url - https://www.whiskybase.com/whiskies/distillery/90642
  final String? closed; // Close 된 날짜(존재하는 경우) - 230802
  final String? founded; // 증류소 설립일 - 01.01.1879
  final String? owner; // 증류소 주인 - Pernod Ricard
  final int? spiritStills; // 증류 횟수 - 2
  final String? status; // 상태 - Active Unknown Mothballed Closed Silent
  final int? viewCount; // 노출 수 - 176085
  final String? wbRanking; // wb 랭크 - A to G
  final int? washStills; // 증류 횟수 - 2

  factory WbDistillery.fromJson(Map<String, Object?> json) =>
      _$WbDistilleryFromJson(json);

  Map<String, Object?> toJson() => _$WbDistilleryToJson(this);
}

@Collection<WbDistillery>('wb_distillery')
final wbDistilleryRef = WbDistilleryCollectionReference();
