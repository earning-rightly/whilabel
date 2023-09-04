// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:whilabel/screens/global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/global/functions/text_field_styles.dart';

// ignore: must_be_immutable
class UserNameInputTextField extends StatelessWidget {
  UserNameInputTextField({
    Key? key,
    required this.nameTextController,
  }) : super(key: key);
  final TextEditingController nameTextController;
  String userNameInputWidgetTitle = "성함";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(
          userNameInputWidgetTitle,
          style: TextStyle(color: Colors.white),
        ),
        TextFormField(
            decoration: makeWhiskeyRegisterTextFieldStyle("", true),
            controller: nameTextController,
            validator: (value) => checkAbleNameRule(value)),
      ]),
    );
  }
}
