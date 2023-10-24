import 'package:flutter/material.dart';
import 'package:whilabel/screens/user_additional_info/nick_name_attional_page.dart';

// UserInfoAdditionalView의 view model과 이름이 햇갈리지 읺기 위해서
// 추가 정보 페이지를 my 페이지에서 유저 정보 수정에서 사용할 가능성 있음
class UserAdditionalInfoView extends StatelessWidget {
  const UserAdditionalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return NickNameAttionalPage();
  }
}
