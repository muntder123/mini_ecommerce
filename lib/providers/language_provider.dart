import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LanguageNotifier extends StateNotifier<Locale> {
  static const String languageBoxName = 'language';
  static const String languageKey = 'selected_locale';

  LanguageNotifier() : super(const Locale('en')) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      // Wait for Hive to be initialized
      int attempts = 0;
      while (!Hive.isBoxOpen(languageBoxName) && attempts < 50) {
        await Future.delayed(const Duration(milliseconds: 100));
        attempts++;
      }

      if (Hive.isBoxOpen(languageBoxName)) {
        final box = Hive.box(languageBoxName);
        final savedLanguage = box.get(languageKey, defaultValue: 'en');
        state = Locale(savedLanguage);
      }
    } catch (e) {
      // If there's an error, just use default
      print('Error loading language: $e');
    }
  }

  Future<void> setLanguage(String languageCode) async {
    try {
      // Wait for box to be available
      int attempts = 0;
      while (!Hive.isBoxOpen(languageBoxName) && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 50));
        attempts++;
      }

      if (Hive.isBoxOpen(languageBoxName)) {
        final box = Hive.box(languageBoxName);
        await box.put(languageKey, languageCode);
        state = Locale(languageCode);
      }
    } catch (e) {
      print('Error saving language: $e');
    }
  }

  bool get isArabic => state.languageCode == 'ar';
  bool get isEnglish => state.languageCode == 'en';
}

final languageProvider = StateNotifierProvider<LanguageNotifier, Locale>((ref) {
  return LanguageNotifier();
});