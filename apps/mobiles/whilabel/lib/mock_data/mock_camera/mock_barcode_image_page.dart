import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:whilabel/mock_data/mock_camera/mock_camera_view_modle.dart';


import '../_const/mock_images_path.dart';

class MockBarcodeImageTest extends StatefulWidget {
   MockBarcodeImageTest({Key? key}) : super(key: key);

  @override
  State<MockBarcodeImageTest> createState() => _MockBarcodeImageTestState();
}

class _MockBarcodeImageTestState extends State<MockBarcodeImageTest> {
  List<String> imageList = [imageMock1,imageMock2,imageMock3,imageMock4, imageMock5];

  List<String> imageLargeList = [imageMockLarge1,imageMockLarge2,imageMockLarge3,imageMockLarge4,imageMockLarge5];

  List<String> imageSmallList = [imageMockSmall1,imageMockSmall2,imageMockSmall3,imageMockSmall4,imageMockSmall5];
  int index = 0;

   @override
  Widget build(BuildContext context) {
     List<String> testList = List.from(imageSmallList);


     final mockCameraViewModel = context.watch<MockCameraViewModel>();

     return Scaffold(
      appBar: AppBar(title: Text("mock barcode image test")),
      body: SizedBox(child: Column(children: [
        SizedBox(
           height: 300,
            child: Image.asset(testList[index],)),
        Text("${testList[index]}"),
        OutlinedButton(onPressed: () async{
          final Directory directory = await getTemporaryDirectory();
          var bytes = await rootBundle.load(testList[index]);
          String imageName = testList[index].split('/').last;



          final File imageFile = await File('${directory.path}/$imageName.jpeg').writeAsBytes(
              bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
          await mockCameraViewModel.mockBarcodeLibaryTest(imageFile);
          await mockCameraViewModel.mockCleanMediums();

          if (index < 4) {
            setState(() {
              index++;
            });
          } else{
            print("index범위 초과");
          }
        }, child: Text("Text current image"))
      ],),),
    );
  }
}
