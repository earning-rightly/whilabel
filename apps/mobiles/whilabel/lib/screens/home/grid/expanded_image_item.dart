import 'package:flutter/material.dart';
import 'package:popup_banner/src/slider_item.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';

class ExpandedImageItem extends StatelessWidget {
  final BuildContext context;
  final List<String> images;
  final bool fromNetwork;
  final double? height;
  final BoxFit fit;
  final Function(int) onClick;
  final AlignmentGeometry dotsAlignment;
  final Color dotsColorActive;
  final Color dotsColorInactive;
  final double dotsMarginBottom;
  final bool useDots;
  final bool autoSlide;
  final Widget? customCloseButton;
  final Duration slideChangeDuration;
  const ExpandedImageItem({
    Key? key,
    required this.context,
    required this.images,
    this.fromNetwork = true,
    this.height,
    this.fit = BoxFit.fill,
    required this.onClick,
    this.dotsAlignment = Alignment.bottomLeft,
    this.dotsColorActive = Colors.green,
    this.dotsColorInactive = Colors.grey,
    this.dotsMarginBottom = 10,
    this.useDots = true,
    this.slideChangeDuration = const Duration(seconds: 6),
    this.autoSlide = false,
    this.customCloseButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding:
          const EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: _dialogContent(context),
    );
  }

  Widget _dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: ColorsManager.black200,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 0.0,
                offset: Offset(0.0, 0.0),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SliderItem(
                  height: height ?? (MediaQuery.of(context).size.height * 0.8),
                  fromNetwork: fromNetwork,
                  fit: fit,
                  imageList: images,
                  dotsAlignment: dotsAlignment,
                  onClick: (index) => onClick(index),
                  useDots: useDots,
                  dotsColorActive: dotsColorActive,
                  dotsColorInactive: dotsColorInactive,
                  dotsMarginBottom: dotsMarginBottom,
                  autoSlide: autoSlide,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
