import 'package:json_annotation/json_annotation.dart';

// smokey, medicinal, citric, vanilla, honey, sherried, tobacco, dried Fruit, Husky, Nutty, fresh Fruit, chocolate
enum TasteTag {
  @JsonValue("smokey") smokey,
  @JsonValue("medicinal") medicinal,
  @JsonValue("citric") citric,
  @JsonValue("vanilla") vanilla,
  @JsonValue("honey") honey,
  @JsonValue("sherried") sherried,
  @JsonValue("tobacco") tobacco,
  @JsonValue("dried_fruit") driedFruit,
  @JsonValue("husky") husky,
  @JsonValue("nutty") nutty,
  @JsonValue("fresh_fruit") freshFruit,
  @JsonValue("chocolate") chocolate,
}