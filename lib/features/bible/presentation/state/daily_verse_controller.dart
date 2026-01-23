import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/verse_entity.dart';
import '../state/bible_providers.dart';
// Premium/online gating removed for daily verse

class DailyVerseController extends AsyncNotifier<VerseEntity?> {
  int _refreshCount = 0;

  @override
  Future<VerseEntity?> build() async {
    final lang = ref.watch(appLanguageProvider);

    // Só faz seed se necessário, aproveitando o cache local
    final ds = ref.read(bibleLocalDataSourceProvider);
    await ds.ensureSeededFromAssets(forceRebuild: false, language: lang);
    final usecase = ref.read(getDailyVerseUseCaseProvider);

    // Forçar aleatoriedade a cada inicialização para variar a mensagem do dia
    final result = await usecase(date: DateTime.now(), language: lang, forceRandom: true);
    // Log para diagnóstico: qual mensagem foi escolhida
    if (result != null) {
      debugPrint('📣 DailyVerseController: mensagem selecionada key=${result.key}, book=${result.bookName}, chapter=${result.chapter}, verse=${result.verse}');
    } else {
      debugPrint('📣 DailyVerseController: nenhum versículo retornado');
    }
    return result;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    _refreshCount++;
    state = await AsyncValue.guard(() async {
      final lang = ref.read(appLanguageProvider);
      final usecase = ref.read(getDailyVerseUseCaseProvider);
      // Tenta garantir mudança: compara com atual e, se igual, tenta mais alguns offsets
      final current = state.valueOrNull;
      for (int i = 0; i < 3; i++) {
        final offsetDate = DateTime.now().add(Duration(days: _refreshCount + i));
        // Forçamos aleatoriedade nas tentativas de refresh também
        final next = await usecase(date: offsetDate, language: lang, forceRandom: true);
        if (next == null) return null;
        if (current == null ||
            next.key != current.key ||
            next.text(lang) != current.text(lang)) {
          return next;
        }
      }
      // Se ainda assim não mudou, retorna o último obtido
      final fallbackDate = DateTime.now().add(Duration(days: _refreshCount));
      return usecase(date: fallbackDate, language: lang, forceRandom: true);
    });
  }
}

final dailyVerseControllerProvider =
    AsyncNotifierProvider<DailyVerseController, VerseEntity?>(
  DailyVerseController.new,
);