import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/domain/global_provider/current_user_state.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/screens/user_info_additional/view_model/user_info_additional_event.dart';
import 'package:whilabel/screens/user_info_additional/view_model/user_info_additional_state.dart';

class UserInfoAdditionalViewModel with ChangeNotifier {
  final AppUserRepository _appUserRepository;
  final CurrentUserStatus _currentUserStatus;

  UserInfoAdditionalViewModel({
    required currentUserStatus,
    required appUserRepository,
  })  : _appUserRepository = appUserRepository,
        _currentUserStatus = currentUserStatus;

  UserInfoAdditionalState get state => _state;
  UserInfoAdditionalState _state =
      UserInfoAdditionalState(isAbleNickName: false, forbiddenWord: "");

// UI Event
  Future<void> onEvent(UserInfoAdditionalEvent event,
      {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
          addUserInfo: addUserInfo,
          checkNickName: checkNickName,
        )
        .then((_) => {after()});
  }

  Future<void> addUserInfo(AppUser appUser) async {
    _appUserRepository.updateUser(appUser);
    _currentUserStatus.updateUserState();

    notifyListeners();
  }

  Future<void> checkNickName(String nickName) async {
    //false가 반환되면 사용가능
    bool isExisted = await _appUserRepository.isExistedNickName(nickName);
    String forbiddenWord = await _checkContainedForbiddenWord(nickName);

    debugPrint("==== isExistedNickName result  =>> $isExisted");
    debugPrint("==== _checkContainedForbiddenWord result  =>> $forbiddenWord");

    if (isExisted == false && forbiddenWord.isEmpty) {
      _state = _state.copyWith(
        isAbleNickName: true,
        forbiddenWord: "",
      );
    } else {
      _state = _state.copyWith(
        isAbleNickName: false,
        forbiddenWord: forbiddenWord,
      );
    }

    notifyListeners();
  }

  Future<String> _checkContainedForbiddenWord(String nickName) async {
    Map<String, List<dynamic>> keyToListMap = {};
    String findedForbiddenWord = "";
    // 파이어 베이스 금지어 collection의 '1'문서에 연결
    final forbiddenWordStream =
        FirebaseFirestore.instance.collection('forbidden_word').doc('1');

    await forbiddenWordStream.get().then(
      (DocumentSnapshot doc) {
        // 각 키에 대한 값을 리스트로 저장할 맵을 생성합니다.
        final data = doc.data() as Map<String, dynamic>;

        // 데이터를 순회하면서 각 키에 해당하는 값을 리스트에 추가합니다.
        data.forEach((key, value) {
          if (value is List<dynamic>) {
            // 값이 리스트인 경우, 그대로 저장합니다.
            keyToListMap[key] = value;
          } else {
            // 값이 리스트가 아닌 경우, 새 리스트를 생성하고 값 추가
            keyToListMap[key] = [value];
          }
        });
      },
      onError: (e) => debugPrint("Error getting document: $e"),
    );

    keyToListMap.forEach((key, forbiddenWords) {
      for (String word in forbiddenWords) {
        if (nickName.contains(word)) {
          debugPrint("금자어 사용!!!");

          findedForbiddenWord = word;
          break;
        }
      }
    });

    return findedForbiddenWord;
  }
}
