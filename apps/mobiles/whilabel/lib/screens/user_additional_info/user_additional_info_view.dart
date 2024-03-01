import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/routes_manager.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/show_dialogs.dart';
import 'package:whilabel/screens/_global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/user_additional_info/pages/rest_info_additional/rest_info_additional_page.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_event.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_view_model.dart';
import 'package:whilabel/screens/_global/functions/show_simple_dialog.dart';

// ignore: must_be_immutable
class UserAdditionalInfoView extends StatefulWidget {
  UserAdditionalInfoView({super.key, this.nickName});

  String? nickName;

  @override
  State<UserAdditionalInfoView> createState() => _UserAdditionalInfoViewState();
}

// UserInfoAdditionalView의 view model과 이름이 햇갈리지 읺기 위해서
// 추가 정보 페이지를 my 페이지에서 유저 정보 수정에서 사용할 가능성 있음
class _UserAdditionalInfoViewState extends State<UserAdditionalInfoView> {
  final _formKey = GlobalKey();
  late TextEditingController nickNameText =
      TextEditingController(text: widget.nickName);
  String userNickname = "";
  String? errorMessage = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserAdditionalInfoViewModel>();
    final currentUserStatus = context.read<CurrentUserStatus>();

    return Scaffold(
        appBar: buildScaffoldAppBar(context, SvgIconPath.close, ""),
        body: Padding(
          padding: WhilabelPadding.basicPadding,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "닉네임을 설정해주세요",
                          style: TextStylesManager.bold24,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                          style: TextStylesManager.regular16,
                          maxLength: 20,
                          controller: nickNameText,
                          decoration: createBasicTextFieldStyle(
                              hintText: "한글, 영문, 숫자, 언더바 가능",
                              paddingVertical: 12),
                          validator: (value) {
                            return errorMessage;
                          },
                          onChanged: (value) {
                            setState(() {
                              userNickname = value;
                              errorMessage = checkAbleNickNameRule(value);
                            });
                          },
                        )
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
                        enabled: errorMessage == null,
                        onPressedFunc: () {
                          if (widget.nickName.isNullOrEmpty == true) {
                            viewModel.onEvent(
                              CheckNickName(userNickname),
                              callback: () {
                                setState(() {});

                                if (viewModel.state.isAbleNickName &&
                                    viewModel.state.forbiddenWord == "") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RestInfoAdditionalPage(
                                              nickName: userNickname),
                                    ),
                                  );
                                } else {
                                  String dialogSubTitle = "";

                                  if (viewModel.state.isAbleNickName == false) {
                                    dialogSubTitle = "중복된 닉네임입니다";
                                  }
                                  if (viewModel.state.forbiddenWord != "") {
                                    dialogSubTitle =
                                        "\"${viewModel.state.forbiddenWord}\" 는 금지어입니다";
                                  }

                                  showSimpleDialog(
                                      context, "<닉네임 사용불가>", dialogSubTitle);
                                }
                              },
                            );
                          }
                          // MyPage에서 nickname을 수정하고자 할때 동작
                          // widget.nickName의 String이 있을 때
                          else {
                            final _user = currentUserStatus.state.appUser!
                                .copyWith(nickName: nickNameText.text);

                            showUpdatePostDialog(context,
                                onClickedYesButton: () {
                              viewModel.onEvent(
                                UserAdditionalInfoEvent.addUserInfo(_user),
                                callback: () {
                                  currentUserStatus.updateUserState();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.rootRoute,
                                    (route) => false,
                                  );
                                },
                              );
                            });
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
