import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/user/enum/gender.dart';

import 'package:whilabel/data/user/sns_type.dart';

// This doesn't exist yet...! See "Next Steps"
part 'app_user.g.dart';

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
class AppUser {
  AppUser({
    required this.uid,
    required this.nickname,
    required this.snsUserInfo,
    required this.snsType,
    required this.isDeleted,
    required this.allowNotification, // 푸시알림이 어떻게 작동되는지 알아야함
    this.name,
    this.age,
    this.birthDay,
    this.gender,
    this.email,
    this.imageUrl,
  });

  final String uid;
  final String nickname;
  final Map snsUserInfo;
  final SnsType snsType;
  bool isDeleted = false;
  bool allowNotification = false;
  String? birthDay;
  String? name;
  int? age;
  Gender? gender;
  String? email;
  String? imageUrl;

  // UserDto makeUserDto() {}
  factory AppUser.fromJson(Map<String, Object?> json) =>
      _$AppUserFromJson(json);

  Map<String, Object?> toJson() => _$AppUserToJson(this);

  static AppUser creatEmptyAppUser() {
    return AppUser(
        uid: "",
        nickname: "",
        snsUserInfo: {},
        snsType: SnsType.EMPTY,
        isDeleted: false,
        allowNotification: false);
  }

  AppUser copyWith(
      {String? uid,
      String? nickname,
      Map? snsUserInfo,
      // SnsType? snsType,
      String? name,
      Gender? gender,
      String? birthDay,
      int? age}) {
    return AppUser(
      age: age ?? this.age,
      gender: gender,
      birthDay: birthDay,
      name: name,
      imageUrl: this.imageUrl,
      email: this.email,
      allowNotification: true,
      isDeleted: false,
      uid: this.uid,
      nickname: nickname ?? this.nickname,
      snsUserInfo: snsUserInfo ?? this.snsUserInfo,
      snsType: this.snsType,
    );
  }
}

@Collection<AppUser>('user')
final usersRef = AppUserCollectionReference();
