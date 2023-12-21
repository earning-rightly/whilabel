import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/screens/_constants/colors_manager.dart';
import 'package:whilabel/screens/_constants/path/svg_icon_paths.dart';
import 'package:whilabel/screens/_constants/text_styles_manager.dart';
import 'package:whilabel/screens/_constants/whilabel_design_setting.dart';
import 'package:whilabel/screens/_global/functions/button_style.dart';
import 'package:whilabel/screens/camera/page/take_picture_page.dart';
import 'package:whilabel/screens/camera/page/whisky_barcode_scan_page.dart';

import '../view_model/camera_view_model.dart';

class UnregisteredWhiskyPage extends StatefulWidget {
  /// 용도 : 바코드 인식 O, DB 매칭 X 일떄 이동하는 페이지
  /// 목적 : 유저에게 인식되지 않는 위스키를 등록할 수 있도록 유도하기 위해서
  /// 다음 버튼을 누르면 WhiskyCritiqueView()로 이동
  UnregisteredWhiskyPage({Key? key, required this.imageFile})
      : super(key: key);
  final File imageFile;

  @override
  State<UnregisteredWhiskyPage> createState() =>
      _WhiskyBarcodeRecognitionPageState();
}

class _WhiskyBarcodeRecognitionPageState
    extends State<UnregisteredWhiskyPage> {
  String barcode = "";
  File? initImageFile;
  List<CameraDescription> cameras = [];

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CameraViewModel>();

    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          padding: EdgeInsets.only(left: 16),
          alignment: Alignment.centerLeft,
          icon: SvgPicture.asset(SvgIconPath.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 29.75.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AspectRatio(
                      aspectRatio: 1 / 1.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: SizedBox(
                          width: 343.w,
                          height: 427.h,
                          child:
                          Image.file(
                            widget.imageFile ,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 32.h),
                      Text("인식되지 않은 위스키",   style: TextStylesManager.createHadColorTextStyle(
                        "B14", ColorsManager.brown100,),),
                      SizedBox(height: 8),
                      Text("위라벨 팀이 검토 후 나머지 정보를\n 빠르게 채워드릴게요!", textAlign: TextAlign.center,
                          style: TextStylesManager.bold20
                      ),
                      SizedBox(height: 8),
                      Text("푸시 알림을 허용하면 알림을 받아 볼 수 있어요!",style: TextStylesManager.createHadColorTextStyle(
                        "R12", ColorsManager.gray,)),
                    ],
                  ),
                ],
              ),
              Positioned(
                  bottom: 0,
                  child: Container(
                    // alignment: ,

                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: OutlinedButton(
                              onPressed: () async{
                                     Navigator.pushReplacement(
                                       context,
                                       MaterialPageRoute(
                                         builder: (context) =>
                                             WhiskyBarCodeScanPage(
                                               cameras: viewModel.state.cameras,
                                             ),
                                       ),);
                              },
                              child: Text(
                                "다시찍기",
                                style: TextStylesManager.bold16,
                              ),
                              style: createBasicButtonStyle(
                                ColorsManager.black300,
                                buttonSize: Size(120, 53),
                              ),
                            ),
                          ),
                        ),
                        // 공유하기 기능을 만들면 추가
                        SizedBox(width: WhilabelSpacing.space12),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            child: ElevatedButton(
                              onPressed: () async{

                                Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                             builder: (context) =>
                                                 TakePicturePage(
                                                   cameras: viewModel.state.cameras,
                                                 ),
                                           ),
                                         );
                              },
                              child: Text(
                                "다음",
                                style: TextStylesManager.bold16,
                              ),
                              style: createBasicButtonStyle(
                                ColorsManager.brown100,
                                buttonSize: Size(120, 53),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}