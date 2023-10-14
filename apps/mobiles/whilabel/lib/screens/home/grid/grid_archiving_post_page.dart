import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/post/short_archiving_post.dart';
import 'package:whilabel/screens/home/grid/widgets/each_whiskey_grid_view.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

class GridArchivingPostPage extends StatelessWidget {
  const GridArchivingPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    Map<String, List<ShortArchivingPost>> shortArchivingPostMap =
        viewModel.state.shortArchivingPostMap;

    return GridView.builder(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      itemCount: shortArchivingPostMap.keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.25,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final whiskyName = shortArchivingPostMap.keys.elementAt(index);

        return EachWhiskeyGridView(
          shortArchivingPosts: shortArchivingPostMap[whiskyName]!,
        );
      },
    );
  }
}
