import 'package:bloodfit/features/add_promo_code/data/controller/add_poromocode_screen_controller.dart';
import 'package:get/get.dart';

import '../data/repository/add_promocode_repository.dart';

class AddPromoCodeBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> AddPromocodeRepository(Get.find()));
    Get.lazyPut(()=> AddPoromocodeScreenController(Get.find()));
  }
}