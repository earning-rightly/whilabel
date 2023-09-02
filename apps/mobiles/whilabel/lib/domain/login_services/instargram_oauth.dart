import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:whilabel/data/user/auth_user.dart';
import 'package:whilabel/data/user/sns_type.dart';

class InstargramOauth {
  static const String _instarCode = "instarCode";
  final String instargramId = dotenv.get("INSTARGRAM_APP_ID");
  final String redirectUrl = dotenv.get("REDIRECT_URL");
  final String appSecret = dotenv.get("APPSECRET");

  Future<AuthUser?> login() async {
    late http.Response longToken;
    late http.Response responseUserData;
    final code = await getCode();

    try {
      // Step 1. Get user's short token using facebook developers account information
      // Http post to Instagram access token URL.
      http.Response token = await _creatToken(code);
      debugPrint("instargram token 받아오기 성공\n token:  ${token.body}");

      // Step 2. Change Instagram Short Access Token -> Long Access Token.
      longToken = await _creatLongToken(token);
      debugPrint(
          "instargram long-token 받아오기 성공\n long-token:   ${longToken.body}");

      responseUserData = await http.get(
        Uri.parse(
          'https://graph.instagram.com/${json.decode(token.body)['user_id'].toString()}?fields=id,username,account_type,media_count&access_token=${json.decode(longToken.body)['access_token']}',
        ),
      );
      // responseUserData = await http.get(Uri.parse(
      //     'https://graph.instagram.com/${json.decode(response.body)['user_id'].toString()}?fields=id,username,account_type,media_count&access_token=${json.decode(responseLongAccessToken.body)['access_token']}'));
    } catch (e) {
      debugPrint("에러!! 인스타그램 token 받아오기 실패");
      debugPrint(e.toString());
    }

    return _creatAuthUser(jsonDecode(responseUserData.body));
  }

  Future<http.Response> _creatToken(String code) async {
    final token = await http.post(
      Uri.parse("https://api.instagram.com/oauth/access_token"),
      body: {
        "client_id": instargramId,
        "redirect_uri": redirectUrl,
        "client_secret": appSecret,
        "code": code,
        "grant_type": "authorization_code"
      },
    );
    return token;
  }

  Future<http.Response> _creatLongToken(http.Response token) async {
    final longToken = await http.get(
      Uri.parse(
        "https://graph.instagram.com/access_token?grant_type=ig_exchange_token&client_secret=$appSecret&access_token=${json.decode(token.body)['access_token']}",
      ),
    );
    return longToken;
  }

  AuthUser _creatAuthUser(Map<String, dynamic> userJsonData) {
    AuthUser result = AuthUser(
      uid: userJsonData["id"],
      displayName: userJsonData["username"],
      email: "instargram@isnot.email",
      photoUrl: "https://picsum.photos/250?image=9",
      snsType: SnsType.INSTAGRAM,
    );
    return result;
  }

  void saveToken(String code) async {
    var instarCode = await Hive.openBox(_instarCode);
    instarCode.put('code', code.toString());
    print("###Save instarCode: ${instarCode.get('code').toString()}}");
  }

  static Future<String> getCode() async {
    var instarCode = await Hive.openBox(_instarCode);
    final result = instarCode.get('code').toString();
    instarCode.clear();
    print("@@@@Get instarCode: ${result}");
    return result;
  }
}
