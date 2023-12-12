import 'dart:io';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';

class ImageScanAnimation extends StatefulWidget {
  const ImageScanAnimation(
      {Key? key,
      required this.imageFile,
      required this.width,
      required this.height})
      : super(key: key);
  final File imageFile;
  final double width;
  final double height;

  @override
  State<StatefulWidget> createState() {
    return ImageScanAnimationState();
  }
}

class ImageScanAnimationState extends State<ImageScanAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _animationStopped = false; // 스캔 애니메이션에서 사용할 코드
  bool scanning = false;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: new Duration(seconds: 1), vsync: this);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animateScanAnimation(true);
      } else if (status == AnimationStatus.dismissed) {
        animateScanAnimation(false);
      }
    });
    super.initState();
    sanAbilable();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(children: [
        Container(

          width: widget.width.w,
        height: widget.height.h,
        padding: EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Image.file(
            widget.imageFile,
              fit: BoxFit.fill,
            ),
          ),
        ),
        // ScannerAnimation( // 스캔 애니메이션이 필요할떄 사용할 코드
        //   _animationStopped,
        //   widget.width + 32,
        //   animation: _animationController,
        // ),
      ]),
    );
  }

  void sanAbilable() {
    if (!scanning) {
      animateScanAnimation(false);
      setState(() {
        _animationStopped = false;
        scanning = true;

      });
    } else {
      setState(() {
        _animationStopped = true;
        scanning = false;

      });
    }
  }

  void animateScanAnimation(bool reverse) {
    if (reverse) {
      _animationController.reverse(from: 1.0);
    } else {
      _animationController.forward(from: 0.0);
    }
  }


}

class ScannerAnimation extends AnimatedWidget {
  final bool stopped;
  final double width;

  const ScannerAnimation(
    this.stopped,
    this.width, {
    Key? key,
    required Animation<double> animation,
  }) : super(
          key: key,
          listenable: animation,
        );

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    final scorePosition = (animation.value * 440) + 16;

    Color color1 = ColorsManager.gray500;
    Color color2 = ColorsManager.gray500;

    if (animation.status == AnimationStatus.reverse) {
      color1 = ColorsManager.gray500;
      color2 = ColorsManager.gray500;
    }

    return Positioned(
      bottom: scorePosition,
      child: Opacity(
        opacity: (stopped) ? 0.0 : 1.0,
        child: Container(
          height: 3,
          width: width,
          decoration: BoxDecoration(
            boxShadow:[
              BoxShadow(
                color: Color(0xFFF),
                blurRadius: 5.0,
              )
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color1, color2],
            ),
          ),
        ),
      ),
    );
  }
}
