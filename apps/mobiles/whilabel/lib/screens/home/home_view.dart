import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/_global/widgets/loding_progress_indicator.dart';
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
  bool isHasAnnouncement = false;
  var messageString = "";

  Future<void> initAlim() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      print("메세지 도착 => ${notification?.title}");

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
              icon: "@mipmap/notification",

              color: Colors.black,
              // ledColor: Colors.red,
              colorized: false
            ),
            iOS: DarwinNotificationDetails(badgeNumber: 1)
          ),
        );

        // setState(() {
        //   messageString = message.notification!.body!;
        //   print("Foreground 메시지 수신: $messageString");
        // });
      }
    });
  }

  void checkAnnouncement(CurrentUserStatus currentUserStatus){
    final _announcements = currentUserStatus.state.appUser?.announcements;
    if ( _announcements != null && _announcements.isNotEmpty) {
      print("1323323");
      setState(() {
        isHasAnnouncement = true;
      });

    }else{
      setState(() {
        isHasAnnouncement = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
   final currentUserStatus = context.read<CurrentUserStatus>();
    checkAnnouncement(currentUserStatus);

    CustomLoadingIndicator.showLodingProgress();

    initAlim();
    _tabController =
        TabController(vsync: this, length: 2, animationDuration: Duration.zero);
    Future.microtask(() async {
      loadPostAsync();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void loadPostAsync() async {
    final viewModel = context.read<HomeViewModel>();

    await viewModel
        .onEvent(const HomeEvent.loadArchivingPost(PostButtonOrder.LATEST),callback:(){

      CustomLoadingIndicator.dimissonProgress(milliseconds: 2000);

    } );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();
    final state = viewModel.state;
    return SafeArea(
      child: Column(
        children: [
          HomeAppBar(myWhiskeyCounters: state.listTypeArchivingPosts.length, isHasAnnouncement: isHasAnnouncement),
          SizedBox(height: WhilabelSpacing.space20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: const BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: ColorsManager.black300, width: 1))),
            child: TabBar(
              controller: _tabController,
              indicatorColor: ColorsManager.gray500,
              labelColor: ColorsManager.gray500,
              unselectedLabelColor: ColorsManager.gray,
              tabs: [
                Tab(icon: SvgPicture.asset(SvgIconPath.list)),
                Tab(icon: SvgPicture.asset(SvgIconPath.grid)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: WhilabelPadding.basicPadding,
              child: TabBarView(controller: _tabController, children: const [
                ListArchivingPostPage(),
                GridArchivingPostPage()
              ]),
            ),
          )
        ],
      ),
    );
  }
}
