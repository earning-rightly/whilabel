import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:barcode_finder/barcode_finder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ScanWhiskyBarcodeUseCase {
  Future<File?> resizeImage(File imageFile, {int resizedImageHeight = 800, int resizedImageWidth = 1000, int level = 0}) async {
    img.Image? decodedImage = img.decodeImage(imageFile.readAsBytesSync());
    final tempDir = await getTemporaryDirectory();

    debugPrint("base image's width =>>   ${decodedImage?.width}");
    debugPrint("base image's height =>>   ${decodedImage?.height}");

    if (decodedImage != null) {
      // cropRect에 해당하는 부분을 decodeImageFromList() 함수를 사용하여 decodedImage로 변환합니다.
      // 이미지의 사이즈, byte가 크면 이미지 전환과 스캔하는데 오랜 시간이 걸린다.


      int cropX = 0 + 20*level;
      int cropY = (decodedImage.height * 8 / 28).toInt();
      var cropWidthLength = decodedImage.width.toInt() - 20*level;
      var cropHeightLength = (decodedImage.height * 7 / 28).toInt() - 30*level ;

      img.Image cropImage = img.copyCrop(
        decodedImage,
        x: cropX, // 위에서 가장 왼쪽 꼭지점 (0,0), x축 시작점
        y: cropY, // 위에서 가장 왼쪽 꼭지점 (0,0), y축 시작점
        width: cropWidthLength < 0 ? 1000 :cropWidthLength , // x축 시작점에서 x축으로 이동할 거리
        height: cropHeightLength < 0 ? 800: cropHeightLength, // y축 시작점에서 y축으로 이동할 거리
      );

      img.Image thumbnail = img.copyResize(cropImage,
          height: decodedImage.height > resizedImageHeight ? resizedImageHeight : decodedImage.height,
          width: decodedImage.width > resizedImageWidth ? resizedImageWidth : decodedImage.width
          );

      Uint8List unit8ListPng = img.encodePng(thumbnail);
      File savedPngImage =
          File("${tempDir.path}/${Timestamp.now().millisecondsSinceEpoch}.png")
            ..writeAsBytes(unit8ListPng);
      debugPrint("\n\nresult ==> ${savedPngImage.path}\n---");



      return savedPngImage;

    }

  }

  Future<String?> scanBarcodeImage(String imagePath) async {

      String? _barcodeString = null;
      try {
        _barcodeString = await BarcodeFinder.scanFile(path: imagePath);
        if (_barcodeString != null) {
          debugPrint("barcode san 성공입니다!!");
          debugPrint("barcode스캔 결과 =>$_barcodeString!!");

          return _barcodeString;
        }
      } catch (e) {
        log("$e");
        throw Exception("barcode를 읽을 수 없습니다. 바코드로 인식이 불가능 합니다");
      } finally {
        // 예외가 발생되더라도, 항상 실행됩니다.
        return _barcodeString;


      }
  }

}
