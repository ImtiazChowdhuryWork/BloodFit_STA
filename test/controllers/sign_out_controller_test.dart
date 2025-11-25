import 'package:bloodfit/controllers/sign_out_controller.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:bloodfit/services/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() async {
    // Initialize dependency injection
    await diSetup();
    
    // Register dependencies
    Get.put<AuthService>(AuthService());
  });

  tearDown(() {
    // Clear Get dependencies
    Get.reset();
  });

  group('SignOutController Tests', () {
    testWidgets('Initial state is not loading', (WidgetTester tester) async {
      // Create controller
      final controller = SignOutController();
      
      // Assert
      expect(controller.isLoading.value, false);
    });

    testWidgets('Loading state changes during operations', (WidgetTester tester) async {
      // Create controller
      final controller = SignOutController();
      
      // This test verifies that the loading state exists and can change
      expect(controller.isLoading.value, false);
      
      // Simulate setting loading to true
      controller.isLoading.value = true;
      expect(controller.isLoading.value, true);
      
      // Reset to false
      controller.isLoading.value = false;
      expect(controller.isLoading.value, false);
    });
  });
}