import 'package:flutter/material.dart';
import 'package:whilabel/test_data/test_whiskey_data_model.dart';

class EachWhisketListView extends StatelessWidget {
  final TestWhiskeyDataModel whiskeyData;
  const EachWhisketListView({super.key, required this.whiskeyData});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 350,
        height: 110,
        padding: const EdgeInsets.only(bottom: 1, left: 1, right: 1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Flexible은 child widget이 parent widget의 공간에서
            // 차지하는 공간을 등분하여 얼만큼 나눠 가질 것인지 정할 수 있는 widet입니다.
            Flexible(
              flex: 2,
              child: SizedBox(
                width: 85,
                height: 120,
                child: Image.network(
                  whiskeyData.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20),
            //
            Flexible(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    whiskeyData.whiskeyName,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      Text(
                        "${whiskeyData.starRating}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        whiskeyData.whiskeyProducingArea,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        "${whiskeyData.whiskeyLcoholPercentagea}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Flexible(
                    fit: FlexFit.tight, // 나머지 모든 공간을 차지
                    child: Container(
                      padding: EdgeInsets.only(left: 1, right: 1),
                      width: 250,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.grey),
                      child: Text(
                        whiskeyData.oneLineText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
