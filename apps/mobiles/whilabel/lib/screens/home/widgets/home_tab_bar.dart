import 'package:flutter/material.dart';
import 'package:whilabel/screens/home/grid/grid_whiskey_view.dart';
import 'package:whilabel/screens/home/list/list_archiving_post_page.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({super.key});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: TabBarView(
        children: <Widget>[ListArchivingPostPage(), GridArchivingPostPage()],
      ),
    );
  }
}
