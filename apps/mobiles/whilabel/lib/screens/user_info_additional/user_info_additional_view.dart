import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_state.dart';
import 'package:whilabel/screens/global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/user_info_additional/nick_name_attional_page.dart';

// UserInfoAdditionalView의 view model과 이름이 햇갈리지 읺기 위해서
// 추가 정보 페이지를 my 페이지에서 유저 정보 수정에서 사용할 가능성 있음
class UserInfoAdditionalView extends StatelessWidget {
  const UserInfoAdditionalView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserStatus = context.read<CurrentUserStatus>();

    return FutureBuilder<AppUser?>(
      future: currentUserStatus.getAppUser(),
      builder: (context, snapshot) {
        if (snapshot.data == null || !snapshot.hasData) {
          // 현재 유저 정보를 늦게 받아오면
          LodingProgressIndicator();
        }

        return NickNameAttionalPage();
      },
    );
  }
}
