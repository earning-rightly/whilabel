import 'package:flutter/rendering.dart';
import 'package:whilabel/data/brand/brand.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/whisky/whisky.dart';
import 'package:whilabel/domain/whisky_brand_distillery/whisky_brand_distillery_repository.dart';

class FirebaseWhiskyBrandDistilleryRepositoryImpl
    implements WhiskyBrandDistilleryRepository {
  final WhiskyCollectionReference _whiskyRef;
  final BrandCollectionReference _brandRef;
  final DistilleryCollectionReference _distilleryRef;

  FirebaseWhiskyBrandDistilleryRepositoryImpl(
    this._whiskyRef,
    this._brandRef,
    this._distilleryRef,
  );

  // todo 나중에 barcode로 검색을 돌리는 로직으로 변동
  @override
  Future<Whisky?> getWhiskyDataWithBarcode(String barcode) async {
    WhiskyQueryDocumentSnapshot? whiskySnapshot;

    try {
      final _whiskyQuerySnapshot =
          await _whiskyRef.whereWbId(isEqualTo: barcode).get();

      if (_whiskyQuerySnapshot.docs.isEmpty) {
        debugPrint("whisky 데이터가 비어 있습니다.");

        return Future(() => null);
      }
      whiskySnapshot = _whiskyQuerySnapshot.docs.first;
    } catch (error) {
      debugPrint("whisky 데이터를 찾을 수 없습니다.");
      debugPrint("$error");
      return Future(() => null);
    }

    return whiskySnapshot.data;
  }

  @override
  Future<List<WhiskyQueryDocumentSnapshot>> getWhiskyDataWithName(
      String whiskyName, List<String> findedWhiskyNames,
      {WhiskyDocumentSnapshot? startAtDoc}) async {
    // WhiskyQueryDocumentSnapshot? whiskySnapshot;
    // List<ShortWhisky> shortWhisky = [];

    // List<String> findedWhiskyNames = [""];

    List<WhiskyQueryDocumentSnapshot> result;

    print("getWhiskyDataWithName ==> $findedWhiskyNames");

    try {
      final _whiskyQuerySnapshot = await _whiskyRef
          .whereName(isGreaterThanOrEqualTo: "Balven")
          .whereName(whereNotIn: findedWhiskyNames)
          // .orderByBarcode()
          // .orderByName()
          // .orderByBarcode()
          .limit(10)
          .get();
      // findedWhiskyNames.add(_whiskyQuerySnapshot.docs.first.data.name!);

      if (_whiskyQuerySnapshot.docs.isEmpty) {
        debugPrint("whisky 데이터가 비어 있습니다.");

        return Future(() => []);
      }
      print(
          "_whiskyQuerySnapshot.docs[6] ===> ${_whiskyQuerySnapshot.docs[6].data}");
      return _whiskyQuerySnapshot.docs;

      // for (WhiskyQueryDocumentSnapshot doc in _whiskyQuerySnapshot.docs)
      //   // print(doc.data.name);
      //   shortWhisky.add(ShortWhisky(
      //       barcode: doc.data.barcode!,
      //       name: doc.data.name!,
      //       strength: doc.data.strength!));
      // whiskySnapshot = _whiskyQuerySnapshot.docs.first;
    } catch (error) {
      debugPrint("whisky 데이터를 찾을 수 없습니다.");
      debugPrint("$error");
      return Future(() => []);
    }

    // return result;
  }

  @override
  Future<Brand?> getBrandData(String wbId) async {
    BrandQueryDocumentSnapshot? brandSnapshot;
    try {
      final _brandQuerySnapshot =
          await _brandRef.whereWbId(isEqualTo: wbId).get();
      if (_brandQuerySnapshot.docs.isEmpty) {
        debugPrint("brand 데이터가 비어 있습니다.");

        return Future(() => null);
      }

      brandSnapshot = _brandQuerySnapshot.docs.first;
    } catch (error) {
      debugPrint('brand 데이터를 찾을 수 없습니다');
      debugPrint('$error');
      return Future(() => null);
    }
    return brandSnapshot.data;
  }

  @override
  Future<Distillery?> getDistilleryData(String wbId) async {
    DistilleryQueryDocumentSnapshot? distillerySnapshot;

    try {
      final _distilleryQuerySnapshot =
          await _distilleryRef.whereWbId(isEqualTo: wbId).get();

      distillerySnapshot = _distilleryQuerySnapshot.docs.first;
    } catch (error) {
      debugPrint('distillery 데이터를 찾을 수 없습니다');
      debugPrint('$error');
      return Future(() => null);
    }

    return distillerySnapshot.data;
  }
}
