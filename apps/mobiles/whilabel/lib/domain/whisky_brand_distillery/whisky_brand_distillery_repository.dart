import 'package:whilabel/data/brand/brand.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/whisky/whisky.dart';

abstract class WhiskyBrandDistilleryRepository {
  Future<Whisky?> getWhiskyData(String wbId);
  Future<Brand?> getBrandData(String wbId);
  Future<Distillery?> getDistilleryData(String wbId);
}
