import 'package:json_annotation/json_annotation.dart';

enum SnsType {
  @JsonValue("instagram")
  INSTAGRAM,
  @JsonValue("google")
  GOOGLE,
  @JsonValue("apple")
  APPLE,
  @JsonValue("kakao")
  KAKAO,
  @JsonValue("")
  EMPTY,
}
