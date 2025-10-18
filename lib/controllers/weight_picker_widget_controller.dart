import 'package:get/get.dart';

class WeightController extends GetxController {
  RxDouble currentWeight = 60.0.obs;
  RxBool useLb = false.obs;

  double get minWeight => useLb.value ? 66.0 : 30.0; // 40kg ≈ 88lb
  double get maxWeight => useLb.value ? 200.0 : 440.0; // 150kg ≈ 330lb
  double get stepSize => useLb.value ? 1.0 : 0.5;
  String get unit => useLb.value ? "lb" : "kg";

  void updateWeight(double value) {
    currentWeight.value = value;
  }

  void toggleUnit() {
    if (useLb.value) {
      // Convert lb to kg
      currentWeight.value = (currentWeight.value / 2.205);
    } else {
      // Convert kg to lb
      currentWeight.value = (currentWeight.value * 2.205);
    }
    useLb.value = !useLb.value;
  }
}
