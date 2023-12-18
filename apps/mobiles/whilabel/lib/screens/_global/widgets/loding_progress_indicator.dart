import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomLoadingIndicator{

 static  Future<void> showLodingProgress() async{
   EasyLoading.show(
     maskType: EasyLoadingMaskType.black,
     dismissOnTap: true,
     indicator:
     LoadingAnimationWidget.threeArchedCircle(
       color: Colors.grey,
       size: 50,),
   );
  }
  static void dimissonProgress({int milliseconds = 3000}){

    if (EasyLoading.isShow) {
      Timer(Duration(milliseconds: milliseconds), () {
        EasyLoading.dismiss();
      });
    }

  }


}





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
          Center(
            child: LoadingAnimationWidget.threeArchedCircle(
              color: Colors.grey,
              size: 50,
            ),
          ),
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
