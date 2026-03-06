/**
import 'package:get/get.dart';

import '../language_files/lang_files/ko_KR.dart';
import '../language_files/lang_files/en_US.dart';

class Languages extends Translations {
  @override
  // TODO: implement keys
  Map<String, Map<String, String>> get keys => {
    'en_US': englishLanguage,
    'ko_KR': koreanLanguage,
  };
}
*/






///
///
/// todo:: added by rakibul
///
///
///
///
/// todo:: adding text for the english-korian
///
///
///



import 'package:get/get.dart';

import '../language_files/lang_files/ko_KR.dart';
import '../language_files/lang_files/en_US.dart';

class Languages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': englishLanguage,
    'ko_KR': koreanLanguage,
  };
}
