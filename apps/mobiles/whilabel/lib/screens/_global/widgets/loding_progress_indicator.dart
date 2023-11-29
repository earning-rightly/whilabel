import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LodingProgressIndicator extends StatelessWidget {
  final bool offstage;
  const LodingProgressIndicator({
    Key? key,
    required this.offstage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: offstage,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(
            child: LoadingAnimationWidget.threeArchedCircle(color: Colors.grey, size: 50),
          )
        ],
      ),
    );
  }
}
