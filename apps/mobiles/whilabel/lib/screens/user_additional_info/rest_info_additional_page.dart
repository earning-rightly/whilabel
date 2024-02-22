import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:intl/intl.dart';
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

  Gender? gender;

  @override
  State<RestInfoAddtionalPage> createState() => _RestInfoAddtionalPageState();
}

class _RestInfoAddtionalPageState extends State<RestInfoAddtionalPage> {
  final _formKey = GlobalKey<FormState>();
  final nameTextController = TextEditingController();
  final birthDayTextController = TextEditingController();

  bool isIOS = foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;
  bool isfilledAllData = foundation.defaultTargetPlatform == foundation.TargetPlatform.iOS;

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
                          if (!isIOS)
                            UserNameInputTextField(nameTextController: nameTextController),
                          // // 성별 선택
                          GenderChoicer(
                            gender: widget.gender,
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
                          debugPrint("click 다음");

                          debugPrint("appUser ${currentUserStatus.state.appUser?.toJson().toString()}");
                          debugPrint("widget ${widget.gender} ${widget.nickName}");

                          AppUser newUser = currentUserStatus.state.appUser!.copyWith(
                              nickName: widget.nickName,
                              birthDay: getBirthDay(),
                              gender: widget.gender,
                              name: isIOS ? "apple" : nameTextController.text);

                          debugPrint("newUser is ${newUser.toJson().toString()}");

                          viewModel.onEvent(
                            AddUserInfo(newUser),
                            callback: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                Routes.onBoardingRoute,
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
    if (isIOS) return true;

    bool isfilledName = false;
    bool isNameVaild = false;

    if (nameTextController.text != "") {
      isfilledName = true;
      String? erroMessage = checkAbleNameRule(nameTextController.text);
      if (erroMessage == null) isNameVaild = true;
    }

    return (isfilledName && isNameVaild);
  }

  //GenderChoicer()에서에 파라미터로 보내서 부모 state를 변동 시킨다.
  void onPressedMaleButton() {
    setState(() {
      widget.gender = Gender.MALE;
    });
  }

  //GenderChoicer()에서에 파라미터로 보내서 부모 state를 변동 시킨다.
  void onPressedFemaleButton() {
    setState(() {
      widget.gender = Gender.FEMALE;
    });
  }

  // 만약 20살 이하로 나오면 null 값 세팅
  String? getBirthDay() {
    DateTime now = DateTime.now();
    DateTime twentyOld = DateTime(now.year - 20, now.month, now.day);
    DateTime birthDay = DateFormat("yyyy-MM-dd").parse(birthDayTextController.text);

    return birthDay.isBefore(twentyOld) ? birthDayTextController.text : null;
  }
}
