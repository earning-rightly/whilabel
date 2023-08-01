import 'package:flutter/material.dart';
import 'package:whilabel/presentation/resources/routes_manager.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("home 입니다"),
        leading: const SizedBox(width: 0),
      ),
      body: Center(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.cameraRoute);
              },
              child: const Text("(test) go cameraView"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.WhiskeyRegisterRoute);
                },
                child: Text("recognition_success_view.dart"))
          ],
        ),
      ),
    );
  }
}
