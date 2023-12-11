import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:tubitak_projesi/AudioplayersClass.dart';
import 'package:tubitak_projesi/Histogram.dart';




class ColorPickerWidgetStateHistogram extends  StatefulWidget{
  final String imagePath;
  final Future<Uint8List> boyut;
  ColorPickerWidgetStateHistogram({required this.imagePath, required this.boyut});

  // const ColorPickerWidgetState(Key key):super(key:key);

  @override
  State<StatefulWidget> createState() => _ColorPickerWidgetState();


}

class _ColorPickerWidgetState extends  State<ColorPickerWidgetStateHistogram>{

  @override
  Widget build(BuildContext context) {
    // Vibration.vibrate(duration: 10000, amplitude: 1280);

    ParaDegeri(widget.imagePath);
    print(AudioPlayersClass.PARA);

    final Size size=MediaQuery.of(context).size;

    return Scaffold(
      //appBar: AppBar(title: const Text("RGB Colors"),),

      body:SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Image.file(File(widget.imagePath),
                  width: size.width,height: size.height-300,fit: BoxFit.cover),
            ),

            Expanded(
              flex: 1,
              child: AudioPlayersClass(),
            ),
          ],
        ),
      ),
    );
  }

}

void ParaDegeri(String imagePath) async{


  int dosyaAdi = await dosyaAdiBulma("assets/Para/deneme/iphonedortuc.jpg", 0);
  //int dosyaAdi = 123;
  //String dosyaAdi ="serif";
  //int dosyaAdi = 3048192;
  var list = [];

  list.add([5,await Histogram.compareImages("assets/Para/$dosyaAdi/5TL.jpg", "assets/Para/deneme/deneme.jpg")]);
  list.add([10,await Histogram.compareImages("assets/Para/$dosyaAdi/10TL.jpg", "assets/Para/deneme/deneme.jpg")]);
  list.add([20,await Histogram.compareImages("assets/Para/$dosyaAdi/20TL.jpg", "assets/Para/deneme/deneme.jpg")]);
  list.add([50,await Histogram.compareImages("assets/Para/$dosyaAdi/50TL.jpg", "assets/Para/deneme/deneme.jpg")]);
  list.add([100,await Histogram.compareImages("assets/Para/$dosyaAdi/100TL.jpg", "assets/Para/deneme/deneme.jpg")]);
  list.add([200,await Histogram.compareImages("assets/Para/$dosyaAdi/200TL.jpg", "assets/Para/deneme/deneme.jpg")]);

  // Düşük değerler daha yüksek benzerliği gösterirken, yüksek değerler daha büyük farklılığı gösterir.

  for(int i = 0; i< list.length; i++){
    print("${list[i][0]} => ${list[i][1]}");
    if (list[i][1] == double.infinity){
      return list[i][0];
    }
  }
  sortDistanceList(list);
  AudioPlayersClass.PARA=list[0][0];
}

Future<int> dosyaAdiBulma(String imagePath,int deger) async {
  Uint32List rgbaPixels = await Histogram.pixelHesaplama(imagePath, deger,1);
  print("Şu anki fotoğraf pixel => ${rgbaPixels.length}");
  int dosyaAdi = findClosestNumber(rgbaPixels.length);
  print("dosya adi => ${dosyaAdi}");
  return dosyaAdi;
}

int findClosestNumber(int target) {
  List<int> numbers = [1920000,3048192,3145728,7990272,786432,1152000,1926400,2359296,12110400];

  int closestNumber = numbers.first; // İlk sayıyı varsayılan olarak en yakın kabul ediyoruz
  int minDifference = (target - closestNumber).abs(); // İlk farkı hesaplıyoruz

  for (int number in numbers) {
    int difference = (target - number).abs(); // Sayı ile hedef arasındaki farkı hesaplıyoruz
    print(difference);
    if (difference < minDifference) {
      // Eğer bu fark daha önce hesaplanan en küçük farktan daha küçükse
      minDifference = difference; // Yeni en küçük farkı güncelliyoruz
      closestNumber = number; // Yeni en yakın sayıyı güncelliyoruz
    }
  }

  return closestNumber;
}

List sortDistanceList(List distance) {
  // listenin iki öğesini karşılaştırırken sıralar
  // mesafeyi karşılaştırır dolayısıyla [1] mesafeye eriştiği yer
  distance.sort((a, b) => a[1].compareTo(b[1]));
  return distance;
}