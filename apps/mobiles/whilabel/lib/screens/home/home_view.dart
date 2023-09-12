import 'package:flutter/material.dart';
import 'package:whilabel/screens/camera/camera_view.dart';
import 'package:whilabel/screens/home/widgets/build_widfets/build_home_appbar.dart';
import 'package:whilabel/screens/home/widgets/home_tab_bar.dart';
import 'package:whilabel/screens/my_page/my_page_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // 바텀 네이게이션의 어떤 index가 선택되었는지 저장하는 변수
  int selectedBottomNavigationIndex = 0;

  final List<Widget> bottomNavigationBodyRoutes = <Widget>[
    HomeTabBar(),
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
  Widget build(BuildContext context) {
    int myWhiskeyCounters = 26;

    return DefaultTabController(
      // tabBar를 사용하기 필요한 widget
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: (() {
          switch (selectedBottomNavigationIndex) {
            case 0:
              return buildHomeAppbar(context, myWhiskeyCounters);
            case 1:
              return AppBar(
                title: Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "CAMER",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              );
            case 2:
              break;
          }
        })(),
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
