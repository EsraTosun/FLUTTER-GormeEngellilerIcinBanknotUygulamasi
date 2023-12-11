import 'package:flutter/material.dart';
import 'package:tubitak_projesi/camera/cameraStart.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DosyaOkuma dosyaOku = DosyaOkuma();
    //dosyaOku.dosyaOkuma();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: CameraStart(),
    );
  }
}










