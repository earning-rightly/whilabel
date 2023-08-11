class MockWhiskeyDataModel {
  final String imageUrl;
  final String whiskeyName;
  final int starRating;
  final String whiskeyProducingArea;
  final double whiskeyLcoholPercentagea;
  final String oneLineText;
  MockWhiskeyDataModel({
    required this.imageUrl,
    required this.whiskeyName,
    required this.starRating,
    required this.whiskeyProducingArea,
    required this.whiskeyLcoholPercentagea,
    required this.oneLineText,
  });

  MockWhiskeyDataModel copyWith({
    String? imageUrl,
    String? whiskeyName,
    int? starRating,
    String? whiskeyProducingArea,
    double? whiskeyLcoholPercentagea,
    String? oneLineText,
  }) {
    return MockWhiskeyDataModel(
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
