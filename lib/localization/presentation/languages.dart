import 'package:get/get.dart';

import '../language_files/lang_files/bn_BD.dart';
import '../language_files/lang_files/en_US.dart';

class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': englishLanguage,
    'bn_BD': banglaLanguage,
  };
}
