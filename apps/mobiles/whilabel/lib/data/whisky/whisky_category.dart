import 'package:json_annotation/json_annotation.dart';

enum WhiskyCategory {
  @JsonValue("american_whisky")
  americanWhisky,
  @JsonValue("blend")
  blend,
  @JsonValue("blended_grain")
  blendedGrain,
  @JsonValue("blended_malt")
  blendedMalt,
  @JsonValue("bourbon")
  bourbon,
  @JsonValue("canadian_whisky")
  canadianWhisky,
  @JsonValue("corn")
  corn,
  @JsonValue("rice")
  rice,
  @JsonValue("rye")
  rye,
  @JsonValue("Single Grain")
  singleGrain,
  @JsonValue("Single Malt")
  singleMalt,
  @JsonValue("single_pod_still")
  singlePodStill,
  @JsonValue("spirit")
  spirit,
  @JsonValue("tennessee")
  tennessee,
  @JsonValue("wheat")
  wheat,
}
