import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class TermConditionServicePage extends StatelessWidget {
  TermConditionServicePage({super.key});

  String initUrl = dotenv.get("TERM_CONDITION_SERVICE_URL");

  // String redirectUri = dotenv.get("REDIRECT_URL");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(
          controller: WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(),
            )
            ..loadRequest(
              Uri.parse(initUrl),
            ),
        ),
      ),
    );
  }
}
