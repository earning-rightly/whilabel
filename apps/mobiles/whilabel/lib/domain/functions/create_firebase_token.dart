import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:whilabel/data/user/auth_user.dart';

// firebase에 로그인할 토큰을 생성하는 함수
Future<String> createFirebaseToken(AuthUser user) async {
  final String url =
      'https://us-central1-whilabel.cloudfunctions.net/createCustomToken';

  try {
    final customTokenResponse =
        await http.post(Uri.parse(url), body: user.toJson());
    // print("customTokenResponse \n${customTokenResponse.body}");
    return customTokenResponse.body;
  } catch (error) {
    debugPrint("createCustomToken eroo ===>>>\n $error");
  }
  return "erro";
}