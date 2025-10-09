// 📁 faq_screen_controller.dart
import 'package:get/get.dart';

class FaqScreenController extends GetxController {
  /// Holds the index of the currently expanded FAQ (-1 means none)
  final RxInt expandedIndex = (-1).obs;

  void toggleExpand(int index) {
    if (expandedIndex.value == index) {
      expandedIndex.value = -1; // collapse if tapped again
    } else {
      expandedIndex.value = index; // open new one
    }
  }
}
