import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/whilabel_divier.dart';
import 'package:whilabel/screens/home/list/widgets/each_list_archiving_post_card.dart';
import 'package:whilabel/screens/home/list/widgets/whiskey_aligned_button_list.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

// enum ListOrder {
//   latest,
//   oldest,
//   highest_rating,
//   lowest_rating,
// }

class ListArchivingPostPage extends StatefulWidget {
  const ListArchivingPostPage({super.key});

  @override
  State<ListArchivingPostPage> createState() => _ListArchivingPostPageState();
}

class _ListArchivingPostPageState extends State<ListArchivingPostPage> {
  @override
  void initState() {
    super.initState();

    // laodPostAsync();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final state = viewModel.state;
    // final appUserInfo = context.read<CurrentUserStatus>().state.appUser;
    return Column(
      children: [
        // 리스트에서 사용할 위스키 정렬 버튼
        Container(height: 32, child: WhiskeyAlignedButtonList()),
        // // 일정 공간에 띄어지게 하기위해서
        SizedBox(height: WhilabelSpacing.spac16),

        Expanded(
            child: ListView.separated(
                itemCount: state.archivingPosts.length,
                itemBuilder: (context, index) {
                  return EachListArchivingPostCard(
                    archivingPost: state.archivingPosts[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 10),
                      // Divider(
                      //   color: ColorsManager.black200,
                      // ),
                      BasicDivider(),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  );
                }))
      ],
    );
  }
}
