import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/screens/home/grid/widgets/each_whiskey_grid_view.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

class GridArchivingPostPage extends StatelessWidget {
  const GridArchivingPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    Map<String,List<ArchivingPost>> gridTypeArchivingPosts = viewModel.state.gridTypeArchivingPost;

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      itemCount: gridTypeArchivingPosts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.25,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),

      itemBuilder: (context, index) {
        // Map 형태인 gridTypeArchivingPosts의 key 값들을 순서대로 꺼내온다
        final whiskeyName = gridTypeArchivingPosts.keys.elementAt(index);

        return EachWhiskeyGridView(
          whiskeyNameGroupedArchivingPosts: gridTypeArchivingPosts[whiskeyName]!,
        );
      },
    );
  }
}
