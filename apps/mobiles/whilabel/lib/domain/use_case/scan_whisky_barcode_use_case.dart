

import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';


class ScanWhiskyBarcodeUseCase {

  Future<File?> resizeImage(File imageFile) async {
    img.Image? decodedImage = img.decodeImage(imageFile.readAsBytesSync());
    final tempDir = await getTemporaryDirectory();
    // debugPrint("원본이미지 주소 =>>\n   ${imageFile.path}");
    debugPrint("width =>>   ${decodedImage?.width}");
    debugPrint("height =>>   ${decodedImage?.height}");

    if (decodedImage != null) {
      // cropRect에 해당하는 부분을 decodeImageFromList() 함수를 사용하여 decodedImage로 변환합니다.
      // 이미지의 사이즈, byte가 크면 이미지 전환과 스캔하는데 오랜 시간이 걸린다.
      img.Image thumbnail = img.copyResize(decodedImage,
          height: decodedImage.height > 1600 ? 1600 : decodedImage.height,
          width: decodedImage.width > 1200 ? 1200 : decodedImage.width);

      int testX = 0;
      int testY = thumbnail.height ~/ 4;
      var cropSizeX = thumbnail.width.toInt();
      var cropSizeY = thumbnail.height ~/ 2;

      img.Image cropImage = img.copyCrop(
        thumbnail,
        x: testX,
        y: testY,
        width: cropSizeX,
        height: cropSizeY,
      );
      Uint8List unit8ListPng = img.encodePng(cropImage);

      File SavedPngImage =
      File("${tempDir.path}/${Timestamp.now().millisecondsSinceEpoch}.png")
        ..writeAsBytes(unit8ListPng);
      debugPrint("\n\nresult ==> ${SavedPngImage.path}\n\n---");

      return SavedPngImage;


      // setState(() {
      //   isResizedImage = true;
      // });


      // Future.delayed(const Duration(milliseconds: 2000), () async {
      //   final _barcodeScanResult = await scanBarcodeImage(SavedPngImage.path);
      //   if (_barcodeScanResult == null) {
      //     // addBarcodeOnStream(strManger.SCAN_ERROR);
      //
      //     throw Exception("barcode scan error");
      //   } else {
      //     // addBarcodeOnStream(_barcodeScanResult);
      //   }
      // });
    }
    return null;
  }

  Future<String?> scanBarcodeImage(String imagePath) async {
    try {
      String? _barcodeString = await BarcodeFinder.scanFile(path: imagePath);
      if (_barcodeString != null) {
        debugPrint("barcode san 성공입니다!!");

        return _barcodeString;
      }
    } catch (e) {
      debugPrint("$e");
      throw Exception("barcode를 읽을 수 없습니다. 바코드로 인식이 불가능 합니다");

    }
    return null;
  }

}
