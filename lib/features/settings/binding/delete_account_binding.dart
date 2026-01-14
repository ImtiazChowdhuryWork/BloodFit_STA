import 'package:bloodfit/features/settings/data/controller/delete_account_controller.dart';
import 'package:bloodfit/features/settings/data/repository/delete_account_repository.dart';
import 'package:get/get.dart';

class DeleteAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteAccountRepository>(
      () => DeleteAccountRepository(Get.find()),
    );
    Get.lazyPut<DeleteAccountController>(
      () => DeleteAccountController(Get.find()),
    );
  }
}
