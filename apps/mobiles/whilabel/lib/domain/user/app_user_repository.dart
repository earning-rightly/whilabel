import 'package:whilabel/data/user/app_user.dart';

abstract class AppUserRepository {
  Future<AppUser?> getCurrentUser(); // Singleton 객체를 가져옴

  Future<void> insertUser(AppUser user);
  Future<AppUser?> findUser(String uid);
  Future<void> updateUser(AppUser user);
  Future<bool> existUser(String nickname);
}
