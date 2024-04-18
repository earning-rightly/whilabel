import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


/* firebase에 로그인한 유저의 토큰을 생성
**/
class WithdrawUseCase {
  // firebase의 설정에 있는 로직
  final String url =
'https://us-central1-whilabel.cloudfunctions.net/withdrawUser';
  Future<String?> call(String uid, String nickName) async {
    // 현재 유저의 firebase token을 받아옵니다
    final idToken = await FirebaseAuth.instance.currentUser?.getIdToken();

    if (idToken != null) {
      final header = {"authorization": 'Bearer $idToken'};
      Map<String, dynamic> _json = {'uid': uid, 'nickName': nickName};

      try {
        final response = await http
            .post(Uri.parse(url), headers: header, body: _json);
        debugPrint(
            "withdrawUseCase \n${response.statusCode} \n${response.body}");
        return response.body.toString();
      } catch (error) {
        debugPrint("withdrawUseCase error ===>>>\n $error");
        return null;
      }
    }
  }
}
