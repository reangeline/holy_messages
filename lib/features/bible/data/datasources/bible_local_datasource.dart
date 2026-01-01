import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:isar/isar.dart';

import '../../../../core/storage/isar_db.dart';
import '../../domain/entities/app_language.dart';
import '../models/verse_model.dart';

class BibleLocalDataSource {
  Future<Isar> _db() => IsarDb.open();

  /// Chame no bootstrap do app: garante que o seed rode 1x
  Future<void> ensureSeededFromAssets({
    String assetPath = 'assets/data/verses.json',
    bool forceRebuild = false,
  }) async {
    final isar = await _db();
    final count = await isar.verseModels.count();
    
    print('ensureSeededFromAssets: count=$count, forceRebuild=$forceRebuild');
    
    // Se forceRebuild é true, limpa tudo
    if (forceRebuild && count > 0) {
      print('ensureSeededFromAssets: limpando dados antigos...');
      await isar.writeTxn(() async {
        await isar.verseModels.clear();
      });
    }

    final countAfterCheck = await isar.verseModels.count();
    if (countAfterCheck > 0) {
      print('ensureSeededFromAssets: dados já existem, saindo');
      return;
    }

    print('ensureSeededFromAssets: carregando dados do JSON...');
    final raw = await rootBundle.loadString(assetPath);
    final List<dynamic> list = json.decode(raw);
    print('ensureSeededFromAssets: JSON tem ${list.length} versículos');

    final models = list.map((e) {
      // formato esperado no JSON:
      // { "book":43, "chapter":3, "verse":16, "textPt":"...", "textEn":"...", "topics":["faith"] }
      final book = e['book'] as int;
      final chapter = e['chapter'] as int;
      final verse = e['verse'] as int;

      final m = VerseModel()
        ..book = book
        ..chapter = chapter
        ..verse = verse
        ..key = (e['key'] as String?) ?? '$book:$chapter:$verse'
        ..textPt = (e['textPt'] as String?) ?? ''
        ..textEn = (e['textEn'] as String?) ?? ''
        ..topics = (e['topics'] as List?)?.map((x) => x.toString()).toList() ?? const [];
      return m;
    }).toList();

    print('ensureSeededFromAssets: inserindo ${models.length} modelos no Isar...');
    await isar.writeTxn(() async {
      await isar.verseModels.putAll(models);
    });
    
    final finalCount = await isar.verseModels.count();
    print('ensureSeededFromAssets: concluído! Total no banco: $finalCount');
  }

  Future<List<VerseModel>> search({
    required String query,
    required AppLanguage language,
    int limit = 50,
    int offset = 0,
  }) async {
    final isar = await _db();
    final q = query.trim();
    if (q.isEmpty) return [];

    final base = isar.verseModels.filter();
    final qb = (language == AppLanguage.pt)
        ? base.textPtContains(q, caseSensitive: false)
        : base.textEnContains(q, caseSensitive: false);

    return qb
        .sortByBook()
        .thenByChapter()
        .thenByVerse()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  Future<List<VerseModel>> listByTopic({
    required String topicId,
    int limit = 100,
    int offset = 0,
  }) async {
    final isar = await _db();
    final id = topicId.trim();
    if (id.isEmpty) return [];

    return isar.verseModels
        .filter()
        .topicsElementEqualTo(id)
        .sortByBook()
        .thenByChapter()
        .thenByVerse()
        .offset(offset)
        .limit(limit)
        .findAll();
  }

  Future<VerseModel?> getDailyVerse({
    required DateTime date,
    required AppLanguage language,
  }) async {
    final isar = await _db();
    final total = await isar.verseModels.count();
    if (total == 0) return null;

    // Gera um índice aleatório entre 0 e total-1
    final random = Random();
    final idx = random.nextInt(total);

    final list = await isar.verseModels.where().offset(idx).limit(1).findAll();
    return list.isEmpty ? null : list.first;
  }

  // Novos métodos para Browser de Bíblia
  Future<List<String>> getAllBooks() async {
    try {
      final isar = await _db();
      final count = await isar.verseModels.count();
      print('Total de versículos no banco: $count');
      
      if (count == 0) {
        print('Nenhum versículo encontrado, tentando carregar...');
        return [];
      }
      
      // Usar query builder para pegar apenas os books únicos
      final bookNumbers = <int>{};
      
      // Buscar todos os books diretamente do query
      final verses = await isar.verseModels.where().findAll();
      for (final verse in verses) {
        bookNumbers.add(verse.book);
      }
      
      print('Livros encontrados: $bookNumbers');
      
      final bookList = bookNumbers.toList()..sort();
      final bookNames = bookList.map((num) => _getBookName(num)).toList();
      print('Nomes dos livros: $bookNames');
      return bookNames;
    } catch (e) {
      print('Erro em getAllBooks: $e');
      rethrow;
    }
  }

  Future<List<int>> getChaptersByBook(String bookName) async {
    final isar = await _db();
    final verses = await isar.verseModels.where().findAll();
    
    final bookNum = _getBookNumber(bookName);
    final chapters = <int>{};
    
    for (final verse in verses) {
      final parts = verse.key.split(':');
      if (parts.isNotEmpty) {
        final verseBookNum = int.tryParse(parts[0]);
        if (verseBookNum == bookNum) {
          if (parts.length > 1) {
            final chapter = int.tryParse(parts[1]);
            if (chapter != null) {
              chapters.add(chapter);
            }
          }
        }
      }
    }
    
    return chapters.toList()..sort();
  }

  Future<List<VerseModel>> getVersesByChapter(
    String bookName,
    int chapter,
  ) async {
    final isar = await _db();
    final bookNum = _getBookNumber(bookName);
    
    return isar.verseModels
        .filter()
        .bookEqualTo(bookNum)
        .and()
        .chapterEqualTo(chapter)
        .sortByVerse()
        .findAll();
  }

  // Mapear nome de livro para número
  int _getBookNumber(String bookName) {
    final bookNames = {
      'Gênesis': 1,
      'Êxodo': 2,
      'Levítico': 3,
      'Números': 4,
      'Deuteronômio': 5,
      'Josué': 6,
      'Juízes': 7,
      'Rute': 8,
      '1 Samuel': 9,
      '2 Samuel': 10,
      '1 Reis': 11,
      '2 Reis': 12,
      '1 Crônicas': 13,
      '2 Crônicas': 14,
      'Esdras': 15,
      'Neemias': 16,
      'Ester': 17,
      'Jó': 18,
      'Salmos': 19,
      'Provérbios': 20,
      'Eclesiastes': 21,
      'Cântico dos Cânticos': 22,
      'Isaías': 23,
      'Jeremias': 24,
      'Lamentações': 25,
      'Ezequiel': 26,
      'Daniel': 27,
      'Oséias': 28,
      'Joel': 29,
      'Amós': 30,
      'Obadias': 31,
      'Jonas': 32,
      'Miqueias': 33,
      'Naum': 34,
      'Habacuque': 35,
      'Sofonias': 36,
      'Ageu': 37,
      'Zacarias': 38,
      'Malaquias': 39,
      'Mateus': 40,
      'Marcos': 41,
      'Lucas': 42,
      'João': 43,
      'Atos': 44,
      'Romanos': 45,
      '1 Coríntios': 46,
      '2 Coríntios': 47,
      'Gálatas': 48,
      'Efésios': 49,
      'Filipenses': 50,
      'Colossenses': 51,
      '1 Tessalonicenses': 52,
      '2 Tessalonicenses': 53,
      '1 Timóteo': 54,
      '2 Timóteo': 55,
      'Tito': 56,
      'Filemom': 57,
      'Hebreus': 58,
      'Tiago': 59,
      '1 Pedro': 60,
      '2 Pedro': 61,
      '1 João': 62,
      '2 João': 63,
      '3 João': 64,
      'Judas': 65,
      'Apocalipse': 66,
    };
    return bookNames[bookName] ?? 1;
  }

  String _getBookName(int bookNum) {
    final bookNames = [
      'Gênesis',
      'Êxodo',
      'Levítico',
      'Números',
      'Deuteronômio',
      'Josué',
      'Juízes',
      'Rute',
      '1 Samuel',
      '2 Samuel',
      '1 Reis',
      '2 Reis',
      '1 Crônicas',
      '2 Crônicas',
      'Esdras',
      'Neemias',
      'Ester',
      'Jó',
      'Salmos',
      'Provérbios',
      'Eclesiastes',
      'Cântico dos Cânticos',
      'Isaías',
      'Jeremias',
      'Lamentações',
      'Ezequiel',
      'Daniel',
      'Oséias',
      'Joel',
      'Amós',
      'Obadias',
      'Jonas',
      'Miqueias',
      'Naum',
      'Habacuque',
      'Sofonias',
      'Ageu',
      'Zacarias',
      'Malaquias',
      'Mateus',
      'Marcos',
      'Lucas',
      'João',
      'Atos',
      'Romanos',
      '1 Coríntios',
      '2 Coríntios',
      'Gálatas',
      'Efésios',
      'Filipenses',
      'Colossenses',
      '1 Tessalonicenses',
      '2 Tessalonicenses',
      '1 Timóteo',
      '2 Timóteo',
      'Tito',
      'Filemom',
      'Hebreus',
      'Tiago',
      '1 Pedro',
      '2 Pedro',
      '1 João',
      '2 João',
      '3 João',
      'Judas',
      'Apocalipse',
    ];
    return bookNames.length >= bookNum ? bookNames[bookNum - 1] : 'Desconhecido';
  }
}
