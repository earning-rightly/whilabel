import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/enum/gender.dart';
import 'package:whilabel/domain/global_provider/current_user_state.dart';
import 'package:whilabel/screens/global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/user_info_additional/widget/gender_choicer.dart';
import 'package:whilabel/screens/user_info_additional/widget/user_birth_date_picker.dart';
import 'package:whilabel/screens/user_info_additional/widget/user_name_input_text_field.dart';

// ignore: must_be_immutable
class RestInfoAddtionalPage extends StatefulWidget {
  RestInfoAddtionalPage({
    Key? key,
    required this.nickName,
  }) : super(key: key);
  final String nickName;

  bool isManPressed = true;
  bool isFemalePressed = false;
  Gender gender = Gender.Man;

  @override
  State<RestInfoAddtionalPage> createState() => _RestInfoAddtionalPageState();
}

class _RestInfoAddtionalPageState extends State<RestInfoAddtionalPage> {
  final _formKey = GlobalKey<FormState>();
  final nameTextController = TextEditingController();
  final birthDayTextController = TextEditingController();
  bool isfilledAllData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: FutureBuilder(
        future: context.read<CurrentUserStatus>().getAppUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return LodingProgressIndicator(
              offstage: true,
            );
          }

          return SafeArea(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: () {
                setState(() {
                  // 각 textField의 onChanged 함수들보다 느리게 트리거되게 하기 위함.
                  Future.microtask(() {
                    isfilledAllData = checkUserDataFill();
                  });
                });
              },
              child: Column(
                children: [
                  Text(
                    "${widget.nickName}님에 대해서 조금만 더 알려주세요",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                  // 이름 입력
                  UserNameInputTextField(
                    nameTextController: nameTextController,
                  ),
                  // 성별 선택
                  GenderChoicer(
                    isFemalePressed: widget.isFemalePressed,
                    isManPressed: widget.isManPressed,
                    onPressedFemale: onPressedFemaleButton,
                    onPressedMan: onPressedManButton,
                  ),
                  UserBirthDatePicker(
                    birthDayTextController: birthDayTextController,
                  ),
                  SizedBox(
                    height: 20,
                  ),

                  ElevatedButton(onPressed: () {}, child: Text("저장하기"))
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool checkUserDataFill() {
    bool isfilledName = false;
    bool isfilledBirthDay = false;

    if (nameTextController.text != "") isfilledName = true;
    if (birthDayTextController.text != "") isfilledBirthDay = true;

    return (isfilledName && isfilledBirthDay);
  }

  //GenderChoicer()에서에 파라미터로 보내서 부모 state를 변동 시킨다.
  void onPressedManButton() {
    setState(() {
      widget.isFemalePressed = false;
      widget.isManPressed = true;
      widget.gender = Gender.Man;
    });
  }

  //GenderChoicer()에서에 파라미터로 보내서 부모 state를 변동 시킨다.
  void onPressedFemaleButton() {
    setState(() {
      widget.isFemalePressed = true;
      widget.isManPressed = false;
      widget.gender = Gender.FEMALE;
    });
  }
}
