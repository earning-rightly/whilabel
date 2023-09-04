import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/screens/global/functions/text_field_styles.dart';

class UserBirthDatePicker extends StatefulWidget {
  const UserBirthDatePicker({
    Key? key,
    required this.birthDayTextController,
    this.onTapedFunc,
  }) : super(key: key);
  final TextEditingController birthDayTextController;
  final Function()? onTapedFunc;

  @override
  State<UserBirthDatePicker> createState() => _UserBirthDatePickerState();
}

class _UserBirthDatePickerState extends State<UserBirthDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "생년월일",
            style: TextStyle(color: Colors.white),
          ),
          GestureDetector(
            child: TextFormField(
              enabled: false,
              decoration: makeWhiskeyRegisterTextFieldStyle("", true),
              controller: widget.birthDayTextController,
            ),
            onTap: useDatePicker,
          ),
        ],
      ),
    );
  }

  useDatePicker() async {
    DateTime dateTime = DateTime.now();

// cupertino 패키지 함수
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  height: 230,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      onDateTimeChanged: (DateTime date) {
                        // 사용자가 선택한 날짜를 저장
                        setState(() {
                          dateTime = date;
                        });
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        widget.birthDayTextController.text =
                            "${dateTime.year}-${dateTime.month}-${dateTime.day}";
                      });

                      Navigator.pop(context);
                    },
                    child: Text("완료"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
