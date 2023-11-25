import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:whilabel/data/brand/brand.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/post/same_kind_whisky.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/data/whisky/whisky.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/post/firebase_same_kind_whisky_repository_impl.dart';
import 'package:whilabel/domain/post/same_kind_whisky_repository.dart';
import 'package:whilabel/domain/use_case/short_archiving_post_use_case.dart';
import 'package:whilabel/domain/use_case/load_archiving_posts_use_case.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/domain/post/firebase_archiving_post_repository_impl.dart';
import 'package:whilabel/domain/use_case/user_auth/login_use_case.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/domain/use_case/search_whisky_data_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/domain/user/firestore_user_repository_impl.dart';
import 'package:whilabel/domain/whisky_brand_distillery/firebase_whisky_brand_distillery_repository_impl.dart';
import 'package:whilabel/domain/whisky_brand_distillery/whisky_brand_distillery_repository.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_view_model.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';
import 'package:whilabel/screens/my_page/view_model/my_page_view_model.dart';
import 'package:whilabel/screens/user_additional_info/view_model/user_additional_info_view_model.dart';
import 'package:whilabel/screens/whisky_critique/view_model/whisky_critique_view_model.dart';

class ProvidersManager {
  static final AppUserCollectionReference appUserRef = usersRef;
  static final AppUserRepository _appUserRepository =
      FirestoreUserRepositoryImpl(appUserRef);
  static final WhiskyCollectionReference _whiskyRef = whiskyRef;
  static final BrandCollectionReference _brandRef = brandRef;
  static final DistilleryCollectionReference _distilleryRef = distilleryRef;
  static final ArchivingPostCollectionReference _archivingPostRef =
      archivingPostRef;

  static final SameKindWhiskyCollectionReference _sameKindWhiskyRef =
      sameKindWhiskyRef;

  static final _currentUserStatus = CurrentUserStatus(_appUserRepository);
  static final WhiskyBrandDistilleryRepository
      _whiskyBrandDistilleryRepository =
      FirebaseWhiskyBrandDistilleryRepositoryImpl(
          _whiskyRef, _brandRef, _distilleryRef);

  static final ArchivingPostRepository _archivingPostRepository =
      FirestoreArchivingPostRepositoryImple(_archivingPostRef);
  static final SameKindWhiskyRepository _sameKindWhiskyRepository =
      FirestoreSameKindWhiskyRepositoryImple(
          sameKindWhiskyRef: _sameKindWhiskyRef);
  // use case provider
  static final _loginUseCase = LoginUseCase(
      appUserRepository: _appUserRepository,
      currentUserStatus: _currentUserStatus,
      shortArchivingPostUseCase: shortArchivingPostUseCase);
  static final _logoutUseCase = LogoutUseCase(
    currentUserStatus: _currentUserStatus,
  );
  static final _searchWhiskeyBarcodeUseCase = SearchWhiskeyDataUseCase(
    appUserRepository: _appUserRepository,
    whiskyBrandDistilleryRepository: _whiskyBrandDistilleryRepository,
  );
  static final shortArchivingPostUseCase = ShortArchivingPostUseCase(
      sameKindWhiskyRepository: _sameKindWhiskyRepository);
  static final whiskeyNewArchivingPostUseCase = WhiskyNewArchivingPostUseCase(
    archivingPostRepository: _archivingPostRepository,
    appUserRepository: _appUserRepository,
    shortArchivingPostUseCase: shortArchivingPostUseCase,
  );
  static final _loadArchivingPostUseCase = LoadArchivingPostsUseCase(
    archivingPostRepository: _archivingPostRepository,
  );

  static List<SingleChildWidget> initialProviders() {
// view model Provider
    final loginViewModel = LoginViewModel(_loginUseCase, _logoutUseCase);

    final userAdditionalInfoViewModel = UserAdditionalInfoViewModel(
      appUserRepository: _appUserRepository,
      currentUserStatus: _currentUserStatus,
    );
    final carmeraViewModel = CarmeraViewModel(
      searchWhiskeyDataUseCase: _searchWhiskeyBarcodeUseCase,
      archivingPostStatus: whiskeyNewArchivingPostUseCase,
    );

    final homeViewModel = HomeViewModel(
      loadArchivingPostUseCase: _loadArchivingPostUseCase,
      archivingPostRepository: _archivingPostRepository,
      shortArchivingPostUseCase: shortArchivingPostUseCase,
      appUserRepository: _appUserRepository,
    );
    final myPageViewModel = MyPageViewModel(
      appUserRepository: _appUserRepository,
    );

    return [
      ChangeNotifierProvider(
        create: (context) => _currentUserStatus,
      ),
      ChangeNotifierProvider(
        create: (context) => loginViewModel,
      ),
      ChangeNotifierProvider(
        create: (context) => userAdditionalInfoViewModel,
      ),
      ChangeNotifierProvider(
        create: (context) => carmeraViewModel,
      ),
      ChangeNotifierProvider(
        create: (context) => homeViewModel,
      ),
      ChangeNotifierProvider(
        create: (context) => myPageViewModel,
      ),
    ];
  }

  // static CarmeraViewModel callCameraViewModel() {
  //   // final whiskyCritiqueViewModel = WhiskyCritiqueViewModel(
  //   //     currentUserStatus: _currentUserStatus,
  //   //     whiskyNewArchivingPostUseCase: whiskeyNewArchivingPostUseCase,
  //   //     archivingPostRepository: _archivingPostRepository);
  //   // return whiskyCritiqueViewModel;

  //   final carmeraViewModel = CarmeraViewModel(
  //     searchWhiskeyDataUseCase: _searchWhiskeyBarcodeUseCase,
  //     archivingPostStatus: whiskeyNewArchivingPostUseCase,
  //   );

  //   return carmeraViewModel;
  // }

  static WhiskyCritiqueViewModel callWhiskyCritiqueViewModel() {
    final whiskyCritiqueViewModel = WhiskyCritiqueViewModel(
      appUserRepository: _appUserRepository,
      whiskyNewArchivingPostUseCase: whiskeyNewArchivingPostUseCase,
    );
    return whiskyCritiqueViewModel;
  }

  static ArchivingPostDetailViewModel callArchivingPostDetailViewModel() {
    final archivingPostDetailViewModel = ArchivingPostDetailViewModel(
        whiskyBrandDistilleryRepository: _whiskyBrandDistilleryRepository,
        archivingPostRepository: _archivingPostRepository);
    return archivingPostDetailViewModel;
  }

  static FirebaseWhiskyBrandDistilleryRepositoryImpl testWhiskDB() {
    return FirebaseWhiskyBrandDistilleryRepositoryImpl(
        _whiskyRef, _brandRef, _distilleryRef);
  }
}
