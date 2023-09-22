import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:whilabel/data/brand/brand.dart';
import 'package:whilabel/data/distillery/distillery.dart';
import 'package:whilabel/data/post/archiving_post.dart';
import 'package:whilabel/data/user/app_user.dart';
import 'package:whilabel/data/whisky/whisky.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/use_case/whisky_archiving_post_use_case.dart';
import 'package:whilabel/domain/post/archiving_post_repository.dart';
import 'package:whilabel/domain/post/firebase_archiving_post_repository_impl.dart';
import 'package:whilabel/domain/use_case/user_auth/login_use_case.dart';
import 'package:whilabel/domain/use_case/user_auth/logout_use_case.dart';
import 'package:whilabel/domain/use_case/search_whisky_barcode_use_case.dart';
import 'package:whilabel/domain/user/app_user_repository.dart';
import 'package:whilabel/domain/user/firestore_user_repository_impl.dart';
import 'package:whilabel/domain/whisky_brand_distillery/firebase_whisky_brand_distillery_repository_impl.dart';
import 'package:whilabel/domain/whisky_brand_distillery/whisky_brand_distillery_repository.dart';
import 'package:whilabel/screens/archiving_post_detail/view_model/archiving_post_detail_view_model.dart';
import 'package:whilabel/screens/camera/view_model/camera_view_model.dart';
import 'package:whilabel/screens/home/view_model/home_view_model.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';
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

  static final _currentUserStatus = CurrentUserStatus(_appUserRepository);
  static final WhiskyBrandDistilleryRepository
      _whiskyBrandDistilleryRepository =
      FirebaseWhiskyBrandDistilleryRepositoryImpl(
          _whiskyRef, _brandRef, _distilleryRef);
  static final whiskeyNewArchivingPostUseCase = WhiskyNewArchivingPostUseCase();
  static final ArchivingPostRepository _archivingPostRepository =
      FirestoreArchivingPostRepositoryImple(_archivingPostRef);

  static List<SingleChildWidget> initialProviders() {
    // use case provider
    final loginUseCase = LoginUseCase(
      appUserRepository: _appUserRepository,
      currentUserStatus: _currentUserStatus,
    );
    final logoutUseCase = LogoutUseCase(
      currentUserStatus: _currentUserStatus,
    );
    final searchWhiskeyBarcodeUseCase = SearchWhiskeyBarcodeUseCase(
      appUserRepository: _appUserRepository,
      whiskyBrandDistilleryRepository: _whiskyBrandDistilleryRepository,
    );

// view model Provider
    final loginViewModel = LoginViewModel(
      loginUseCase,
      logoutUseCase,
    );

    final userAdditionalInfoViewModel = UserAdditionalInfoViewModel(
      appUserRepository: _appUserRepository,
      currentUserStatus: _currentUserStatus,
    );
    final carmeraViewModel = CarmeraViewModel(
      searchWhiskeyBarcodeUseCase: searchWhiskeyBarcodeUseCase,
      archivingPostStatus: whiskeyNewArchivingPostUseCase,
    );

    final homeViewModel =
        HomeViewModel(archivingPostRepository: _archivingPostRepository);

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
    ];
  }

  static WhiskyCritiqueViewModel callWhiskyCritiqueViewModel() {
    final whiskyCritiqueViewModel = WhiskyCritiqueViewModel(
        currentUserStatus: _currentUserStatus,
        whiskyNewArchivingPostUseCase: whiskeyNewArchivingPostUseCase,
        archivingPostRepository: _archivingPostRepository);
    return whiskyCritiqueViewModel;
  }

  static ArchivingPostDetailViewModel callArchvingPostDetailViewModel() {
    final archivingPostDetailViewModel = ArchivingPostDetailViewModel(
        whiskyBrandDistilleryRepository: _whiskyBrandDistilleryRepository,
        archivingPostRepository: _archivingPostRepository);
    return archivingPostDetailViewModel;
  }
}
