import 'package:json_annotation/json_annotation.dart';

enum Gender {
  @JsonValue("female")
  FEMALE,
  @JsonValue("male")
  MALE
}
