import 'dart:math';

class KNNAlgorithm {
  static double euclideanDistance(List<int> histogram1, List<int> histogram2) {
    double distance = 0.0;
    for (int i = 0; i < histogram1.length; i++) {
      distance += pow((histogram1[i] - histogram2[i]), 2);
    }
    return sqrt(distance);
  }

  static List<dynamic> sortDistanceList(List<dynamic> distance) {
    distance.sort((a, b) => a[1].compareTo(b[1]));
    return distance;
  }

  static List<dynamic> getNeighbors(List<int> newHistogram, List<dynamic> allHistograms, int k) {
    List<dynamic> distances = [];

    for (int i = 0; i < allHistograms.length; i++) {
      List<dynamic> histogramInfo = allHistograms[i];
      var dist = euclideanDistance(newHistogram, histogramInfo[1]);
      distances.add([histogramInfo[0], dist]);
    }

    var sortedDistance = sortDistanceList(distances);
    return sortedDistance.sublist(0, k);  // Sıralı mesafelerden ilk k tanesini al
  }

  static dynamic knn(List<int> newHistogram, List<dynamic> allHistograms, int k) {
    List<dynamic> sortedDistance = getNeighbors(newHistogram, allHistograms, k);
    return sortedDistance;
  }
}
