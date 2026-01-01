import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/verse_entity.dart';
import '../state/bible_providers.dart';

class DailyVerseController extends AsyncNotifier<VerseEntity?> {
  @override
  Future<VerseEntity?> build() async {
    // garante seed antes de consultar (forçando rebuild dos dados)
    final ds = ref.read(bibleLocalDataSourceProvider);
    await ds.ensureSeededFromAssets(forceRebuild: true);

    final lang = ref.watch(appLanguageProvider);
    final usecase = ref.read(getDailyVerseUseCaseProvider);

    return usecase(date: DateTime.now(), language: lang);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lang = ref.read(appLanguageProvider);
      final usecase = ref.read(getDailyVerseUseCaseProvider);
      return usecase(date: DateTime.now(), language: lang);
    });
  }
}

final dailyVerseControllerProvider =
    AsyncNotifierProvider<DailyVerseController, VerseEntity?>(
  DailyVerseController.new,
);