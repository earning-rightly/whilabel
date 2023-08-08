class TestWhiskeyDataModel {
  final String imageUrl;
  final String whiskeyName;
  final int starRating;
  final String whiskeyProducingArea;
  final double whiskeyLcoholPercentagea;
  final String oneLineText;
  TestWhiskeyDataModel({
    required this.imageUrl,
    required this.whiskeyName,
    required this.starRating,
    required this.whiskeyProducingArea,
    required this.whiskeyLcoholPercentagea,
    required this.oneLineText,
  });

  TestWhiskeyDataModel copyWith({
    String? imageUrl,
    String? whiskeyName,
    int? starRating,
    String? whiskeyProducingArea,
    double? whiskeyLcoholPercentagea,
    String? oneLineText,
  }) {
    return TestWhiskeyDataModel(
      imageUrl: imageUrl ?? this.imageUrl,
      whiskeyName: whiskeyName ?? this.whiskeyName,
      starRating: starRating ?? this.starRating,
      whiskeyProducingArea: whiskeyProducingArea ?? this.whiskeyProducingArea,
      whiskeyLcoholPercentagea:
          whiskeyLcoholPercentagea ?? this.whiskeyLcoholPercentagea,
      oneLineText: oneLineText ?? this.oneLineText,
    );
  }
}
