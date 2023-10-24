import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';
import 'package:whilabel/screens/_global/widgets/app_bars.dart';
import 'package:whilabel/screens/_global/widgets/long_text_button.dart';
import 'package:whilabel/screens/user_additional_info/rest_info_additional_page.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_event.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_view_model.dart';
import 'package:whilabel/screens/_global/functions/show_simple_dialog.dart';

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
                          Text(
                            "닉네임을 설정해주세요",
                            style: TextStylesManager.bold24,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          TextFormField(
                            style: TextStylesManager.regular16,
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
          )
      );
  }
}
