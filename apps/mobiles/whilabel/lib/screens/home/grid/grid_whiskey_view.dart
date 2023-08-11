import 'package:flutter/material.dart';
import 'package:whilabel/screens/home/grid/widgets/each_whiskey_grid_view.dart';
import 'package:whilabel/test_data/test_whiskey_data_list.dart';

class GrideWhiskeyView extends StatelessWidget {
  const GrideWhiskeyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        itemCount: testWhiskeyDataList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.25,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final whiskeyData = testWhiskeyDataList[index];
          return EachWhiskeyGridView(
            whiskeyData: whiskeyData,
          );
        },
      ),
    );
  }
}
