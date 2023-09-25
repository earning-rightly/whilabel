import 'package:flutter/material.dart';
import 'package:whilabel/data/taste/taste_feature.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_event.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_state.dart';

class WhiskyCritiqueViewModel with ChangeNotifier {
  final CurrentUserStatus _currentUserStatus;
  final WhiskyNewArchivingPostUseCase _whiskyNewArchivingPostUseCase;

  WhiskyCritiqueViewModel({
    required CurrentUserStatus currentUserStatus,
    required WhiskyNewArchivingPostUseCase whiskyNewArchivingPostUseCase,
    required ArchivingPostRepository archivingPostRepository,
  })  : _currentUserStatus = currentUserStatus,
        _whiskyNewArchivingPostUseCase = whiskyNewArchivingPostUseCase;

// 앞에서 검색해서 얻은 whisky 정보와 image 파일을
// _whiskyNewArchivingPostUseCase를 통해서 받아온다.
  late WhiskyCritiqueState _state = WhiskyCritiqueState(
      whiskyNewArchivingPostUseCaseState:
          _whiskyNewArchivingPostUseCase.getState(),
      starValue: -1,
      tasteFeature: TasteFeature(bodyRate: 1, flavorRate: 1, peatRate: 1));

  WhiskyCritiqueState get state => _state;

  Future<void> onEvent(WhiskyCritiqueEvnet event,
      {VoidCallback? callback}) async {
    VoidCallback after = callback ?? () {};
    event
        .when(
            saveArchivingPostOnDb: _saveArchivingPostOnDb,
            addTastNoteOnProvider: _storeTastNoteOnProvider,
            addStarValueOnProvider: _storeStarValueOnProvider,
            addTasteFeatureOnProvider: _storeTasteFeatureOnProvider)
        .then((_) => {after()});
  }

  Future<void> _storeTastNoteOnProvider(String tasteNote) async {
    _state = _state.copyWith(tasteNote: tasteNote);
    notifyListeners();
  }

  Future<void> _storeStarValueOnProvider(double starValue) async {
    _state = _state.copyWith(starValue: starValue);
    notifyListeners();
  }

  Future<void> _storeTasteFeatureOnProvider(TasteFeature tasteFeature) async {
    _state = _state.copyWith(tasteFeature: tasteFeature);
    notifyListeners();
  }

  Future<bool> isChangeStareValue() async {
    if (_state.starValue == -1) return false;
    return true;
  }

  Future<void> _saveArchivingPostOnDb(
      double starValue, String tasteNote, TasteFeature tasteFeature) async {
    final appUser = await _currentUserStatus.getAppUser();

    _whiskyNewArchivingPostUseCase.storeStarValue(starValue);
    _whiskyNewArchivingPostUseCase.storeTasteNote(tasteNote);
    _whiskyNewArchivingPostUseCase.storeTasteFeature(tasteFeature);

    await _whiskyNewArchivingPostUseCase.SaveNewArchivingPost(appUser!.uid);
  }
}
