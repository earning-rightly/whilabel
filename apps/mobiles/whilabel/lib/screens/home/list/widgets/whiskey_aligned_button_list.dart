import 'package:flutter/material.dart';

class WhiskeyAlignedButtonList extends StatefulWidget {
  const WhiskeyAlignedButtonList({super.key});

  @override
  State<WhiskeyAlignedButtonList> createState() =>
      _WhiskeyAlignedButtonListState();
}

class _WhiskeyAlignedButtonListState extends State<WhiskeyAlignedButtonList> {
  final List<WhiskeyAlignedButton> _buttons = [
    WhiskeyAlignedButton(
      buttonText: "최신순",
      index: 0,
    ),
    WhiskeyAlignedButton(
      buttonText: "오래된 순",
      index: 1,
    ),
    WhiskeyAlignedButton(
      buttonText: "평점 높은 순",
      index: 2,
    ),
    WhiskeyAlignedButton(
      buttonText: "평점 낮은 순",
      index: 3,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _buttons.length,
      itemBuilder: (context, index) {
        return Row(
          children: [
            _buttons[index],
            SizedBox(width: 5),
          ],
        );
      },
    );
  }
}

class WhiskeyAlignedButton extends StatelessWidget {
  final String buttonText;
  final int index;

  WhiskeyAlignedButton({
    super.key, // 이유없능 오류가 있기에 사용
    required this.buttonText,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(0),
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey)),
        fixedSize: buttonText.length * 14 < 90
            ? Size(buttonText.length * 14, 40)
            : Size(90, 40),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Center(
          child: Text(
            buttonText,
            maxLines: 1,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
