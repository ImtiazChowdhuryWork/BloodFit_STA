import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/controllers/verify_user_otp_screen_controller.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() async {
    // Initialize dependency injection
    await diSetup();
  });

  tearDown(() {
    // Clear Get dependencies if any
    Get.reset();
  });

  group('VerifyUserOtpScreenController Tests', () {
    testWidgets('Invalid OTP format shows validation error', (WidgetTester tester) async {
      // Create controller
      final controller = VerifyUserOtpScreenController();
      
      // Act
      String? error = controller.validatePin('12345'); // Only 5 digits

      // Assert
      expect(error, 'OTP must be 6 digits');
    });

    testWidgets('Non-numeric OTP shows validation error', (WidgetTester tester) async {
      // Create controller
      final controller = VerifyUserOtpScreenController();
      
      // Act
      String? error = controller.validatePin('abcdef');

      // Assert
      expect(error, 'OTP must contain only numbers');
    });

    testWidgets('Empty OTP shows validation error', (WidgetTester tester) async {
      // Create controller
      final controller = VerifyUserOtpScreenController();
      
      // Act
      String? error = controller.validatePin('');

      // Assert
      expect(error, 'OTP cannot be empty');
    });

    testWidgets('Valid OTP format passes validation', (WidgetTester tester) async {
      // Create controller
      final controller = VerifyUserOtpScreenController();
      
      // Act
      String? error = controller.validatePin('123456');

      // Assert
      expect(error, null);
    });

    testWidgets('OTP completion updates pin value', (WidgetTester tester) async {
      // Create controller
      final controller = VerifyUserOtpScreenController();
      
      // Act
      controller.onCompleted('654321');

      // Assert
      expect(controller.pin.value, '654321');
      expect(controller.errorMessage.value, '');
    });

    testWidgets('Loading state changes appropriately', (WidgetTester tester) async {
      // Create controller
      final controller = VerifyUserOtpScreenController();
      
      // Assert initial state
      expect(controller.isLoading.value, false);
      
      // Simulate changing loading state
      controller.isLoading.value = true;
      expect(controller.isLoading.value, true);
      
      controller.isLoading.value = false;
      expect(controller.isLoading.value, false);
    });
  });
}