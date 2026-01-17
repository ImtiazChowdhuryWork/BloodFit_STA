import 'package:get/get.dart';

class IgSelectYourCountryScreenController extends GetxController {
  final RxString countryName = ''.obs;
  final RxString countryFlag = ''.obs;

  ///---->>> Set Country Name and Flag Value
  void setCountryNameAndFlag({required String name, required String flag}) {
    countryName.value = name;
    countryFlag.value = flag;
  }

  ///------->>> Remove Country Name And Flag Value
  void removeCountryNameAndFlag() {
    countryName.value = '';
    countryFlag.value = '';
  }
}
