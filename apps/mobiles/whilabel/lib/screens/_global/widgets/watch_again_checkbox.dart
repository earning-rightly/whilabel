import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:whilabel/screens/_constants/string_manger.dart'as strManger;


class WatchAgainCheckBox extends StatefulWidget {
  const WatchAgainCheckBox({Key? key, required this.boxKey}) : super(key: key);
  final String boxKey;
  @override
  State<WatchAgainCheckBox> createState() => _WatchAgainCheckBoxState();
}

class _WatchAgainCheckBoxState extends State<WatchAgainCheckBox> {
  bool? isChecked = false;
  final watchAgainCheckBox = Hive.box(strManger.WATCH_AGAIN_CHECKBOX);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: Colors.blueAccent,
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value;
        });
        watchAgainCheckBox.put(widget.boxKey, value);
      },
    );
  }
}