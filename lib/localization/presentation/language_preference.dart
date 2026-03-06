import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class LanguagePreference {
  static const _key = 'user_language_locale';
  static const _defaultLocale = Locale('en', 'US');

  /// Get saved locale from storage
  static Locale getSavedLocale() {
    final box = GetStorage();
    final langCode = box.read<String>(_key);

    if (langCode == null) return _defaultLocale;

    final parts = langCode.split('_');
    if (parts.length == 2) {
      return Locale(parts[0], parts[1]);
    }
    return Locale(parts[0]);
  }

  /// Save locale to storage
  static Future<void> saveLocale(Locale locale) async {
    final box = GetStorage();
    final langCode = '${locale.languageCode}_${locale.countryCode ?? 'US'}';
    await box.write(_key, langCode);
  }

  /// Clear saved preference (optional)
  static Future<void> clear() async {
    final box = GetStorage();
    await box.remove(_key);
  }

  /// Get current language code
  static String get currentLangCode => getSavedLocale().languageCode;

  /// Check if Korean is active
  static bool get isKorean => currentLangCode == 'ko';
}