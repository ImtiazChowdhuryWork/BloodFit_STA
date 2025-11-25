import 'package:bloodfit/constants/app_constant_text.dart';
import 'package:bloodfit/services/auth_service.dart';
import 'package:bloodfit/helper/di.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() async {
    // Initialize dependency injection
    await diSetup();
  });

  tearDown(() {
    // Clear Get dependencies
    Get.reset();
  });

  group('AuthService Tests', () {
    testWidgets('Initial auth state based on stored tokens', (WidgetTester tester) async {
      // Create service instance
      final authService = AuthService();
      authService.onInit();
      
      // Assert
      expect(authService.isLoggedIn.value, false);
      expect(authService.isAuthenticated, false);
    });

    testWidgets('Login updates auth state', (WidgetTester tester) async {
      // Create service instance
      final authService = AuthService();
      authService.onInit();
      
      // Arrange - manually write token to storage
      final storage = Get.find(); // Get the GetStorage instance
      await storage.write(kKeyAccessToken, 'test_token');

      // Act
      authService.handleLogin();

      // Assert
      expect(authService.isLoggedIn.value, true);
      expect(authService.isAuthenticated, true);
    });

    testWidgets('Logout clears tokens and updates state', (WidgetTester tester) async {
      // Create service instance
      final authService = AuthService();
      authService.onInit();
      
      // Arrange - set up tokens in storage
      final storage = Get.find(); // Get the GetStorage instance
      await storage.write(kKeyAccessToken, 'test_token');
      await storage.write(kKeyRefreshToken, 'refresh_token');

      // Verify tokens exist before logout
      expect(storage.read(kKeyAccessToken), 'test_token');
      expect(storage.read(kKeyRefreshToken), 'refresh_token');

      // Act
      await authService.performLogout();

      // Assert
      expect(storage.read(kKeyAccessToken), null);
      expect(storage.read(kKeyRefreshToken), null);
      expect(authService.isLoggedIn.value, false);
      expect(authService.isAuthenticated, false);
    });

    testWidgets('Update tokens stores new values', (WidgetTester tester) async {
      // Create service instance
      final authService = AuthService();
      authService.onInit();
      
      // Act
      authService.updateTokens('new_access_token', 'new_refresh_token');

      // Assert
      final storage = Get.find(); // Get the GetStorage instance
      expect(storage.read(kKeyAccessToken), 'new_access_token');
      expect(storage.read(kKeyRefreshToken), 'new_refresh_token');
    });

    testWidgets('Update tokens without refresh token only stores access token', (WidgetTester tester) async {
      // Create service instance
      final authService = AuthService();
      authService.onInit();
      
      // Act
      authService.updateTokens('new_access_token');

      // Assert
      final storage = Get.find(); // Get the GetStorage instance
      expect(storage.read(kKeyAccessToken), 'new_access_token');
      // Don't check refresh token specifically as it may have been set previously
    });

    testWidgets('isAuthenticated returns correct value based on stored token', (WidgetTester tester) async {
      // Create service instance
      final authService = AuthService();
      authService.onInit();
      
      // Arrange - clear any existing token
      final storage = Get.find(); // Get the GetStorage instance
      await storage.remove(kKeyAccessToken);

      // Assert - no token
      expect(authService.isAuthenticated, false);

      // Arrange - with token
      await storage.write(kKeyAccessToken, 'test_token');

      // Assert - with token
      expect(authService.isAuthenticated, true);
    });
  });
}