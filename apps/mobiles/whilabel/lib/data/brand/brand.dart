import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/brand/wb_brand.dart';

// This doesn't exist yet...! See "Next Steps"
part 'brand.g.dart';

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
class Brand {
  Brand({
    required this.id,
    required this.createdAt,
    required this.creator,
    required this.modifiedAt,
    required this.modifier,
    this.wbId,
    this.name,
    this.country,
    this.link,
    this.wbBrand,
  });

  final String id; // 브랜드 id (guid 사용)

  // 관리용 필드
  final Timestamp createdAt; // 생성일
  final String creator; // 생성자
  final Timestamp modifiedAt; // 수정일
  final String modifier; // 수정인

  // 관리자가 수정 가능한 필드
  final String? wbId; // wb 브랜드 id

  // 관리자 '만' 수정할 수 있는 필드
  final String? name; // 위스키 이름
  final String? country; // 나라 - Scotland
  final String? link; // 브랜드 공식 url - aberlour.com

  // 배치가 생성할 필드 (만약 이미 존재하는 증류소면 이 필드만 변경)
  final WbBrand? wbBrand;
}

@Collection<Brand>('brand')
final drandRef = BrandCollectionReference();
