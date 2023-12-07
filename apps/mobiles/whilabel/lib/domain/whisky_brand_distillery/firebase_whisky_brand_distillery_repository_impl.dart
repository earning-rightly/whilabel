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
          await _whiskyRef.whereBarcode(isEqualTo: barcode).get();

      if (_whiskyQuerySnapshot.docs.isEmpty) {
        debugPrint("whisky 데이터가 비어 있습니다.");
        debugPrint("\n\n $barcode로 위스키를 찾지 못 했습니다.\n\n");

        return Future(() => null);
      }
      whiskySnapshot = _whiskyQuerySnapshot.docs.first;
    } catch (error) {
      debugPrint("whisky 데이터를 찾을 수 없습니다.");
      debugPrint("\n\n $barcode로 위스키를 찾지 못 했습니다.\n\n");
      debugPrint("$error");

      return Future(() => null);
    }

// List에서 숫자만 추출합니다.
    // List<int> numbers = list.map((e) => int.parse(e)).toList();

// 추출한 숫자를 출력합니다.

    // print("dis id ${whiskySnapshot.data.wbWhisky?.distilleryName.toString()}");
    // print("distillery Name ${int.parse(list[1])}");
    // print("distillery Name list==~~ $list");

    return whiskySnapshot.data;
  }

  @override
  Future<List<WhiskyQueryDocumentSnapshot>> getWhiskyDataWithName(
      String whiskyName, List<String> findedWhiskyNames,
      {WhiskyDocumentSnapshot? startAtDoc}) async {
    print("getWhiskyDataWithName ==> $findedWhiskyNames");

    final _whiskyName = await _capitalizeFirstLetter(whiskyName);
    print("query start point ### ${startAtDoc.toString()}");

    try {
      final _whiskyQuerySnapshot = await _whiskyRef
          .whereName(isGreaterThanOrEqualTo: _whiskyName)
          .whereName(whereNotIn: findedWhiskyNames)
          // .orderByName(startAtDocument: startAtDoc)

          // .orderByBarcode()
          .limit(20)
          .get();
      // findedWhiskyNames.add(_whiskyQuerySnapshot.docs.first.data.name!);

      if (_whiskyQuerySnapshot.docs.isEmpty) {
        debugPrint("whisky 데이터가 비어 있습니다.");

        return Future(() => []);
      }
      // print(
      //     "_whiskyQuerySnapshot.docs[6] ===> ${_whiskyQuerySnapshot.docs[6].data}");
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
      debugPrint("$_whiskyName 라는 이름을 찾을 수 없습니다}");
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

  // 맨 앞의 문자만 대문자로 변환
  Future<String> _capitalizeFirstLetter(String str) async {
    if (str.isEmpty) {
      return str;
    }

    String firstLetter = str[0].toUpperCase();
    String restOfString = str.substring(1);

    return firstLetter + restOfString;
  }
}
