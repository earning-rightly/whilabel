import 'package:google_sign_in/google_sign_in.dart';
import 'package:whilabel/data/user/auth_user.dart';
import 'package:whilabel/data/user/sns_type.dart';

class GoogleOauth {
  Future<AuthUser?> login() async {
    AuthUser? loginedAuthUser;
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser != null) {
      loginedAuthUser = AuthUser(
        uid: googleUser.id,
        displayName: googleUser.displayName.toString(),
        email: googleUser.email,
        photoUrl: googleUser.photoUrl.toString(),
        snsType: SnsType.GOOGLE,
      );
    }
    return loginedAuthUser;
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
  }
}
