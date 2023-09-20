import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/data/user/enum/gender.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/routes_manager.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/global/widgets/long_text_button.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_event.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_view_model.dart';
import 'package:whilabel/screens/user_additional_info/widget/gender_choicer.dart';
import 'package:whilabel/screens/user_additional_info/widget/user_birth_date_picker.dart';
import 'package:whilabel/screens/user_additional_info/widget/user_name_input_text_field.dart';

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
    final viewModel = context.watch<UserAdditionalInfoViewModel>();

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
          AppUser currentUser = snapshot.data!;

          return Padding(
            padding: WhilablePadding.basicPadding,
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
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.height,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 유저 닉네임 보여주는 widgeet
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: Text(
                                  "${widget.nickName}님에 대해서\n조금만 더 알려주세요",
                                  style: TextStylesManager()
                                      .createHadColorTextStyle(
                                          "B24", ColorsManager.gray500),
                                ),
                              ),
                            ),
                            //이름 입력
                            UserNameInputTextField(
                                nameTextController: nameTextController),
                            // // 성별 선택
                            GenderChoicer(
                              isFemalePressed: widget.isFemalePressed,
                              isManPressed: widget.isManPressed,
                              onPressedFemale: onPressedFemaleButton,
                              onPressedMan: onPressedManButton,
                            ),
                            // 생일 입력 받기
                            UserBirthDatePicker(
                              birthDayTextController: birthDayTextController,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 24,
                      left: 0,
                      right: 0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 52,
                        child: LongTextButton(
                          buttonText: "다음",
                          color: ColorsManager.brown100,
                          onPressedFunc: isfilledAllData
                              ? () {
                                  AppUser newUser = currentUser.copyWith(
                                      nickname: widget.nickName,
                                      birthDay: birthDayTextController.text,
                                      gender: widget.gender,
                                      name: nameTextController.text);

                                  viewModel.onEvent(
                                    AddUserInfo(newUser),
                                    callback: () {
                                      Navigator.pushNamed(
                                          context, Routes.homeRoute);
                                    },
                                  );
                                }
                              : null,
                        ),
                      ),
                    )
                  ],
                ),
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
    bool isNameVaild = false;

    if (nameTextController.text != "") {
      isfilledName = true;
      String? erroMessage = checkAbleNameRule(nameTextController.text);
      if (erroMessage == null) isNameVaild = true;
    }

    if (birthDayTextController.text != "") isfilledBirthDay = true;

    return (isfilledName && isfilledBirthDay && isNameVaild);
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
