import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tubitak_projesi/camera/takePictureScreen.dart';

class CameraStart extends StatefulWidget {
  const CameraStart({Key? key});


  @override
  State<CameraStart> createState() => _CameraStartState();
}

class _CameraStartState extends State<CameraStart> {
  late Future<void> _cameraChooseFuture;


  @override
  void initState() {     //Future tekrar tekrar çalışmaması için burda çağırdık
    super.initState();
    _cameraChooseFuture = CameraChoose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _cameraChooseFuture,
        builder: (context, snapshot) {
          if(snapshot.hasError){    //eror vermiş mi
            return const Center(
              child: Text("Kamera Seçilemedi"),
            );
          }else{   //Bekleme durumu
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}

Future<void> CameraChoose() async {
  // Eklenti hizmetlerinin `availableCameras()` için başlatıldığından emin olun
  // `runApp()` öncesinde çağrılabilir
  WidgetsFlutterBinding.ensureInitialized();

  // Cihazdaki mevcut kameraların bir listesini alın.
  final cameras = await availableCameras();

  // Mevcut kameralar listesinden belirli bir kamera alın.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Uygun kamerayı TakePictureScreen widget'ına iletin.
        camera: firstCamera,
      ),
    ),
  );
}