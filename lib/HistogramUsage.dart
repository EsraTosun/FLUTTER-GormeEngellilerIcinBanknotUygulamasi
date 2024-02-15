import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:tubitak_projesi/AudioplayersClass.dart';
import 'package:tubitak_projesi/Histogram.dart';
import 'package:tubitak_projesi/KNNAlgorithm.dart';




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

  //Çekilen görüntünün yolu farklı olduğu için bu şekilde yaptım
  List<int> cekilenGoruntununHistogram = await Histogram.calculateHistogram(imagePath,1);
  var list = [];

  // 5 TL İÇİN
  for(int i=1; i<75;i++)
  {
    list.add([5,await Histogram.compareImages("assets/Para/5TL/ON/"+i.toString()+".jpg")]);
  }
  for(int i=1; i<75;i++)
  {
    list.add([5,await Histogram.compareImages("assets/Para/5TL/ARKA/"+i.toString()+".jpg")]);
  }

  // 10 TL İÇİN
  for(int i=1; i<75;i++)
  {
    list.add([10,await Histogram.compareImages("assets/Para/10TL/ON/"+i.toString()+".jpg")]);
  }
  for(int i=1; i<75;i++)
  {
    list.add([10,await Histogram.compareImages("assets/Para/10TL/ARKA/"+i.toString()+".jpg")]);
  }

  // 20 TL İÇİN
  for(int i=1; i<75;i++)
  {
    list.add([20,await Histogram.compareImages("assets/Para/20TL/ON/"+i.toString()+".jpg")]);
  }
  for(int i=1; i<75;i++)
  {
    list.add([20,await Histogram.compareImages("assets/Para/20TL/ARKA/"+i.toString()+".jpg")]);
  }

  // 50 TL İÇİN
  for(int i=1; i<75;i++)
  {
    list.add([50,await Histogram.compareImages("assets/Para/50TL/ON/"+i.toString()+".jpg")]);
  }
  for(int i=1; i<75;i++)
  {
    list.add([50,await Histogram.compareImages("assets/Para/50TL/ARKA/"+i.toString()+".jpg")]);
  }

  // 100 TL İÇİN
  for(int i=1; i<75;i++)
  {
    list.add([100,await Histogram.compareImages("assets/Para/100TL/ON/"+i.toString()+".jpg")]);
  }
  for(int i=1; i<75;i++)
  {
    list.add([100,await Histogram.compareImages("assets/Para/100TL/ARKA/"+i.toString()+".jpg")]);
  }

  // 200 TL İÇİN
  for(int i=1; i<75;i++)
  {
    list.add([200,await Histogram.compareImages("assets/Para/200TL/ON/"+i.toString()+".jpg")]);
  }
  for(int i=1; i<75;i++)
  {
    list.add([200,await Histogram.compareImages("assets/Para/200TL/ARKA/"+i.toString()+".jpg")]);
  }

  List<dynamic> sonucList = KNNAlgorithm.knn(cekilenGoruntununHistogram, list ,50);

  print(sonucList.length);
  AudioPlayersClass.PARA=sonucList[0][0];

  for(int i =0;i<sonucList.length;i++)
  {
    print("${sonucList[i][0]} => ${sonucList[i][1]}");
  }

  // Düşük değerler daha yüksek benzerliği gösterirken, yüksek değerler daha büyük farklılığı gösterir.

  /*for(int i = 0; i< list.length; i++){
    print("${list[i][0]} => ${list[i][1]}");
    if (list[i][1] == double.infinity){
      return list[i][0];
    }
  }   */
  //sortDistanceList(list);
  //AudioPlayersClass.PARA=list[0][0];
}


List sortDistanceList(List distance) {
  // listenin iki öğesini karşılaştırırken sıralar
  // mesafeyi karşılaştırır dolayısıyla [1] mesafeye eriştiği yer
  distance.sort((a, b) => a[1].compareTo(b[1]));
  return distance;
}