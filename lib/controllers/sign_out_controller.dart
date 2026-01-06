// // controllers/sign_out_controller.dart
// import 'package:bloodfit/endpoints.dart';
// import 'package:bloodfit/helper/di.dart';
// import 'package:bloodfit/networks/network_caller.dart';
// import 'package:bloodfit/networks/network_response.dart';
// import 'package:bloodfit/routes/routes.dart';
// import 'package:get/get.dart';

// class SignOutController extends GetxService {
//   var isLoading = false.obs;

//   Future<bool> signOut() async {
//     isLoading.value = true;

//     try {
//       final NetworkCaller networkCaller = Get.find<NetworkCaller>();
//       final NetworkResponse response = await networkCaller.postRequest(
//         Endpoints.signOut(),
//         isLogin: false, // This is not a login request
//       );

//       if (response.isSuccess) {
//         // Clear the access token after successful logout
//         appData.remove(kKeyAccessToken);

//         // Navigate to sign in screen
//         Get.offAllNamed(Routes.signInScreen);
//         return true;
//       } else {
//         // Even if the API call fails, we should still clear the local token
//         // and navigate to sign in screen to avoid the user being stuck
//         appData.remove(kKeyAccessToken);
//         Get.offAllNamed(Routes.signInScreen);
//         return false;
//       }
//     } catch (e) {
//       // In case of exception, clear the local token anyway to avoid being stuck
//       appData.remove(kKeyAccessToken);
//       Get.offAllNamed(Routes.signInScreen);
//       return false;
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
