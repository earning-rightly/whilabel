import 'package:flutter/material.dart';
import 'package:whilabel/mock_data/mock_whiskey_data_model.dart';

class EachWhiskeyGridView extends StatelessWidget {
  final MockWhiskeyDataModel whiskeyData;

  const EachWhiskeyGridView({
    Key? key,
    required this.whiskeyData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(whiskeyData.imageUrl),
        ),
      ),
    );
  }
}
