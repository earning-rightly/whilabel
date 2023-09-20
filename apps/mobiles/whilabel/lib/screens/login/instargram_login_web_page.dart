import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whilabel/data/user/auth_user.dart';
import 'package:whilabel/data/user/sns_type.dart';
import 'package:whilabel/domain/global_provider/current_user_status.dart';
import 'package:whilabel/domain/login_services/instargram_oauth.dart';

import 'package:whilabel/screens/constants/routes_manager.dart';
import 'package:whilabel/screens/login/view_model/login_event.dart';
import 'package:whilabel/screens/login/view_model/login_view_model.dart';

// ignore: must_be_immutable
class InstargramLoginWebPage extends StatefulWidget {
  InstargramLoginWebPage({super.key});

  String instargramCode = "";

  @override
  State<InstargramLoginWebPage> createState() => _InstargramLoginWebPageState();
}

class _InstargramLoginWebPageState extends State<InstargramLoginWebPage> {
  AuthUser authUser = AuthUser(
      uid: "",
      displayName: "",
      email: "",
      photoUrl: "",
      snsType: SnsType.EMPTY);

  bool sw = true;
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    String initUrl = dotenv.get("INIT_URL");
    String redirectUri = dotenv.get("REDIRECT_URL");

    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onNavigationRequest: (NavigationRequest request) async {
                  if (request.url.startsWith(redirectUri)) {
                    if (request.url.contains('error')) print('the url error');
                    var startIndex = request.url.indexOf('code=');
                    var endIndex = request.url.lastIndexOf('#');
                    var code = request.url.substring(startIndex + 5, endIndex);

                    InstargramOauth().saveToken(code);

                    viewModel.onEvent(LoginEvent.login(SnsType.INSTAGRAM),
                        callback: () {
                      setState(() {});

                      if (viewModel.state.isLogined &&
                          viewModel.state.userState == UserState.initial) {
                        Navigator.pushNamed(
                          context,
                          Routes.userAdditionalInfoRoute,
                        );
                      } else if (viewModel.state.isLogined &&
                          viewModel.state.userState == UserState.login) {
                        Navigator.pushNamed(
                          context,
                          Routes.homeRoute,
                        );
                      } else {
                        debugPrint("로그인 오류 발생");
                      }
                    });

                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..loadRequest(
              Uri.parse(initUrl),
            ),
        ),
      ),
    );
  }
}
