import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier();
});

class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier() : super(16.0) {
    _loadFontSize();
  }

  Box<double>? _box;

  Future<void> _loadFontSize() async {
    try {
      _box = await Hive.openBox<double>('font_size');
      final savedSize = _box?.get('fontSize');
      if (savedSize != null) {
        state = savedSize;
      }
    } catch (e) {
      print('Erro ao carregar tamanho da fonte: $e');
    }
  }

  Future<void> setFontSize(double size) async {
    state = size;
    try {
      _box = await Hive.openBox<double>('font_size');
      await _box?.put('fontSize', size);
    } catch (e) {
      print('Erro ao salvar tamanho da fonte: $e');
    }
  }

  Future<void> increaseFontSize() async {
    if (state < 28) {
      await setFontSize(state + 2.0);
    }
  }

  Future<void> decreaseFontSize() async {
    if (state > 12) {
      await setFontSize(state - 2.0);
    }
  }
}
