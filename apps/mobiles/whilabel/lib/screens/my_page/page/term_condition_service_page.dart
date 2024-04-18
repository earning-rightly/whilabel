import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class TermConditionServicePage extends StatelessWidget {
  TermConditionServicePage({super.key});

String initUrl =   "https://fir-herring-a74.notion.site/27f452e63a084840a9bb2e75fb21b87b?pvs=4";
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
