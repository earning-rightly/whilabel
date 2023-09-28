import 'package:whilabel/data/brand/brand.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/whisky/short_whisky.dart';
import 'package:whilabel/data/whisky/whisky.dart';

abstract class WhiskyBrandDistilleryRepository {
  Future<Whisky?> getWhiskyDataWithBarcode(String wbId);
  Future<List<WhiskyQueryDocumentSnapshot>> getWhiskyDataWithName(
      String name, List<String> findedWhiskyNames,
      {WhiskyDocumentSnapshot? startAtDoc});

  Future<Brand?> getBrandData(String wbId);
  Future<Distillery?> getDistilleryData(String wbId);
}
