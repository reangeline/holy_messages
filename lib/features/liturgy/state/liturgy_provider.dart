import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/liturgy_model.dart';
import '../../bible/domain/entities/app_language.dart';
import '../../bible/presentation/state/bible_providers.dart';

final liturgyProvider = StateNotifierProvider<LiturgyNotifier, AsyncValue<List<LiturgyModel>>>((ref) {
  return LiturgyNotifier(ref);
});

class LiturgyNotifier extends StateNotifier<AsyncValue<List<LiturgyModel>>> {
  final Ref ref;

  LiturgyNotifier(this.ref) : super(const AsyncValue.loading()) {
    // Listener para recarregar quando o idioma muda
    ref.listen<AppLanguage>(appLanguageProvider, (previous, next) {
      if (previous != null && previous != next) {
        loadLiturgies();
      }
    });

    loadLiturgies();
  }

  Future<void> loadLiturgies() async {
    try {
      state = const AsyncValue.loading();
      
      final lang = ref.read(appLanguageProvider);
      final fileName = 'assets/data/liturgia_2026_${lang.code}.json';
      
      // Carregar o JSON
      final String jsonString = await rootBundle.loadString(fileName);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      // Parsear as liturgias
      final List<dynamic> items = jsonData['items'] ?? [];
      final List<LiturgyModel> liturgies = items
          .map((item) => LiturgyModel.fromJson(item))
          .toList();
      
      // Filtrar liturgias a partir de hoje
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final filteredLiturgies = liturgies
          .where((liturgy) => !liturgy.dateTime.isBefore(today))
          .toList();
      
      state = AsyncValue.data(filteredLiturgies);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      print('❌ Erro ao carregar liturgias: $e');
    }
  }

  List<LiturgyModel> getLiturgiesForMonth(int year, int month) {
    return state.maybeWhen(
      data: (liturgies) => liturgies.where((l) {
        final date = l.dateTime;
        return date.year == year && date.month == month;
      }).toList(),
      orElse: () => [],
    );
  }
}
