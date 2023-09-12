import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/taste/taste_vote.dart';
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
    required this.whiskyWbId,
    required this.whiskeyName,
    required this.barcode,
    this.distilleryWbIds,
    this.distillerys,
    this.distilleryNames,
    this.category,
    this.contury,
    this.strength,
    this.calculatedAge,
    this.tasteVotes,
    required this.uid,
    this.createDate,
    required this.modifyDate,
    this.imageUrl,
    required this.starValue,
  });

  // DB에서 받아올 정보
  final String whiskyWbId;
  final String whiskeyName;
  final String barcode;
  final List<String?>? distilleryWbIds;
  final List<Distillery>? distillerys;
  final List<String?>? distilleryNames;
  final WhiskyCategory? category;
  final String? contury;
  final String? strength;
  final String? calculatedAge;
  final List<TasteVote>? tasteVotes;

  // 앱에서 입력할 정보
  final String uid;
  final Timestamp? createDate;
  final String modifyDate;
  final String? imageUrl;
  final double starValue;

  ArchivingPost copyWith({
    String? whiskyWbId,
    String? whiskeyName,
    String? barcode,
    List<String?>? distilleryWbIds,
    List<Distillery>? distillerys,
    List<String?>? distilleryNames,
    WhiskyCategory? category,
    String? contury,
    String? strength,
    String? calculatedAge,
    List<TasteVote>? tasteVotes,
    String? uid,
    Timestamp? createDate,
    String? modifyDate,
    String? imageUrl,
    String? oneLineCommnet,
    double? starValue,
  }) {
    return ArchivingPost(
      whiskyWbId: whiskyWbId ?? this.whiskyWbId,
      whiskeyName: whiskeyName ?? this.whiskeyName,
      barcode: barcode ?? this.barcode,
      distilleryWbIds: distilleryWbIds ?? this.distilleryWbIds,
      distillerys: distillerys ?? this.distillerys,
      distilleryNames: distilleryNames ?? this.distilleryNames,
      category: category ?? this.category,
      contury: contury ?? this.contury,
      strength: strength ?? this.strength,
      calculatedAge: calculatedAge ?? this.calculatedAge,
      tasteVotes: tasteVotes ?? this.tasteVotes,
      uid: uid ?? this.uid,
      createDate: createDate ?? this.createDate,
      modifyDate: modifyDate ?? this.modifyDate,
      imageUrl: imageUrl ?? this.imageUrl,
      starValue: starValue ?? this.starValue,
    );
  }

  factory ArchivingPost.fromJson(Map<String, dynamic> json) =>
      _$ArchivingPostFromJson(json);
  Map<String, Object?> toJson() => _$ArchivingPostToJson(this);
}

@Collection<ArchivingPost>('archiving_post')
final archivingPostRef = ArchivingPostCollectionReference();
