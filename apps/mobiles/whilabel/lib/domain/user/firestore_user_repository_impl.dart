import 'package:firebase_auth/firebase_auth.dart';
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

    if (userSnapshot == null || userSnapshot.data == null || userSnapshot.data.isDeleted) {
      return Future(() => null);
    }

    return userSnapshot.data;
  }

  @override
  Future<bool> existUser(String nickname) async {
    final userSnapshot = await _ref
      .where("nickname", isEqualTo: nickname)
      .where("isDeleted", isEqualTo: false)
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
