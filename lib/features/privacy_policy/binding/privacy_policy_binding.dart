import 'package:bloodfit/features/privacy_policy/data/repository/privacy_policy_repository.dart';
import 'package:get/get.dart';

import '../data/controller/privacy_policy_controller.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyRepository>(
      () => PrivacyPolicyRepository(Get.find()),
    );
    Get.lazyPut<PrivacyPolicyController>(
      () => PrivacyPolicyController(Get.find()),
    );
  }
}
