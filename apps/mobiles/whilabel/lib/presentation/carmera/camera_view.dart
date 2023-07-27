import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  String result = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("carmera입니다."),
      ),
      body: Center(
        child: Column(children: [
          SizedBox(height: 200),
          Text(" 바코드 결과입니다. =>>  $result"),
          ElevatedButton(
            onPressed: () async {
              var res = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ),
              );
              setState(() {
                if (res is String) result = res;
              });
            },
            child: const Text("바코드 사용하기"),
          )
        ]),
      ),
    );
  }
}
