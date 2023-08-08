import 'package:flutter/material.dart';

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
        children: <Widget>[Text("리스트"), Text("그리드")],
      ),
    );
  }
}
