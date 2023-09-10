import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_state.dart';
import 'package:whilabel/screens/global/functions/show_simple_dialog.dart';
import 'package:whilabel/screens/global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/global/functions/text_field_styles.dart';
import 'package:whilabel/screens/global/widgets/loding_progress_indicator.dart';
import 'package:whilabel/screens/user_additional_info/rest_info_additional_page.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_event.dart';

import 'view_model/user_additional_info_view_model.dart';

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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_fullscreen),
          onPressed: () {},
        ),
      ),
      body: FutureBuilder<AppUser?>(
        future: currentUserStatus.getAppUser(),
        builder: (context, snapshot) {
          if (snapshot.data == null || !snapshot.hasData) {
            return LodingProgressIndicator(
              offstage: true,
            );
          }
          return SafeArea(
            child: Stack(
              children: [
                Positioned(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        Text(
                          "닉네임을 설정해주세요",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
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
                  bottom: 0,
                  left: 0,
                  child: ElevatedButton(
                    child: Text("다음"),
                    onPressed: erroMessage != null
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

                                  if (viewModel.state.isAbleNickName == false)
                                    dialogSubTitle = "중복된 닉네임입니다";
                                  if (viewModel.state.forbiddenWord != "")
                                    dialogSubTitle =
                                        "\"${viewModel.state.forbiddenWord}\" 는 금지어입니다";

                                  showSimpleDialog(
                                      context, "<닉네임 사용불가>", dialogSubTitle);
                                }
                              },
                            );
                          },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
