import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/data/user/enum/gender.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
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

  bool isMale = true;

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
    final currentUserStatus = context.read<CurrentUserStatus>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(),
        body: Padding(
          padding: WhilabelPadding.basicPadding,
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
                                style: TextStylesManager.bold24,
                              ),
                            ),
                          ),
                          //이름 입력
                          UserNameInputTextField(
                              nameTextController: nameTextController),
                          // // 성별 선택
                          GenderChoicer(
                            isMale: widget.isMale,
                            onPressedFemale: onPressedFemaleButton,
                            onPressedMale: onPressedMaleButton,
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
                        enabled: isfilledAllData,
                        onPressedFunc: () {
                          AppUser newUser = currentUserStatus.state.appUser!.copyWith(
                              nickName: widget.nickName,
                              birthDay: birthDayTextController.text,
                              gender: widget.isMale ? Gender.MALE : Gender.FEMALE,
                              name: nameTextController.text);

                          viewModel.onEvent(
                            AddUserInfo(newUser),
                            callback: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.rootRoute,
                                (route) => false,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
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
  void onPressedMaleButton() {
    setState(() {
      widget.isMale = true;
    });
  }

  //GenderChoicer()에서에 파라미터로 보내서 부모 state를 변동 시킨다.
  void onPressedFemaleButton() {
    setState(() {
      widget.isMale = false;
    });
  }
}
