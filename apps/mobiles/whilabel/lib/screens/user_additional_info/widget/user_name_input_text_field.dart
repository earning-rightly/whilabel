// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:whilabel/screens/constants/colors_manager.dart';
import 'package:whilabel/screens/constants/text_styles_manager.dart';
import 'package:whilabel/screens/_global/functions/text_feild_rules.dart';
import 'package:whilabel/screens/_global/functions/text_field_styles.dart';

typedef StringValueSetter<String> = void Function(String? value);

// ignore: must_be_immutable
class UserNameInputTextField extends StatefulWidget {
  UserNameInputTextField({
    Key? key,
    required this.nameTextController,
  }) : super(key: key);

  final TextEditingController nameTextController;

  @override
  State<UserNameInputTextField> createState() => _UserNameInputTextFieldState();
}

class _UserNameInputTextFieldState extends State<UserNameInputTextField> {
  String userNameInputWidgetTitle = "성함";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            userNameInputWidgetTitle,
            style: TextStylesManager()
                .createHadColorTextStyle("B14", ColorsManager.gray500),
          ),
          SizedBox(height: 12),
          TextFormField(
            style: TextStylesManager()
                .createHadColorTextStyle("R16", ColorsManager.gray500),
            decoration: createBasicTextFieldStyle("", true),
            controller: widget.nameTextController,
            validator: (value) => checkAbleNameRule(value),
          )
        ],
      ),
    );
  }
}
