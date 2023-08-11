import 'package:flutter/material.dart';
import 'package:whilabel/test_data/test_whiskey_data_list.dart';
import 'package:whilabel/screens/home/list/widgets/each_whiskey_list_view.dart';
import 'package:whilabel/screens/home/list/widgets/whiskey_aligned_button_list.dart';

class ListWhiskeyView extends StatelessWidget {
  const ListWhiskeyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          // 리스트에서 사용할 위스키 정렬 버튼
          Container(height: 28, child: WhiskeyAlignedButtonList()),
          // 일정 공간에 띄어지게 하기위해서
          SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              itemCount: testWhiskeyDataList.length,
              itemBuilder: (context, index) {
                return EachWhisketListView(
                  whiskeyData: testWhiskeyDataList[index],
                );
              },
              separatorBuilder: (context, index) {
                return Column(
                  children: [
                    SizedBox(height: 10),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
