import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(); // Initialized in main.dart
});

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() => LocaleNotifier());

class LocaleNotifier extends Notifier<Locale> {
  static const _localeKey = 'app_locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return _loadLocale(prefs);
  }

  static Locale _loadLocale(SharedPreferences prefs) {
    final localeStr = prefs.getString(_localeKey);
    if (localeStr != null && localeStr.isNotEmpty) {
      return Locale(localeStr);
    }
    return const Locale('en'); // Default to English
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = locale;
    await prefs.setString(_localeKey, locale.languageCode);
  }
}
