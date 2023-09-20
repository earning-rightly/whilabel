import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_event.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_state.dart';

class WhiskyCritiqueViewModel with ChangeNotifier {
  final CurrentUserStatus _currentUserStatus;
  final WhiskyNewArchivingPostUseCase _whiskyNewArchivingPostUseCase;
  final ArchivingPostRepository _archivingPostRepository;
  WhiskyCritiqueViewModel({
    required CurrentUserStatus currentUserStatus,
    required WhiskyNewArchivingPostUseCase whiskyNewArchivingPostUseCase,
    required ArchivingPostRepository archivingPostRepository,
  })  : _currentUserStatus = currentUserStatus,
        _whiskyNewArchivingPostUseCase = whiskyNewArchivingPostUseCase,
        _archivingPostRepository = archivingPostRepository;

  late WhiskyCritiqueState _state = WhiskyCritiqueState(
      whiskyName:
          _whiskyNewArchivingPostUseCase.getState().archivingPost.whiskyName,
      strength:
          _whiskyNewArchivingPostUseCase.getState().archivingPost.strength!,
      image: _whiskyNewArchivingPostUseCase.getState().images!,
      whiskyLocation:
          _whiskyNewArchivingPostUseCase.getState().archivingPost.location,
      starValue: -1,
      tasteFeature: TasteFeature(bodyRate: 1, flavorRate: 1, peatRate: 1));

  WhiskyCritiqueState get state => _state;

  Future<void> onEvent(WhiskyCritiqueEvnet event,
      {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
            saveArchivingPostOnDb: saveArchivingPostOnDb,
            addTastNoteOnProvider: addTastNoteOnProvider,
            addStarValueOnProvider: addStarValueOnProvider,
            addTasteFeatureOnProvider: addTasteFeatureOnProvider)
        .then((_) => {after()});
  }

  Future<void> addTastNoteOnProvider(String tasteNote) async {
    _state = _state.copyWith(tasteNote: tasteNote);
    notifyListeners();
  }

  Future<void> addStarValueOnProvider(double starValue) async {
    _state = _state.copyWith(starValue: starValue);
    notifyListeners();
  }

  Future<void> addTasteFeatureOnProvider(TasteFeature tasteFeature) async {
    _state = _state.copyWith(tasteFeature: tasteFeature);
    notifyListeners();
  }

  Future<bool> isChangeStareValue() async {
    if (_state.starValue == -1) return false;
    return true;
  }

  Future<void> saveArchivingPostOnDb(
      double starValue, String note, TasteFeature tasteFeature) async {
    final timeStampNow = Timestamp.now();
    final appUser = await _currentUserStatus.getAppUser();
    final uuid = Uuid();

    ArchivingPost newArchivingPost =
        _whiskyNewArchivingPostUseCase.getState().archivingPost;
    final downloadUrl = await _SaveImageOnStorage(timeStampNow.toString());

    if (downloadUrl.isEmpty) {
      debugPrint("이미지 저장과정에서 오류가 일어났습니다.\n 앱을 다시 시작해 주세요");
    }
    newArchivingPost = newArchivingPost.copyWith(
      userId: appUser!.uid,
      postId: "${uuid.v1()}^${appUser.uid}}",
      createAt: timeStampNow,
      modifyAt: timeStampNow,
      starValue: starValue,
      note: note,
      tasteFeature: tasteFeature,
      imageUrl: downloadUrl,
    );
    _state = _state.copyWith(archivingPost: newArchivingPost);
    notifyListeners();
    try {
      _archivingPostRepository.insertArchivingPost(newArchivingPost);
    } catch (error) {
      debugPrint("archivingPost를 저장하는 과정에서 문제가 생겼습니다");
    }
  }

  Future<String> _SaveImageOnStorage(String imageName) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;
    final appUser = await _currentUserStatus.getAppUser();
    final imgageStoragePath =
        "${appUser!.snsType}/${appUser.uid}/$imageName.jpg";
    String downloadUrl = "";

    try {
      Reference ref = _storage.ref().child(imgageStoragePath);
      UploadTask uploadTask = ref.putFile(state.image!);
      TaskSnapshot snapshot = await uploadTask;
      downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      debugPrint("사진 저장 과정에서 문제가 발생하였습니다");
      debugPrint("$error");
    }
    return downloadUrl;
  }
}
