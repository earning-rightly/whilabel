import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/data/whisky/whisky_category.dart';

part 'archiving_post.g.dart';

const firestoreSerializable = JsonSerializable(
  converters: firestoreJsonConverters,
  explicitToJson: true,
  createFieldMap: true,
);

@firestoreSerializable
class ArchivingPost {
  ArchivingPost({
    required this.whiskyId,
    required this.barcode,
    required this.whiskyName,
    this.category,
    this.location, //생산지
    this.strength,
    required this.postId,
    required this.userId,
    required this.createAt,
    this.modifyAt,
    required this.imageUrl,
    required this.starValue,
    required this.note,
    required this.tasteFeature,
  });

  // DB에서 받아올 정보
  final String whiskyId;
  final String barcode;
  final String whiskyName;
  final WhiskyCategory? category;
  final String? location;
  final String? strength;

  // 앱에서 입력할 정보
  final String postId;
  final String userId;
  final Timestamp? createAt;
  final Timestamp? modifyAt;

  final String imageUrl;
  final double starValue;
  final String note;
  final TasteFeature tasteFeature;

  factory ArchivingPost.fromJson(Map<String, dynamic> json) =>
      _$ArchivingPostFromJson(json);
  Map<String, Object?> toJson() => _$ArchivingPostToJson(this);

  ArchivingPost copyWith({
    String? whiskyId,
    String? barcode,
    String? name,
    WhiskyCategory? category,
    String? location,
    String? strength,
    String? postId,
    String? userId,
    Timestamp? createAt,
    Timestamp? modifyAt,
    String? imageUrl,
    double? starValue,
    String? note,
    TasteFeature? tasteFeature,
  }) {
    return ArchivingPost(
      whiskyId: whiskyId ?? this.whiskyId,
      barcode: barcode ?? this.barcode,
      whiskyName: name ?? this.whiskyName,
      category: category ?? this.category,
      location: location ?? this.location,
      strength: strength ?? this.strength,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      createAt: createAt ?? this.createAt,
      modifyAt: modifyAt ?? this.modifyAt,
      imageUrl: imageUrl ?? this.imageUrl,
      starValue: starValue ?? this.starValue,
      note: note ?? this.note,
      tasteFeature: tasteFeature ?? this.tasteFeature,
    );
  }
}

@Collection<ArchivingPost>('archiving_post')
final archivingPostRef = ArchivingPostCollectionReference();
