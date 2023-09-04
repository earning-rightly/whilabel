import 'package:flutter/material.dart';
import 'package:whilabel/screens/global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/global/functions/text_field_styles.dart';
import 'package:whilabel/screens/user_info_additional/rest_info_additional_page.dart';

class NickNameAttionalPage extends StatefulWidget {
  const NickNameAttionalPage({super.key});

  @override
  State<NickNameAttionalPage> createState() => _NickNameAttionalPageState();
}

class _NickNameAttionalPageState extends State<NickNameAttionalPage> {
  final _formKey = GlobalKey();
  final nickNameText = TextEditingController();
  String userNickname = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close_fullscreen),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
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
                      decoration: makeWhiskeyRegisterTextFieldStyle(
                          "[한글, 영어, 숫자, _ ] 만 가능", true),
                      validator: (value) => checkAbleNickNameRule(value!),
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RestInfoAddtionalPage(nickName: userNickname),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
