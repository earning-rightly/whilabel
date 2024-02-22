import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whilabel/data/post/announcement.dart';
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
    required this.firebaseUserId,
    required this.uid,
    required this.nickName,
    required this.snsUserInfo,
    required this.snsType,
    required this.creatAt,
    this.isDeleted,
    this.isPushNotificationEnabled, // 푸시알림이 어떻게 작동되는지 알아야함
    this.isMarketingNotificationEnabled,
    this.fcmToken,
    this.name,
    this.age,
    this.birthDay,
    this.gender,
    this.email,
    this.imageUrl,
    this.sameKindWhiskyId,
    this.announcements
  });
  final String firebaseUserId;
  final String uid;
  final String nickName;
  final Map snsUserInfo;
  final SnsType snsType;
  final Timestamp creatAt;

  List<Announcement>? announcements;
  bool? isDeleted = false;
  bool? isPushNotificationEnabled = false;
  bool? isMarketingNotificationEnabled = false;

  String? fcmToken;// alim에서 필요 DB에 login때 추가. logout때 삭제
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


  AppUser copyWith(
      {
      String? nickName,
      Map? snsUserInfo,
      bool? isDeleted,
      bool? isPushNotificationEnabled,
      bool? isMarketingNotificationEnabled,
      String? name,
      Gender? gender,
      String? birthDay,
      String? sameKindWhiskyId,
      String? fcmToken,
      int? age,
      List<Announcement>? announcements
      }) {

    print("copyWith");
    return AppUser(
        firebaseUserId: firebaseUserId,
        uid: uid,
        nickName: nickName ?? this.nickName,
        snsUserInfo: snsUserInfo ?? this.snsUserInfo,
        snsType: snsType,
        creatAt: creatAt,
        announcements: announcements ?? this.announcements,
        isDeleted: isDeleted ?? this.isDeleted,
        isPushNotificationEnabled:
            isPushNotificationEnabled ?? this.isPushNotificationEnabled,
        isMarketingNotificationEnabled: isMarketingNotificationEnabled ??
            this.isMarketingNotificationEnabled,
        fcmToken: fcmToken ?? this.fcmToken,
        name: name ?? this.name,
        age: age ?? this.age,
        birthDay: birthDay ?? this.birthDay,
        gender: gender ?? this.gender,
        email: email,
        imageUrl: imageUrl,
        sameKindWhiskyId: sameKindWhiskyId ?? this.sameKindWhiskyId
    );
  }
}

@Collection<AppUser>('user')
final usersRef = AppUserCollectionReference();
