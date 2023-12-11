import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';


class Histogram {

  static int i = 0;

  static Future<List<int>> calculateHistogram(String imagePath, int deger) async {

    Uint32List rgbaPixels = await pixelHesaplama(imagePath, deger,0);

    print(rgbaPixels.length);
    final List<int> histogram = List<int>.filled(256, 0);
    final List<int> redhistogram = List<int>.filled(256, 0);
    final List<int> bluehistogram = List<int>.filled(256, 0);
    final List<int> greenhistogram = List<int>.filled(256, 0);

    for (int i = 0; i < (rgbaPixels.length).toInt(); i++) {
      final red = (rgbaPixels.elementAt(i) >> 16) & 0xFF;
      final green = (rgbaPixels.elementAt(i) >> 8) & 0xFF;
      final blue = (rgbaPixels.elementAt(i) & 0xFF);


      // Renk bileşenlerine erişebilirsiniz.
      // Bu bileşenleri kullanarak luminans veya başka bir şey hesaplayabilirsiniz.

      // Örnek: Luminans hesaplama
      final luminance = calculateLuminance(red, green, blue);
      histogram[(luminance * 255).toInt()]++;
      redhistogram[(luminance * 255).toInt()]++;
      bluehistogram[(luminance * 255).toInt()]++;
      greenhistogram[(luminance * 255).toInt()]++;
    }

    // Histogramı yazdırın veya başka bir şey yapın.
    print('Histogram: $histogram');
    return histogram;
  }

  static Future<Uint32List> pixelHesaplama(String imagePath,int deger,int islem) async {

    if(islem == 0){
      imagePath = await IyilestirilmisGoruntu(imagePath, deger);
      deger = 1;
    }

    ImageProvider provider;
    if(deger == 0){
      provider = AssetImage(imagePath); // Varlık yolu
    }else{
      provider = FileImage(File(imagePath));
    }

    print(imagePath);

    // Görüntüden RGBA pikselleri elde etmek için yapılan işlem
    final ImageStream stream = provider.resolve(ImageConfiguration.empty);
    final completer = Completer<ui.Image>();
    late ImageStreamListener listener;
    //Stack stack = Stack();

    listener = ImageStreamListener(
            (frame, _) {
          stream.removeListener(listener);
          completer.complete(frame.image);
        },
        onError: (error, stack) {
          stream.removeListener(listener);
          completer.completeError(error, stack);
        });
    stream.addListener(listener);
    ui.Image Image = await completer.future;
    ByteData rgbaData = (await Image.toByteData(
        format: ui.ImageByteFormat.rawRgba))!;

    //print(rgbaData);
    // Bunlar ihtiyacımız olan pikseller
    Uint32List rgbaPixels = rgbaData.buffer.asUint32List();

    return rgbaPixels;
  }

  static Future<String> IyilestirilmisGoruntu(String imagePath,deger) async{
    img.Image resizedImage;

    img.Image? image;
    if(deger == 0){
      ByteData data = await rootBundle.load(imagePath);
      List<int> bytes = data.buffer.asUint8List();
      // Görüntüyü yükle
      image = img.decodeImage(Uint8List.fromList(bytes));
    }else{
      File imageFile = File(imagePath);
      image = img.decodeImage(imageFile.readAsBytesSync());
    }


    img.adjustColor(image!, brightness: 1.5, contrast: 1.5);
    resizedImage = img.sobel(image!);   //Kenar algılama

    // Kenar algılama sonucunda oluşan görüntünün sınırlarını belirleyin
    int left = 0;
    int top = 0;
    int right = resizedImage.width - 1;
    int bottom = resizedImage.height - 1;


    // Kenar algılama sonucunda görüntüdeki kenarları tespit edin ve sınırları belirleyin
    for (int x = 0; x < resizedImage.width; x++) {
      for (int y = 0; y < resizedImage.height; y++) {
        if (resizedImage.getPixel(x, y) != image.getColor(0, 0, 0, 255)) {
          if (left == 0 || x < left) {
            left = x;
          }
          if (x > right) {
            right = x;
          }
          if (top == 0 || y < top) {
            top = y;
          }
          if (y > bottom) {
            bottom = y;
          }
        }
      }
    }

    // Kenar algılama sonucundaki sınırları kullanarak görüntüyü kırpın
    //img.Image croppedImage = img.copyCrop(resizedImage, x: left, y: top, width: right - left, height: bottom - top);

    // Kırpılmış görüntüyü kaydedin
    //File('cropped_image.jpg').writeAsBytesSync(img.encodeJpg(croppedImage));

    //resizedImage = img.grayscale(image!);
    // Parlaklık ve kontrast ayarlarını yapma

    // Görüntüyü yeniden boyutlandırma
    //resizedImage = img.copyResize(image, width: 200, height: 200);

    print(resizedImage.width);
    print(resizedImage.height);
    i++;
    Uint8List uint8list = img.encodePng(resizedImage); // Örnek bir dönüşüm, burada PNG formatı kullanıldı
    imagePath = await saveEnhancedImage(uint8list,i);
    print(imagePath);

    return imagePath;
  }

  /* static void HistogramIleGoruntuIyilestirme(String imagePath,deger) async{

    final histogram = await calculateHistogram(imagePath,0);

    // Kumulatif Dağılım Fonksiyonunu (CDF) hesapla
    List<int> cdf = List<int>.filled(256, 0);
    cdf[0] = histogram[0];
    for (int i = 1; i < 256; i++) {
      cdf[i] = cdf[i - 1] + histogram[i];
    }

    img.Image? src;
    if(deger == 0){
      ByteData data = await rootBundle.load(imagePath);
      List<int> bytes = data.buffer.asUint8List();
      // Görüntüyü yükle
      src = img.decodeImage(Uint8List.fromList(bytes));
    }else{
      File imageFile = File(imagePath);
      src = img.decodeImage(imageFile.readAsBytesSync());
    }

    // Normalize et
    int minCdf = cdf.firstWhere((value) => value > 0);
    int maxCdf = cdf.last;
    int numPixels = src!.width * src!.height;
    List<int> normalizedCdf = List<int>.filled(256, 0);
    for (int i = 0; i < 256; i++) {
      normalizedCdf[i] = ((cdf[i] - minCdf) / (numPixels - minCdf) * 255).round();
    }

    // Yeni piksel değerlerini hesapla
    img.Image correctedImage = img.copy(src);

    Uint32List rgbaPixels = await pixelHesaplama(imagePath, deger,0);
    print(rgbaPixels.length);

    for (int i = 0; i < (rgbaPixels.length).toInt(); i++) {
      final alfa = (rgbaPixels.elementAt(i) >> 24) & 0xFF;
      final red = (rgbaPixels.elementAt(i) >> 16) & 0xFF;
      final green = (rgbaPixels.elementAt(i) >> 8) & 0xFF;
      final blue = (rgbaPixels.elementAt(i) & 0xFF);

      int newA = normalizedCdf[alfa];
      int newR = normalizedCdf[red];
      int newG = normalizedCdf[green];
      int newB = normalizedCdf[blue];

      // Yeni bir renk oluşturun
      final newColor = img.Color.fromARGB(
        newR.clamp(0, 255),     // Kırmızı bileşeni sınırlayın (0-255 arasında)
        newG.clamp(0, 255),   // Yeşil bileşeni sınırlayın (0-255 arasında)
        newB.clamp(0, 255),    // Mavi bileşeni sınırlayın (0-255 arasında)
      );

      correctedImage.setPixel(x, y, img.getColor(newR, newG, newB));
    }
    for (int y = 0; y < src.height; y++) {
      for (int x = 0; x < src.width; x++) {
        int pixel = src.getPixel(x, y);
        int r = img.getRed(pixel);
        int g = img.getGreen(pixel);
        int b = img.getBlue(pixel);



      }
    }

    return correctedImage;
  }   */

  static Future<String> saveEnhancedImage(Uint8List imageBytes,int i) async {
    final directory = await getApplicationDocumentsDirectory(); // Kayıt dizini alın
    final file = File('${directory.path}/iyilestirilmis_goruntu${i}.jpg'); // Dosya adını ve yolunu belirleyin
    await file.writeAsBytes(imageBytes); // Görüntüyü dosyaya yazın
    print('İyileştirilmiş görüntü kaydedildi: ${file.path}');
    return file.path;
  }

  static double calculateLuminance(int r, int g, int b) {
    return (0.299 * r + 0.587 * g + 0.114 * b) / 255.0;
  }

//İki histogram arasındaki Chi-Kare uzaklığını hesaplamak için bir işlev tanımlayın:
  static double calculateChiSquareDistance(List<int> hist1, List<int> hist2) {
    double distance = 0.0;

    print("histogram 1 => ${hist1.length}");
    print("histogram 2 => ${hist2.length}");

    /* int index = hist1.length;
    if(hist1.length > hist2.length){
      index = hist2.length;
    }  */

    //int index = min(hist1.length, hist2.length); // Minimum uzunluğu alın

    for (int i = 0; i < hist1.length; i++) {
      if (hist1[i] + hist2[i] != 0) {
        final diff = hist1[i] - hist2[i];
        distance += (diff * diff) / (hist1[i] + hist2[i]);
      }
    }

    return distance;
  }

// İki resmi histogramlarını kullanarak karşılaştıran bir işlev tanımlayın:
  static Future<double> compareImages(String imagePath1, String imagePath2) async {
    final histogram1 = await calculateHistogram(imagePath1,0);
    final histogram2 = await calculateHistogram(imagePath2,0);

    return calculateChiSquareDistance(histogram1, histogram2);
  }

}
/*
// main işlevinde, iki resmi yükleyebilir ve karşılaştırabilirsiniz:
void main() async{

  var list = [];
  list.add([5,await Histogram.compareImages("", "")]);
  list.add([10,await Histogram.compareImages("", "")]);
  list.add([20,await Histogram.compareImages("", "")]);
  list.add([50,await Histogram.compareImages("", "")]);
  list.add([100,await Histogram.compareImages("", "")]);
  list.add([200,await Histogram.compareImages("", "")]);
  final benzerlik = await Histogram.compareImages("", "");

  print('Resim benzerliği: $benzerlik');
  // Düşük değerler daha yüksek benzerliği gösterirken, yüksek değerler daha büyük farklılığı gösterir.
}

*/

