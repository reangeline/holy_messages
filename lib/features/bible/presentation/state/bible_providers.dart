import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

import '../../../bible/data/datasources/bible_local_datasource.dart';
import '../../../bible/data/datasources/bible_firestore_datasource.dart';
import '../../../bible/data/datasources/bible_remote_datasource.dart';
import '../../../bible/data/remote_config.dart';
import '../../../bible/data/repositories/bible_repository_premium.dart';
import '../../../bible/domain/repositories/bible_repository.dart';
import '../../../bible/domain/usecases/get_daily_verse_usecase.dart';
import '../../../bible/domain/entities/app_language.dart';
import '../../../settings/state/locale_provider.dart';
import '../../../../core/l10n/app_strings.dart';
// premium gating removed for Bible features; connectivity provider not used for gating
import '../../../../core/storage/isar_db.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

// Datasource
final bibleLocalDataSourceProvider = Provider<BibleLocalDataSource>((ref) {
  return BibleLocalDataSource();
});

final bibleFirestoreDataSourceProvider = Provider<BibleFirestoreDataSource>((ref) {
  return BibleFirestoreDataSource();
});

final bibleRemoteDataSourceProvider = Provider<BibleRemoteDataSource>((ref) {
  final lang = ref.watch(appLanguageProvider);
  final url = remoteVersesUrlFor(lang.code);
  final remote = BibleRemoteDataSource(url: url);

  // Reseed local DB automatically when app language changes.
  ref.listen<AppLanguage>(appLanguageProvider, (previous, next) async {
    try {
      final local = ref.read(bibleLocalDataSourceProvider);
      debugPrint('bibleRemoteDataSourceProvider: language changed from $previous to $next — reseeding local DB...');
      await local.ensureSeededFromAssets(forceRebuild: true, language: next);
      debugPrint('bibleRemoteDataSourceProvider: reseed complete');
    } catch (e, st) {
      debugPrint('bibleRemoteDataSourceProvider: erro ao reseed on language change: $e\n$st');
    }
  });

  return remote;
});

// Repository
final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  return BibleRepositoryPremium(
    local: ref.read(bibleLocalDataSourceProvider),
    firestore: ref.read(bibleFirestoreDataSourceProvider),
    remote: ref.read(bibleRemoteDataSourceProvider),
    ref: ref,
  );
});

// Usecase
final getDailyVerseUseCaseProvider = Provider<GetDailyVerseUseCase>((ref) {
  return GetDailyVerseUseCase(ref.read(bibleRepositoryProvider));
});

// Idioma atual - usa o localeProvider do usuário
final appLanguageProvider = Provider<AppLanguage>((ref) {
  // Primeiro tenta usar a preferência do usuário
  final userLocale = ref.watch(localeProvider);
  final detectedLang = AppLanguage.fromCode(userLocale.languageCode);
  debugPrint('🌐 appLanguageProvider: locale=${userLocale.languageCode}, language=$detectedLang');
  return detectedLang;
});

// Strings localizadas
final appStringsProvider = Provider<AppStrings>((ref) {
  final lang = ref.watch(appLanguageProvider);
  return AppStrings(lang);
});

// Simple connectivity check provider (uses DNS lookup, fast)
final isOnlineProvider = FutureProvider<bool>((ref) async {
  // Try a quick lightweight request to a fast endpoint that returns 204.
  // Fallback to DNS lookup if HTTP fails.
  try {
    final uri = Uri.parse('https://clients3.google.com/generate_204');
    final resp = await http.get(uri).timeout(const Duration(seconds: 2));
    return resp.statusCode == 204 || resp.statusCode == 200;
  } catch (_) {
    try {
      final result = await InternetAddress.lookup('1.1.1.1').timeout(const Duration(seconds: 2));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
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
  debugPrint('getAllBooksProvider: iniciando...');
  final datasource = ref.read(bibleLocalDataSourceProvider);
  debugPrint('getAllBooksProvider: chamando ensureSeededFromAssets com forceRebuild=false...');
  final lang = ref.watch(appLanguageProvider);
  await datasource.ensureSeededFromAssets(forceRebuild: false, language: lang);
  debugPrint('getAllBooksProvider: after seed, box length=${IsarDb.verseBox.length}');
  final exampleKeys = IsarDb.verseBox.keys.take(6).toList();
  debugPrint('getAllBooksProvider: example keys=$exampleKeys');
  debugPrint('getAllBooksProvider: chamando getAllBooks...');
  final books = await datasource.getAllBooks(language: lang);
  debugPrint('getAllBooksProvider: detected books list=$books');
  debugPrint('getAllBooksProvider: retornando ${books.length} livros');
  return books;
});

final getChaptersByBookProvider =
    FutureProvider.family<List<int>, String>((ref, bookName) async {
  final datasource = ref.read(bibleLocalDataSourceProvider);
  final lang = ref.watch(appLanguageProvider);
  // Ensure local DB seeded for the requested language before querying
  await datasource.ensureSeededFromAssets(forceRebuild: false, language: lang);
  return datasource.getChaptersByBook(bookName, langCode: lang.code);
});

final getVersesByChapterProvider = FutureProvider.family<List, (String, int)>(
    (ref, params) async {
  final datasource = ref.read(bibleLocalDataSourceProvider);
  final lang = ref.watch(appLanguageProvider);
  final (bookName, chapter) = params;
  // Ensure local DB seeded for the requested language before querying
  await datasource.ensureSeededFromAssets(forceRebuild: false, language: lang);
  return datasource.getVersesByChapter(bookName, chapter, langCode: lang.code);
});