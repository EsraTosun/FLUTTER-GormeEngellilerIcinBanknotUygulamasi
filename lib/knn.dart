import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';


class knn {
  List<List<double>> data; // Veri seti
  List<String> labels; // Etiketler

  knn(this.data, this.labels);

  String classify(List<double> input, int k) {
    List<double> distances = [];

    // Euclidean mesafesini hesapla
    for (int i = 0; i < data.length; i++) {
      double distance = 0;
      for (int j = 0; j < input.length; j++) {
        distance += pow(data[i][j] - input[j], 2);
      }
      distances.add(sqrt(distance));
    }

    // Mesafelere göre sırala ve ilk k elemanı al
    List<int> sortedIndices = List.generate(distances.length, (i) => i);
    sortedIndices.sort((a, b) => distances[a].compareTo(distances[b]));

    // En yakın k komşunun etiketlerini say
    Map<String, int> labelCounts = {};
    for (int i = 0; i < k; i++) {
      String label = labels[sortedIndices[i]];
      labelCounts[label] = (labelCounts[label] ?? 0) + 1;
    }

    // En çok tekrar eden etiketi bul
    String mostCommonLabel = labelCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    return mostCommonLabel;
  }
}