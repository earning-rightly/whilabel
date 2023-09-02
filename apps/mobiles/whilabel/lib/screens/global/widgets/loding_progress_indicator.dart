import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LodingProgressIndicator extends StatelessWidget {
  const LodingProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: true,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
          Center(
            child: SpinKitCubeGrid(
              itemBuilder: (context, index) {
                return const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.amber),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
