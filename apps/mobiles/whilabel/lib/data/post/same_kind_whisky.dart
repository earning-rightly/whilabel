import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/post/short_archiving_post.dart';
import 'package:whilabel/data/whisky/short_whisky.dart';

part 'same_kind_whisky.g.dart';

const firestoreSerializable = JsonSerializable(
  converters: firestoreJsonConverters,
  explicitToJson: true,
  createFieldMap: true,
);

@firestoreSerializable
class SameKindWhisky {
  SameKindWhisky({
    required this.docId,
    required this.userId,
    required this.sameKindWhiskyMap,
  });

  final String userId;
  final String docId;
  final Map<String, List<ShortArchivingPost>> sameKindWhiskyMap;

  factory SameKindWhisky.fromJson(Map<String, dynamic> json) =>
      _$SameKindWhiskyFromJson(json);
  Map<String, Object?> toJson() => _$SameKindWhiskyToJson(this);

  SameKindWhisky copyWith({
    String? userId,
    String? docId,
    Map<String, List<ShortArchivingPost>>? sameKindWhiskyMap,
  }) {
    return SameKindWhisky(
      userId: userId ?? this.userId,
      docId: docId ?? this.docId,
      sameKindWhiskyMap: sameKindWhiskyMap ?? this.sameKindWhiskyMap,
    );
  }
}

@Collection<SameKindWhisky>('sameKindWhisky')
final sameKindWhiskyRef = SameKindWhiskyCollectionReference();
