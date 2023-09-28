import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
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
        body:
            bottomNavigationBodyRoutes.elementAt(selectedBottomNavigationIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: ColorsManager.black300, width: 1.0)),
          ),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            backgroundColor: ColorsManager.black100,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  SvgIconPath.whisky,
                  colorFilter:
                      ColorFilter.mode(ColorsManager.black300, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  SvgIconPath.whisky,
                  colorFilter:
                      ColorFilter.mode(ColorsManager.brown100, BlendMode.srcIn),
                ),
                label: 'whisky',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  SvgIconPath.camera,
                  colorFilter:
                      ColorFilter.mode(ColorsManager.black300, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  SvgIconPath.camera,
                  colorFilter:
                      ColorFilter.mode(ColorsManager.brown100, BlendMode.srcIn),
                ),
                label: 'camera',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  SvgIconPath.user,
                  colorFilter:
                      ColorFilter.mode(ColorsManager.black300, BlendMode.srcIn),
                ),
                activeIcon: SvgPicture.asset(
                  SvgIconPath.user,
                  colorFilter:
                      ColorFilter.mode(ColorsManager.brown100, BlendMode.srcIn),
                ),
                label: 'myPage',
              ),
            ],
            currentIndex: selectedBottomNavigationIndex,
            selectedItemColor: ColorsManager.brown100,
            unselectedItemColor: ColorsManager.black100,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
