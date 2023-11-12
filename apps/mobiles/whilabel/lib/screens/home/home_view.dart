import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/home/grid/grid_archiving_post_page.dart';
import 'package:whilabel/screens/home/list/list_archiving_post_page.dart';
import 'package:whilabel/screens/home/view_model/home_event.dart';
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
    Tab(icon: SvgPicture.asset(SvgIconPath.list)),
    Tab(icon: SvgPicture.asset(SvgIconPath.grid)),
  ];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    Future.microtask(() async {
      loadPostAsync();
    });
    if (EasyLoading.isShow) {
      Timer(const Duration(milliseconds: 1000), () {
        EasyLoading.dismiss();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loadPostAsync() async {
    final viewModel = context.read<HomeViewModel>();

    await viewModel
        .onEvent(const HomeEvent.loadArchivingPost(PostButtonOrder.LATEST));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final state = viewModel.state;
    return SafeArea(
      child: Column(
        children: [
          HomeAppBar(myWhiskeyCounters: state.archivingPosts.length),
          SizedBox(height: WhilabelSpacing.spac12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
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
              padding: WhilabelPadding.basicPadding,
              child: TabBarView(
                  controller: _tabController,
                  children: const [ListArchivingPostPage(), GridArchivingPostPage()]),
            ),
          )
        ],
      ),
    );
  }
}
