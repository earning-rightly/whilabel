import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/global/functions/text_field_styles.dart';
import 'package:whilabel/screens/global/widgets/app_bars.dart';
import 'package:whilabel/screens/global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/global/widgets/long_text_button.dart';
import 'package:whilabel/screens/user_additional_info/rest_info_additional_page.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_event.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_view_model.dart';
import 'package:whilabel/screens/global/functions/show_simple_dialog.dart';

class NickNameAttionalPage extends StatefulWidget {
  const NickNameAttionalPage({super.key});

  @override
  State<NickNameAttionalPage> createState() => _NickNameAttionalPageState();
}

class _NickNameAttionalPageState extends State<NickNameAttionalPage> {
  final _formKey = GlobalKey();
  final nickNameText = TextEditingController();
  String userNickname = "";
  String? erroMessage = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserAdditionalInfoViewModel>();

    final currentUserStatus = context.read<CurrentUserStatus>();
    return Scaffold(
      appBar: createScaffoldAppBar(context, SvgIconPath.close, ""),
      body: FutureBuilder<AppUser?>(
        future: currentUserStatus.getAppUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null || !snapshot.hasData) {
            return LodingProgressIndicator(
              offstage: true,
            );
          }
          return Padding(
            padding: WhilablePadding.basicPadding,
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
                          Text(
                            "닉네임을 설정해주세요",
                            style: TextStylesManager().createHadColorTextStyle(
                                "B24", ColorsManager.gray500),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          TextFormField(
                            style: TextStylesManager().createHadColorTextStyle(
                                "R16", ColorsManager.gray500),
                            maxLength: 20,
                            controller: nickNameText,
                            decoration: createBasicTextFieldStyle(
                                "[한글, 영어, 숫자, _ ] 만 가능", true),
                            validator: (value) {
                              erroMessage = checkAbleNickNameRule(value!);

                              return erroMessage;
                            },
                            onChanged: (value) {
                              setState(() {
                                userNickname = value;
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
                          onPressedFunc: erroMessage != null
                              ? null
                              : () {
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
                                                RestInfoAddtionalPage(
                                                    nickName: userNickname),
                                          ),
                                        );
                                      } else {
                                        String dialogSubTitle = "";

                                        if (viewModel.state.isAbleNickName ==
                                            false)
                                          dialogSubTitle = "중복된 닉네임입니다";
                                        if (viewModel.state.forbiddenWord != "")
                                          dialogSubTitle =
                                              "\"${viewModel.state.forbiddenWord}\" 는 금지어입니다";

                                        showSimpleDialog(context, "<닉네임 사용불가>",
                                            dialogSubTitle);
                                      }
                                    },
                                  );
                                }),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
