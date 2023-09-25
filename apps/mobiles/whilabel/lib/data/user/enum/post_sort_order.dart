enum PostButtonOrder {
  LATEST("latest", "최신순"),
  OLDES("old", '오래된 순'),
  HiGHEST_RATING("highestRating", "별점 높은 순"),
  LOWEST_RATiNG("lowestRating", "별점 낮은 순"),
  UNDEFINED('undefined', '');

  const PostButtonOrder(this.code, this.displayName);
  final String code;
  final String displayName;

  @override
  String toString() => displayName;

  factory PostButtonOrder.getByCode(String code) {
    return PostButtonOrder.values.firstWhere((value) => value.code == code,
        orElse: () => PostButtonOrder.UNDEFINED);
  }
}