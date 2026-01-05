import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/features/auth/sign_in/data/controller/sign_in_screen_controller.dart';
import 'package:bloodfit/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  late SignInScreenController controller;

  setUp(() async {
    // Initialize GetStorage first
    await GetStorage.init();

    // Register dependencies
    Get.put<AuthService>(AuthService());

    // Create controller
    controller = SignInScreenController();
  });

  tearDown(() {
    // Clear Get dependencies
    Get.reset();
  });

  group('SignInScreenController Tests', () {
    test('Form validation fails with invalid email', () {
      // Arrange
      controller.emailController.text = 'invalid-email';
      controller.passwordController.text = 'password123';

      // Act
      bool isValid = controller.validateForm();

      // Assert
      expect(isValid, false);
      expect(
        controller.errorMessage.value,
        'Please enter a valid email address',
      );
    });

    test('Form validation fails with weak password', () {
      // Arrange
      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'weak';

      // Act
      bool isValid = controller.validateForm();

      // Assert
      expect(isValid, false);
      expect(
        controller.errorMessage.value,
        'Password must be at least 8 characters long and contain uppercase, lowercase, number, and special character',
      );
    });

    test('Form validation succeeds with valid inputs', () {
      // Arrange
      controller.emailController.text = 'test@example.com';
      controller.passwordController.text = 'Password123!';

      // Act
      bool isValid = controller.validateForm();

      // Assert
      expect(isValid, true);
      expect(controller.errorMessage.value, '');
    });

    test('Password visibility toggle works', () {
      // Act
      controller.setPasswordVisibility();

      // Assert
      expect(controller.isPasswordVisible.value, true);

      // Toggle again
      controller.setPasswordVisibility();
      expect(controller.isPasswordVisible.value, false);
    });

    test('Checkbox toggle works', () {
      // Act
      controller.setCheckBoxValue(newValue: true);

      // Assert
      expect(controller.isChecked.value, true);

      // Toggle again
      controller.setCheckBoxValue(newValue: false);
      expect(controller.isChecked.value, false);
    });

    test('Error can be cleared', () {
      // Arrange
      controller.errorMessage.value = 'Some error';

      // Act
      controller.clearError();

      // Assert
      expect(controller.errorMessage.value, '');
    });
  });
}
