import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../bible/data/datasources/bible_local_datasource.dart';
import '../../../bible/data/repositories/bible_repository_isar.dart';
import '../../../bible/domain/repositories/bible_repository.dart';
import '../../../bible/domain/usecases/get_daily_verse_usecase.dart';
import '../../../bible/domain/entities/app_language.dart';

// Datasource
final bibleLocalDataSourceProvider = Provider<BibleLocalDataSource>((ref) {
  return BibleLocalDataSource();
});

// Repository
final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  return BibleRepositoryIsar(local: ref.read(bibleLocalDataSourceProvider));
});

// Usecase
final getDailyVerseUseCaseProvider = Provider<GetDailyVerseUseCase>((ref) {
  return GetDailyVerseUseCase(ref.read(bibleRepositoryProvider));
});

// Idioma atual (por enquanto fixo; depois você liga em Settings)
final appLanguageProvider = StateProvider<AppLanguage>((ref) {
  return AppLanguage.pt;
});

/// Provider que retorna as mensagens bíblicas históricas (últimos N dias).
/// Cada item é um `Map` com chaves: 'verse', 'reference', 'date' (ISO) e 'reflection'.
final biblicalMessagesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  const days = 30; // quantos dias históricos mostrar
  final lang = ref.watch(appLanguageProvider);
  final useCase = ref.read(getDailyVerseUseCaseProvider);
  final today = DateTime.now();
  final messages = <Map<String, dynamic>>[];

  for (var i = 0; i < days; i++) {
    final dt = DateTime(today.year, today.month, today.day).subtract(Duration(days: i));
    final v = await useCase.call(date: dt, language: lang);
    if (v == null) continue;
    messages.add({
      'verse': v.text(lang),
      'reference': v.key,
      'date': DateTime(dt.year, dt.month, dt.day).toIso8601String(),
      'reflection': null,
    });
  }

  return messages;
});

// Providers para Browser de Bíblia
final getAllBooksProvider = FutureProvider<List<String>>((ref) async {
  print('getAllBooksProvider: iniciando...');
  final datasource = ref.read(bibleLocalDataSourceProvider);
  print('getAllBooksProvider: chamando ensureSeededFromAssets com forceRebuild=false...');
  await datasource.ensureSeededFromAssets(forceRebuild: false);
  print('getAllBooksProvider: chamando getAllBooks...');
  final books = await datasource.getAllBooks();
  print('getAllBooksProvider: retornando ${books.length} livros');
  return books;
});

final getChaptersByBookProvider =
    FutureProvider.family<List<int>, String>((ref, bookName) async {
  final datasource = ref.read(bibleLocalDataSourceProvider);
  return datasource.getChaptersByBook(bookName);
});

final getVersesByChapterProvider = FutureProvider.family<List, (String, int)>(
    (ref, params) async {
  final datasource = ref.read(bibleLocalDataSourceProvider);
  final (bookName, chapter) = params;
  return datasource.getVersesByChapter(bookName, chapter);
});