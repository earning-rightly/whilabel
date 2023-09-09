import 'package:flutter/material.dart';

class GenderChoicer extends StatefulWidget {
  const GenderChoicer({
    Key? key,
    this.onPressedMan,
    this.onPressedFemale,
    required this.isManPressed,
    required this.isFemalePressed,
  }) : super(key: key);
  final Function()? onPressedMan;
  final Function()? onPressedFemale;
  final bool isManPressed;
  final bool isFemalePressed;

  @override
  State<GenderChoicer> createState() => _GenderChoicerState();
}

class _GenderChoicerState extends State<GenderChoicer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        Text(
          "성함",
          style: TextStyle(color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 남성 버튼
            ElevatedButton(
              onPressed: widget.onPressedMan,
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.orange),
                // disabledBackgroundColor: Colors.black,
                fixedSize: Size(150, 70),
                backgroundColor:
                    widget.isManPressed ? Colors.orange : Colors.black,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              child: Text("남성"),
            ),
            // 여성 버튼
            ElevatedButton(
              onPressed: widget.onPressedFemale,
              style: ElevatedButton.styleFrom(
                side: BorderSide(color: Colors.orange),
                // disabledBackgroundColor: Colors.black,
                fixedSize: Size(150, 70),
                backgroundColor:
                    widget.isFemalePressed ? Colors.orange : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              child: Text("여성"),
            ),
          ],
        )
      ]),
    );
  }
}
