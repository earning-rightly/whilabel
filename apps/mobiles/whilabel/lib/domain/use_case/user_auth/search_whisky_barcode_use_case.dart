import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/domain/whisky_brand_distillery/whisky_brand_distillery_repository.dart';

class SearchWhiskeyBarcodeUseCase {
  // AuthUser _loginUserInfo = AuthUser(
  //   uid: "",
  //   displayName: "",
  //   email: "",
  //   photoUrl: "",
  //   snsType: SnsType.EMPTY,
  // );

  final AppUserRepository appUserRepository;
  final WhiskyBrandDistilleryRepository whiskyBrandDistilleryRepository;

  SearchWhiskeyBarcodeUseCase({
    required this.appUserRepository,
    required this.whiskyBrandDistilleryRepository,
  });

  // Future<Pair<bool, bool>> call(SnsType snsType) async {
  //   return Pair(true, false);
  // }

  Future<ArchivingPost?> getSearchedWhiskyDataResult(String barcode) async {
    List<Distillery> _distilleryData = [];
    List<String> wbDistilleryIds = [];
    DateTime dt = DateTime.now();

    final whiskyData =
        await whiskyBrandDistilleryRepository.getWhiskyData(barcode);

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
        //  whiskyData.wbDistilleryIds가 null able이기 때문에 타입 변화
        whiskyData.wbWhisky?.wbDistilleryIds!.forEach(
          (element) {
            wbDistilleryIds.add(element.toString());
          },
        );
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
        strength: whiskyData.strength ?? whiskyData.wbWhisky?.strength,
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

    // final whiskeyBrandData = await whiskeyRepository.getBrandData(wbId);
    // final _whiskeyDistilleryData =
    //     await whiskeyRepository.getDistilleryData(wbId);

    // if (whiskeyBrandData == null) return Future(() => null);
    // final ArchivingPost result = ArchivingPost(
    //   distillery:
    //       _whiskeyDistilleryData ?? Distillery.createEmptyDistilleryData(),
    //   contury: whiskeyBrandData.wbBrand!.country,
    //   uid: "",
    //   barcode: "",
    //   modifyDate: dt.toString(),
    //   starValue: 3,
    //   createDate: Timestamp.now(),
    //   wbId: whiskeyBrandData.wbId.toString(),
    //   whiskeyName: whiskeyBrandData.wbBrand!.name.toString(),
    //   imageUrl: "",
    // );

    return null;
  }

  Future<List<Distillery>> _getDistilleryDatas(
      List<String> wbDistilleryIds) async {
    List<Distillery> distilleryDatas = [];

    for (String wbDistilleryId in wbDistilleryIds) {
      final _distilleryData = await whiskyBrandDistilleryRepository
          .getDistilleryData(wbDistilleryId);
      if (_distilleryData != null) distilleryDatas.add(_distilleryData);
    }
    // print(distilleryDatas);

    return distilleryDatas;
  }
}
