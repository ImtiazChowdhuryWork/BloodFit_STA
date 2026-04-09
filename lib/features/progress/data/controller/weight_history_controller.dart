import 'package:bloodfit/features/progress/data/model/weight_history_model.dart';
import 'package:bloodfit/features/progress/data/repository/weight_history_repository.dart';
import 'package:bloodfit/features/progress/presentation/widget/weight_history_chart.dart';
import 'package:bloodfit/helper/logger_util.dart';
import 'package:get/get.dart';

class WeightHistoryController extends GetxController {
  final WeightHistoryRepository _weightHistoryRepository;

  WeightHistoryController(this._weightHistoryRepository);

  Rxn<WeightHistoryModel> weightHistoryModel = Rxn<WeightHistoryModel>();
  RxBool isWeightHistoryLoading = false.obs;
  RxString weightHistoryErrorMessage = ''.obs;

  void clearWeightHistoryErrorMessage() {
    weightHistoryErrorMessage.value = '';
  }

  Future<void> getWeightHistory() async {
    try {
      isWeightHistoryLoading.value = true;
      clearWeightHistoryErrorMessage();

      LoggerUtils.debug('🚀 Weight History Controller - Starting API Call...');

      final response = await _weightHistoryRepository.getWeightHistory();

      LoggerUtils.debug("Weight History API Response : $response");

      if (response.statusCode == 200 && response.isSuccess) {
        LoggerUtils.debug("😁😁😁😁Weight History API fetched successfully.");
        weightHistoryModel.value = WeightHistoryModel.fromJson(response.jsonResponse!);
        
        // Log the parsed data
        final rawData = weightHistoryModel.value?.data;
        LoggerUtils.debug('📋 Total Records Received: ${rawData?.length ?? 0}');
        
        if (rawData != null && rawData.isNotEmpty) {
          LoggerUtils.debug('📊 First Record: Weight=${rawData.first.weight}, Date=${rawData.first.date}');
          LoggerUtils.debug('📊 Last Record: Weight=${rawData.last.weight}, Date=${rawData.last.date}');
        }
      } else {
        weightHistoryErrorMessage.value = response.errorMessage ?? 'Failed to fetch weight history data';

        LoggerUtils.error("Status Code : ${response.statusCode}");
        LoggerUtils.error("Weight History Section Error Message : ${weightHistoryErrorMessage.value}");
      }
    } catch (error) {
      weightHistoryErrorMessage.value = error.toString();
      LoggerUtils.error("Something Went Wrong! While Getting the Weight History Data!");
      LoggerUtils.error("Error Message : ${weightHistoryErrorMessage.value}");
    } finally {
      isWeightHistoryLoading.value = false;
    }
  }

  /// Transforms API data into WeightEntry list for the chart
  /// The chart expects: WeightEntry(day, weight)
  /// where day is the day of the month from the date
  List<WeightEntry> getWeightEntries() {
    final data = weightHistoryModel.value?.data;
    if (data == null || data.isEmpty) {
      LoggerUtils.debug('⚠️ No weight history data available to transform');
      return [];
    }

    final entries = data
        .where((entry) => entry.date != null && entry.weight != null)
        .map((entry) {
          final weightEntry = WeightEntry(
            entry.date!,
            entry.weight!.toDouble(),
          );
          LoggerUtils.debug('🔄 Transformed: Date=${entry.date} (day=${entry.date!.day}), Weight=${entry.weight} → WeightEntry(${entry.date!.day}, ${entry.weight!.toDouble()})');
          return weightEntry;
        })
        .toList();

    LoggerUtils.debug('✅ Total WeightEntry items created: ${entries.length}');
    
    if (entries.isNotEmpty) {
      LoggerUtils.debug('📈 First Entry: ${entries.first}');
      LoggerUtils.debug('📈 Last Entry: ${entries.last}');
    }

    return entries;
  }

  /// Gets the goal weight from the latest entry or a default value
  double getGoalWeight() {
    final goalWeight = 58.0; // You can adjust this based on your requirements
    LoggerUtils.debug('🎯 Goal Weight: $goalWeight kg');
    
    // Check if goalWeight is valid
    if (goalWeight.isNaN || goalWeight.isInfinite || goalWeight <= 0) {
      LoggerUtils.error('❌ Invalid goalWeight: $goalWeight, using default 58.0');
      return 58.0;
    }
    
    return goalWeight;
  }

  /// Gets the current weight from the latest entry
  double getCurrentWeight() {
    final data = weightHistoryModel.value?.data;
    if (data == null || data.isEmpty) {
      LoggerUtils.debug('⚠️ No data available, using default current weight: 83.0 kg');
      return 83.0;
    }
    // Sort by date and get the latest weight
    final sortedData = data.toList()
      ..sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));
    final latestWeight = sortedData.first.weight?.toDouble() ?? 83.0;
    
    LoggerUtils.debug('💪 Current Weight (from latest entry): $latestWeight kg (Date: ${sortedData.first.date})');
    
    // Validate weight
    if (latestWeight.isNaN || latestWeight.isInfinite || latestWeight <= 0) {
      LoggerUtils.error('❌ Invalid latestWeight: $latestWeight, using default 83.0');
      return 83.0;
    }
    
    return latestWeight;
  }
}
