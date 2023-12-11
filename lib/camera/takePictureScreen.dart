import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import 'package:image_picker/image_picker.dart';
import 'package:tubitak_projesi/HistogramUsage.dart';


// Kullanıcıların belirli bir kamerayı kullanarak resim çekmesini sağlayan bir ekran.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  XFile? _image;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    // Kameradan gelen mevcut çıkışı görüntülemek için,
    // bir CameraController oluşturun.
    _controller = CameraController(
      // Mevcut kameralar listesinden belirli bir kamera alın.
      widget.camera,
      // Kullanılacak çözünürlüğü tanımlayın.
      ResolutionPreset.max,
    );

    // Ardından, denetleyiciyi başlatın. Bu bir Gelecek döndürür.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Widget atıldığında denetleyiciyi atın.
    _controller.dispose();
    super.dispose();
  }

  // Görüntüyü galeriye kaydetme işlemi
  _saveImageToGallery() async {
    if (_imageFile != null) {
      final result = await ImageGallerySaver.saveFile(_imageFile!.path);
      print("Görüntü kaydedildi: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Take a picture')),
      // Görüntülemeden önce denetleyicinin başlatılmasını beklemeniz gerekir.
      // kamera önizlemesi. Bir yükleme döndürücüyü görüntülemek için bir FutureBuilder kullanın.
      // denetleyici başlatmayı tamamladı.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Gelecek tamamlandıysa, önizlemeyi görüntüleyin.
            return CameraPreview(_controller);
          } else {
            // Aksi takdirde, bir yükleme göstergesi görüntüleyin.
            return const Center(child: CircularProgressIndicator(),heightFactor: 200,);
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        // bir onPressed geri araması sağlayın.
        onPressed: () async {
          // Resmi bir try/catch bloğunda çekin. Bir şeyler ters giderse,
          // hatayı yakala.
          try {
            // Kameranın başlatıldığından emin olun.
            await _initializeControllerFuture;

            // Bir resim çekmeyi ve `image` dosyasını almayı deneyin
            // kaydedildiği yer.
            final image = await _controller.takePicture();

            if (image != null) {
              setState(() {
                _image = image;
                _imageFile = File(_image!.path);
              });
            }

            _saveImageToGallery(); //Galeriye kaydedilmesini sağlar
            // _sendImageToPythonServer();
            print(image.path);
            if (!mounted) return;

            // Resim çekildiyse, yeni bir ekranda görüntüleyin.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ColorPickerWidgetStateHistogram(
                      // Otomatik olarak oluşturulan yolu şuraya iletin
                      // DisplayPictureScreen widget'ı.
                      imagePath: image.path,
                      boyut: image.readAsBytes(),
                    ),
              ),
            );
          } catch (e) {
            // Bir hata oluşursa, hatayı konsola kaydedin.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 50),
        ),
      ),
    );
  }
}