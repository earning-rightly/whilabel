import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/enum/post_sort_order.dart';
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
            // android: AndroidNotificationDetails(
            //   'high_importance_channel',
            //   'high_importance_notification',
            //   importance: Importance.max,
            //   icon: "@mipmap/notification",
            //
            //   color: Colors.black,
            //   // ledColor: Colors.red,
            //   colorized: false
            // ),
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

  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    print("\n\n messge : $message\n\n");
    print("-----------------------");
    // if (message.data['type'] == 'chat') {
    //   Navigator.pushNamed(context, '/chat',
    //     arguments: ChatArguments(message),
    //   );
    // }
  }

  @override
  void initState() {
    super.initState();
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
          HomeAppBar(myWhiskeyCounters: state.listTypeArchivingPosts.length),
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
