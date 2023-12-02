import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/data/whisky/short_whisky.dart';
import 'package:whilabel/data/whisky/whisky.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/domain/whisky_brand_distillery/whisky_brand_distillery_repository.dart';

class SearchWhiskeyDataUseCase {
  final AppUserRepository appUserRepository;
  final WhiskyBrandDistilleryRepository whiskyBrandDistilleryRepository;

  SearchWhiskeyDataUseCase({
    required this.appUserRepository,
    required this.whiskyBrandDistilleryRepository,
  });

  Future<ArchivingPost?> useWhiskyBarcode(String barcode) async {
    List<String> wbDistilleryIds = [];

    final whiskyData =
        await whiskyBrandDistilleryRepository.getWhiskyDataWithBarcode(barcode);

    // whisky데이터 있는지 확인
    if (whiskyData != null) {
      // distillery id 가 있는지 확인
      print(whiskyData.wbWhisky?.toJson());
      if (whiskyData.distilleryIds != null &&
          whiskyData.distilleryIds!.isNotEmpty) {
        whiskyData.distilleryIds!.forEach((element) {
          wbDistilleryIds.add(element.toString());
        });

        // distillery id가 없다면 wbDistillery Id가 있는지 확인
      } else if (whiskyData.wbWhisky?.wbDistilleryIds != null &&
          whiskyData.wbWhisky!.wbDistilleryIds!.isNotEmpty) {
        // whiskyData.wbWhisky?.wbDistilleryIds 타입이
        // List<String>일 경우 상요할 코드
        /* //  whiskyData.wbDistilleryIds가 null able이기 때문에 타입 변화
        whiskyData.wbWhisky?.wbDistilleryIds!.forEach(
        //   (element) {
        //     wbDistilleryIds.add(element.toString());
        //   },);
        */
      }

      // distillery 데이터를 받아온다.
      final _distilleryData = await _getDistilleryDatas(wbDistilleryIds);

      final ArchivingPost result = ArchivingPost(
        barcode: barcode,
        whiskyName: whiskyData.name ?? whiskyData.wbWhisky!.name,
        whiskyId: whiskyData.id,
        category: whiskyData.category ?? whiskyData.wbWhisky?.category,
        location: _distilleryData.isNotEmpty
            ? _distilleryData.first.country ??
                _distilleryData.first.wbDistillery?.country
            : null,
        strength:
             whiskyData.wbWhisky?.strength ?? 0.0,
        createAt: Timestamp.now(),
        modifyAt: Timestamp.now(),
        userId: "",
        note: "",
        starValue: 3,
        tasteFeature: TasteFeature(bodyRate: 3, flavorRate: 3, peatRate: 3),
        imageUrl: "",
        postId: "",
      );

      return result;
    }

    return null;
  }

  Future<List<ShortWhiskyData>> useWhiskyName(String whiskName) async {
    List<String> findedWhiskyNames = [""];
    print("getWhiskyDataWithName ==> $whiskName");

    List<ShortWhiskyData> result = [];
    WhiskyQueryDocumentSnapshot? starAtDoc;
    for (int i = 0; i < 6; i++) {
      final whiskyQueryDocs = await whiskyBrandDistilleryRepository
          .getWhiskyDataWithName(whiskName, findedWhiskyNames,
              startAtDoc: starAtDoc);
      for (WhiskyQueryDocumentSnapshot queryDoc in whiskyQueryDocs) {
        result.add(
          ShortWhiskyData(
            barcode: queryDoc.data.barcode ?? queryDoc.data.wbWhisky!.barcode!,
            name: queryDoc.data.name!,
            strength:
                queryDoc.data.wbWhisky?.strength ?? 0.0,

          ),
        );
        findedWhiskyNames.add(queryDoc.data.name!);
        findedWhiskyNames = findedWhiskyNames.toSet().toList();
      }
      if (whiskyQueryDocs.isNotEmpty) starAtDoc = whiskyQueryDocs.last;
    }

    print("result===> ${result.length}");
    result = result.toSet().toList();
    return result;
  }

  Future<List<Distillery>> _getDistilleryDatas(
      List<String> wbDistilleryIds) async {
    List<Distillery> distilleryDatas = [];

    for (String wbDistilleryId in wbDistilleryIds) {
      final _distilleryData = await whiskyBrandDistilleryRepository
          .getDistilleryData(wbDistilleryId);
      if (_distilleryData != null) distilleryDatas.add(_distilleryData);
    }

    return distilleryDatas;
  }
}
