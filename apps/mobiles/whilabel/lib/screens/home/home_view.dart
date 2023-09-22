import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/home/grid/grid_whiskey_view.dart';
import 'package:whilabel/screens/home/list/list_archiving_post_page.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Tab> myTabs = <Tab>[
    Tab(
      icon: SvgPicture.asset(SvgIconPath.list),
    ),
    Tab(
      icon: SvgPicture.asset(SvgIconPath.grid),
    ),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    Future.microtask(() async {
      laodPostAsync();
    });
    if (EasyLoading.isShow) {
      Timer(Duration(milliseconds: 1000), () {
        EasyLoading.dismiss();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void laodPostAsync() async {
    final appUser = await context.read<CurrentUserStatus>().getAppUser();
    final viewModel = context.read<HomeViewModel>();

    await viewModel.loadArchivingPost(appUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          HomeAppBar(
            myWhiskeyCounters: 25,
          ),
          SizedBox(
            height: WhilabelSpacing.spac12,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 1))),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.grey,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: myTabs,
            ),
          ),
          Expanded(
            child: Padding(
              padding: WhilablePadding.basicPadding,
              child: TabBarView(
                  controller: _tabController,
                  children: [ListArchivingPostPage(), GridArchivingPostPage()]),
            ),
          )
        ],
      ),
    );
  }
}
