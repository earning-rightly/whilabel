import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';

class FirestoreUserRepositoryImpl implements AppUserRepository {
  final AppUserCollectionReference _ref;

  FirestoreUserRepositoryImpl(this._ref);

  @override
  Future<void> insertUser(AppUser user) async {
    _ref.add(user);
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    String? uid = _getCurrentUid();

    if (uid == null) return null;

    return await findUser(uid);
  }

  @override
  Future<void> updateUser(AppUser updateUser) async {
    String? uid = _getCurrentUid();

    if (uid == null) {
      return Future(() => null);
    }

    final userDoc = await _findUserDoc(uid);

    if (userDoc == null) {
      return Future(() => null);
    }

    String docId = userDoc.id;

    _ref.doc(docId).set(updateUser); // set, update 연산 성능 비교 필요
  }

  @override
  Future<AppUser?> findUser(String uid) async {
    final userSnapshot = await _findUserDoc(uid);

    if (userSnapshot == null) {
      debugPrint("유저 정보를 찾을 수 없습니다.");

      return Future(() => null);
    } else if (userSnapshot.data.isDeleted) {
      debugPrint("삭제를 요청한 유저입니다.");

      return Future(() => null);
    }

    return userSnapshot.data;
  }

  @override
  Future<bool> existUser(String nickname) async {
    final userSnapshot = await _ref
        .whereUid(isEqualTo: nickname)
        .whereIsDeleted(isEqualTo: false)
        .get();

    return !userSnapshot.docs.isEmpty;
  }

  String? _getCurrentUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return null;

    return currentUser.uid;
  }

  Future<AppUserQueryDocumentSnapshot?> _findUserDoc(uid) async {
    final querySnapshot = await _ref.whereUid(isEqualTo: uid).get();

    if (querySnapshot.docs.isEmpty) {
      return Future(() => null);
    }

    return querySnapshot.docs.first;
  }
}
