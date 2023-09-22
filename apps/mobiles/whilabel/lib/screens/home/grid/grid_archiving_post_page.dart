import 'package:flutter/material.dart';
import 'package:whilabel/mock_data/mock_whiskey_data_list.dart';
import 'package:whilabel/screens/home/grid/widgets/each_whiskey_grid_view.dart';

class GridArchivingPostPage extends StatelessWidget {
  const GridArchivingPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        itemCount: mockWhiskeyDataList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 1.25,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          final whiskeyData = mockWhiskeyDataList[index];
          return EachWhiskeyGridView(
            whiskeyData: whiskeyData,
          );
        },
      ),
    );
  }
}
