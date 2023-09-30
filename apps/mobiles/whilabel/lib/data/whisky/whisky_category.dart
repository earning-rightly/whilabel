import 'package:json_annotation/json_annotation.dart';

enum WhiskyCategory {
  @JsonValue("American Whisky")
  americanWhisky,
  @JsonValue("Blend")
  blend,
  @JsonValue("Blended Grain")
  blendedGrain,
  @JsonValue("Blended Malt")
  blendedMalt,
  @JsonValue("Bourbon")
  bourbon,
  @JsonValue("Canadian Whisky")
  canadianWhisky,
  @JsonValue("Corn")
  corn,
  @JsonValue("Rice")
  rice,
  @JsonValue("Rye")
  rye,
  @JsonValue("Single Grain")
  singleGrain,
  @JsonValue("Single Malt")
  singleMalt,
  @JsonValue("Single Pod Still")
  singlePodStill,
  @JsonValue("Spirit")
  spirit,
  @JsonValue("Tennessee")
  tennessee,
  @JsonValue("Wheat")
  wheat,
}
