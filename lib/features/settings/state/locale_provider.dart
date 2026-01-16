import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class LocaleNotifier extends StateNotifier<Locale> {
  static const String _localeKey = 'app_locale';
  
  LocaleNotifier() : super(_getSystemLocale()) {
    _loadLocale();
  }

  static Locale _getSystemLocale() {
    final systemLocale = ui.PlatformDispatcher.instance.locale;
    final languageCode = systemLocale.languageCode;
    // Suporta apenas pt e en
    if (languageCode == 'en') {
      return const Locale('en');
    }
    return const Locale('pt'); // Padrão para PT
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey);
    
    if (localeCode != null) {
      state = Locale(localeCode);
      print('🌍 Idioma carregado das preferências: $localeCode');
    } else {
      // Primeira vez - usar idioma do sistema
      final systemLocale = _getSystemLocale();
      state = systemLocale;
      print('🌍 Primeira inicialização - usando idioma do sistema: ${systemLocale.languageCode}');
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    print('🌍 Idioma alterado para: ${locale.languageCode}');
  }

  Future<void> toggleLocale() async {
    final newLocale = state.languageCode == 'pt' 
        ? const Locale('en') 
        : const Locale('pt');
    await setLocale(newLocale);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
