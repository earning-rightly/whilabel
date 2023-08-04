import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// 5개의 별점 widget을 만들어주는 함수입니다. 0.5개도 가능합니다.
// flutter flutter_rating_bar package입니다.
Widget buildStarRating(double initialRating, bool enable) {
  return RatingBar.builder(
    ignoreGestures: !enable, // 별점 매길 것 인지 보기만 할 것인지
    initialRating: initialRating, // 처음에 보여 줘야 할 별점 개수
    minRating: 0,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
    itemBuilder: (context, _) => Icon(
      // build 되는 아이콘 변경가능
      Icons.star,
      color: Colors.amber,
    ),
    onRatingUpdate: (rating) {
      print("rating update");
      print(rating);
    },
  );
}
