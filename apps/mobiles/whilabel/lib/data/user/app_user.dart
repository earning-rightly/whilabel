import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/user/enum/gender.dart';
import 'package:whilabel/data/user/sns_type.dart';

part 'app_user.g.dart';

const firestoreSerializable = JsonSerializable(
  converters: firestoreJsonConverters,
  explicitToJson: true,
  createFieldMap: true,
);

@firestoreSerializable
class AppUser {
  AppUser({
    required this.uid,
    required this.nickName,
    required this.snsUserInfo,
    required this.snsType,
    this.isDeleted,
    this.isPushNotificationEnabled, // 푸시알림이 어떻게 작동되는지 알아야함
    this.isMarketingNotificationEnabled,
    this.name,
    this.age,
    this.birthDay,
    this.gender,
    this.email,
    this.imageUrl,
    this.sameKindWhiskyId,
  });

  final String uid;
  final String nickName;
  final Map snsUserInfo;
  final SnsType snsType;

  bool? isDeleted = false;
  bool? isPushNotificationEnabled = false;
  bool? isMarketingNotificationEnabled = false;

  String? birthDay;
  String? name;
  int? age;
  Gender? gender;
  String? email;
  String? imageUrl;
  String? sameKindWhiskyId;
  // UserDto makeUserDto() {}
  factory AppUser.fromJson(Map<String, Object?> json) =>
      _$AppUserFromJson(json);

  Map<String, Object?> toJson() => _$AppUserToJson(this);

  static AppUser creatEmptyAppUser() {
    return AppUser(
      uid: "",
      nickName: "",
      snsUserInfo: {},
      snsType: SnsType.EMPTY,
      isDeleted: false,
      isPushNotificationEnabled: false,
      isMarketingNotificationEnabled: true,
      name: "",
    );
  }

  AppUser copyWith(
      {String? uid,
      String? nickName,
      Map? snsUserInfo,
      SnsType? snsType,
      bool? isDeleted,
      bool? isPushNotificationEnabled,
      bool? isMarketingNotificationEnabled,
      String? name,
      Gender? gender,
      String? birthDay,
      String? sameKindWhiskyId,
      int? age}) {
    return AppUser(
        uid: uid ?? this.uid,
        nickName: nickName ?? this.nickName,
        snsUserInfo: snsUserInfo ?? this.snsUserInfo,
        snsType: snsType ?? this.snsType,
        isDeleted: isDeleted ?? this.isDeleted,
        isPushNotificationEnabled:
            isPushNotificationEnabled ?? this.isPushNotificationEnabled,
        isMarketingNotificationEnabled: isMarketingNotificationEnabled ??
            this.isMarketingNotificationEnabled,
        name: name ?? this.name,
        gender: gender ?? this.gender,
        birthDay: birthDay ?? this.birthDay,
        sameKindWhiskyId: sameKindWhiskyId ?? this.sameKindWhiskyId);
  }
}

@Collection<AppUser>('user')
final usersRef = AppUserCollectionReference();
