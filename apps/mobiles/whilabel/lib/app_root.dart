import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/camera/camera_view.dart';
import 'package:whilabel/screens/home/home_view.dart';
import 'package:whilabel/screens/my_page/my_page_view.dart';

class AppRoot extends StatefulWidget {
  const AppRoot({super.key});
  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  // 바텀 네이게이션의 어떤 index가 선택되었는지 저장하는 변수
  int selectedBottomNavigationIndex = 0;
  AppUser? appUser;
  final List<Widget> bottomNavigationBodyRoutes = <Widget>[
    HomeView(),
    CameraView(),
    MyPageView()
  ];

  void _onItemTapped(int index) {
    // widget내에서 state에 변화를 알려주기 위해서 사용하는 함수
    setState(() {
      selectedBottomNavigationIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initAsync();

    // Future.microtask(() async {
    //   appUser = await context.read<CurrentUserStatus>().getAppUser();
    // });
  }

  void initAsync() async {
    appUser = await context.read<CurrentUserStatus>().getAppUser();
  }

  @override
  Widget build(BuildContext context) {
    initAsync();

    return DefaultTabController(
      // tabBar를 사용하기 필요한 widget
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        // appBar: (() {
        //   switch (selectedBottomNavigationIndex) {
        //     case 0:
        //       // return buildHomeAppbar(context, myWhiskeyCounters);
        //       return buildHomeAppbar(context, myWhiskeyCounters);
        //     case 1:
        //       break;
        //     case 2:
        //       break;
        //   }
        // })(),
        body:
            bottomNavigationBodyRoutes.elementAt(selectedBottomNavigationIndex),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.wordpress_sharp),
              label: '위스키',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: '카메라',
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.square),
              label: '마이',
            ),
          ],
          currentIndex: selectedBottomNavigationIndex,
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.white,
          unselectedLabelStyle: TextStyle(
            color: Colors.grey,
          ),
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
