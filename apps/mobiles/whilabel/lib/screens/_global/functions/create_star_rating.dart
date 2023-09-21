import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';

// 5개의 별점 widget을 만들어주는 함수입니다. 0.5개도 가능합니다.
// flutter flutter_rating_bar package입니다.
Widget createStarRating(double initialRating, bool disable,
    {Function(double rating)? onRatingUpdate}) {
  return RatingBar.builder(
      ignoreGestures: disable, // 별점 매길 것 인지 보기만 할 것인지
      initialRating: initialRating, // 처음에 보여 줘야 할 별점 개수

      itemSize: 32,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.only(right: 12),
      itemBuilder: (context, _) => Icon(
            Icons.star,
            color: ColorsManager.yellow,
          ),
      unratedColor: ColorsManager.black300,
      onRatingUpdate: onRatingUpdate != null
          ? (rating) => onRatingUpdate(rating)
          : (rating) => rating);
}
