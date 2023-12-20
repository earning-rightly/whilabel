import 'package:freezed_annotation/freezed_annotation.dart';

part 'announcement.freezed.dart';
part 'announcement.g.dart';


@freezed
class Announcement  with _$Announcement{
  factory Announcement({
    required String title,
    required String body,
    required String whiskyName,

  }) = _Announcement;


  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}


