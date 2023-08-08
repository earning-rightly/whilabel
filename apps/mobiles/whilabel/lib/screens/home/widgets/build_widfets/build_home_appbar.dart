import 'package:flutter/material.dart';

AppBar buildHomeAppbar(BuildContext context, int myWhiskeyCounters) {
  return AppBar(
    leadingWidth: 200,
    leading: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: "내가 마신 위스키",
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
                text: "\t\t$myWhiskeyCounters개",
                style: TextStyle(color: Colors.amber)),
          ],
        ),
      ),
    ),
    actions: [Icon(Icons.add_alert)],
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(30.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
        child: const TabBar(
          dividerColor: Colors.grey,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.list_rounded),
            ),
            Tab(
              icon: Icon(Icons.grid_view_rounded),
            ),
          ],
        ),
      ),
    ),
  );
}
