import 'package:get/get.dart';
import '../utils/calander_logic.dart';

class HomeScreenController extends GetxController {
  // Reactive list of all days
  var allDays = <CalendarDay>[].obs;

  // The CalendarDateManager is created inside the controller
  late final CalendarDateManager calendar;

  // You can optionally set start/end year here
  final int startYear = 2025;
  final int endYear = 2040;

  @override
  void onInit() {
    super.onInit();

    // Initialize CalendarDateManager inside the controller
    calendar = CalendarDateManager(startYear: startYear, endYear: endYear);

    // Load all days
    loadAllDays();
  }

  void loadAllDays() {
    allDays.value = calendar.generateAllDays();
  }
}
