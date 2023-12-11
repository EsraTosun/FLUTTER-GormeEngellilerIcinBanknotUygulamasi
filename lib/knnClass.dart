import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';


class knnClass {

  //ÖKLİD UZAKLIĞI
  double euclideanDistance(List New, List RGB) {
    double distance = 0.0;
    for (int i = 0; i < New.length - 1; i++) {
      distance += pow((New[i] - RGB[i]), 2);
    }
    return sqrt(distance);
  }

  List sortDistanceList(List distance) {
    // listenin iki öğesini karşılaştırırken sıralar
    // mesafeyi karşılaştırır dolayısıyla [1] mesafeye eriştiği yer
    distance.sort((a, b) => a[1].compareTo(b[1]));
    return distance;
  }

  List getNeighbors(List NEWBand, List RGBBand, int HangiPara) {
    List distances = [];

    var dist = euclideanDistance(RGBBand, NEWBand);
    distances.add([HangiPara,dist]);

    // test_row öklidi ve tren verilerini karşılaştırırken sıralama
    var sorted_distance =  (distances);

    return sorted_distance;
  }


  dynamic knn(List NEWBand, List RGBBand,int HangiPara) {
    List sorted_distance = getNeighbors(NEWBand, RGBBand, HangiPara);

    return sorted_distance;
  }
}