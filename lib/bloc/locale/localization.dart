// lib/bloc/locale/locale_cubit.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en')) {
    _loadSavedLocale();
  }

  static const String _localeKey = 'app_locale';

  // Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_localeKey);
      
      if (languageCode != null) {
        emit(Locale(languageCode));
      }
    } catch (e) {
      print('Error loading locale: $e');
    }
  }

  // Change locale and save to SharedPreferences
  Future<void> changeLocale(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, languageCode);
      emit(Locale(languageCode));
      print('Locale changed to: $languageCode');
    } catch (e) {
      print('Error changing locale: $e');
    }
  }

  // Toggle between English and Arabic
  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'en' ? 'ar' : 'en';
    await changeLocale(newLocale);
  }

  // Get current language code
  String get currentLanguageCode => state.languageCode;

  // Check if current language is Arabic
  bool get isArabic => state.languageCode == 'ar';

  // Check if current language is English
  bool get isEnglish => state.languageCode == 'en';
}