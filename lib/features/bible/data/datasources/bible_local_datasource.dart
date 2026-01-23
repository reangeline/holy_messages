import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/isar_db.dart';
import '../../domain/entities/app_language.dart';
import '../models/verse_model.dart';
import '../models/holy_message_model.dart';
import 'holy_messages_datasource.dart';
import '../book_names.dart';

class BibleLocalDataSource {
  Box<VerseModel> get _db => IsarDb.verseBox;
  final HolyMessagesDataSource _holyMessagesDataSource = HolyMessagesDataSource();

  /// Chame no bootstrap do app: garante que o seed rode 1x

  /// Prefix for language-specific keys
  String _langPrefix(String langCode) => '__${langCode.toLowerCase()}__';

  /// Compose a language-prefixed key
  String _langKey(String langCode, String key) => '${_langPrefix(langCode)}$key';

  /// Returns all keys for a given language
  Iterable<String> _keysForLang(Box<VerseModel> box, String langCode) {
    final prefix = _langPrefix(langCode);
    return box.keys.where((k) => k is String && k.startsWith(prefix)).cast<String>();
  }

  Future<void> ensureSeededFromAssets({
    required AppLanguage language,
    String? assetPath,
    bool forceRebuild = false,
  }) async {
    final box = _db;
    final langCode = language.code;
    // final langPrefix = _langPrefix(langCode); // No longer needed
    final langKeys = _keysForLang(box, langCode);
    final count = langKeys.length;
    debugPrint('ensureSeededFromAssets: count=$count, forceRebuild=$forceRebuild, lang=$langCode');

    // Only clear this language's keys if forceRebuild
    if (forceRebuild && count > 0) {
      debugPrint('ensureSeededFromAssets: limpando dados antigos para idioma $langCode...');
      for (final k in langKeys) {
        await box.delete(k);
      }
    }

    final countAfterCheck = _keysForLang(box, langCode).length;
    if (countAfterCheck > 0 && !forceRebuild) {
      debugPrint('ensureSeededFromAssets: dados já existem no idioma solicitado ($langCode), saindo');
      return;
    }

    // Always load verses from bundled assets (no CDN/network fetch).
    List<VerseModel> models = [];
    try {
      final fallbackAsset = assetPath ?? (language == AppLanguage.pt ? 'assets/data/verses-pt-BR.json' : 'assets/data/verses-en-US.json');
      final raw = await rootBundle.loadString(fallbackAsset);
      final List<dynamic> list = json.decode(raw);
      debugPrint('ensureSeededFromAssets: assets OK com ${list.length} versículos (asset=$fallbackAsset)');

      int? extractInt(dynamic v) {
        if (v is int) return v;
        if (v is String) return int.tryParse(v);
        return null;
      }

      String? extractString(Map<String, dynamic> j, List<String> keys) {
        for (final k in keys) {
          final val = j[k];
          if (val != null) return val.toString();
        }
        return null;
      }

      models = list.map((e) {
        final Map<String, dynamic> j = Map<String, dynamic>.from(e);
        final book = extractInt(j['book']) ?? 0;
        final chapter = extractInt(j['chapter']) ?? 0;
        final verse = extractInt(j['verse']) ?? 0;

        final key = extractString(j, ['key', 'id']) ?? '$book:$chapter:$verse';
        final text = extractString(j, ['text', 'textPt', 'text_pt', 'verseText', 'verse_text']) ?? '';
        final languageFromJson = extractString(j, ['language', 'lang']) ?? language.code;
        final topics = (j['topics'] is List) ? (j['topics'] as List).map((x) => x?.toString() ?? '').where((s) => s.isNotEmpty).toList() : <String>[];
        final weight = (j['weight'] is int) ? (j['weight'] as int) : (j['weight'] is String ? int.tryParse(j['weight'] as String) : null) ?? 1;

        final m = VerseModel()
          ..book = book
          ..chapter = chapter
          ..verse = verse
          ..key = key
          ..verseText = text
          ..language = languageFromJson
          ..topics = topics
          ..weight = weight;
        return m;
      }).toList();

      // Normalize language tag to requested language for consistency
      try {
        for (final m in models) {
          m.language = language.code;
        }
      } catch (setLangErr) {
        debugPrint('ensureSeededFromAssets: aviso ao setar language nos modelos (assets): $setLangErr');
      }
    } catch (assetErr) {
      debugPrint('ensureSeededFromAssets: falha ao carregar assets: $assetErr');
      // Try alternative asset candidates before giving up
      final candidates = <String>[];
      candidates.add(assetPath ?? (language == AppLanguage.pt ? 'assets/data/verses-pt-BR.json' : 'assets/data/verses-en-US.json'));
      candidates.addAll([
        'assets/data/holy_messages.json',
        'assets/data/verses.json',
      ]);

      String? rawAlt;
      String? usedCandidate;
      for (final c in candidates) {
        try {
          rawAlt = await rootBundle.loadString(c);
          usedCandidate = c;
          debugPrint('ensureSeededFromAssets: achei asset alternativo: $c');
          break;
        } catch (e) {
          debugPrint('ensureSeededFromAssets: asset não encontrado: $c');
        }
      }

      if (rawAlt != null) {
        try {
          final decoded = json.decode(rawAlt);
          if (decoded is! List) {
            debugPrint('ensureSeededFromAssets: asset alternativo não é uma lista, ignorando: $usedCandidate');
            rawAlt = null;
          } else {
            final List<dynamic> list = decoded;
            bool looksLikeVerses(List<dynamic> l) {
              if (l.isEmpty) return false;
              final sample = l.take(5).toList();
              for (final item in sample) {
                if (item is Map<String, dynamic>) {
                  if (item.containsKey('book') || item.containsKey('verse') || item.containsKey('chapter')) return true;
                  if (item.containsKey('verseText') || item.containsKey('text') || item.containsKey('textPt') || item.containsKey('verse_text')) return true;
                  final keyVal = item['key'] ?? item['id'];
                  if (keyVal is String && RegExp(r'^\d+:\d+:\d+').hasMatch(keyVal)) return true;
                }
              }
              return false;
            }

            if (!looksLikeVerses(list)) {
              debugPrint('ensureSeededFromAssets: asset alternativo NÃO parece conter versículos (ignorado): $usedCandidate');
              rawAlt = null;
            } else {
              debugPrint('ensureSeededFromAssets: assets alternativo OK ($usedCandidate) com ${list.length} versículos');
              int? extractInt(dynamic v) {
                if (v is int) return v;
                if (v is String) return int.tryParse(v);
                return null;
              }

              String? extractString(Map<String, dynamic> j, List<String> keys) {
                for (final k in keys) {
                  final val = j[k];
                  if (val != null) return val.toString();
                }
                return null;
              }

              models = list.map((e) {
                final Map<String, dynamic> j = Map<String, dynamic>.from(e);
                final book = extractInt(j['book']) ?? 0;
                final chapter = extractInt(j['chapter']) ?? 0;
                final verse = extractInt(j['verse']) ?? 0;

                final key = extractString(j, ['key', 'id']) ?? '$book:$chapter:$verse';
                final text = extractString(j, ['text', 'textPt', 'text_pt', 'verseText', 'verse_text']) ?? '';
                final languageFromJson = extractString(j, ['language', 'lang']) ?? language.code;
                final topics = (j['topics'] is List) ? (j['topics'] as List).map((x) => x?.toString() ?? '').where((s) => s.isNotEmpty).toList() : <String>[];
                final weight = (j['weight'] is int) ? (j['weight'] as int) : (j['weight'] is String ? int.tryParse(j['weight'] as String) : null) ?? 1;

                final m = VerseModel()
                  ..book = book
                  ..chapter = chapter
                  ..verse = verse
                  ..key = key
                  ..verseText = text
                  ..language = languageFromJson
                  ..topics = topics
                  ..weight = weight;
                return m;
              }).toList();

              // Normalize language tag to requested language for consistency
              try {
                for (final m in models) {
                  m.language = language.code;
                }
              } catch (setLangErr) {
                debugPrint('ensureSeededFromAssets: aviso ao setar language nos modelos (assets alternativo): $setLangErr');
              }
            }
          }
        } catch (parseErr) {
          debugPrint('ensureSeededFromAssets: falha ao decodificar asset alternativo: $parseErr');
          rethrow;
        }
      }
      if (rawAlt == null) {
        debugPrint('ensureSeededFromAssets: nenhum asset alternativo encontrado, tentando fallback por clone de outro idioma no DB...');

        // Se não encontramos asset para o idioma solicitado, tentamos clonar
        // dados de outro idioma já presente no banco (por exemplo 'en').
        try {
          final allKeys = box.keys.whereType<String>().toList();
          // Encontrar prefixos distintos presentes no banco (ex: __en__, __pt__)
          final prefixes = <String, int>{};
          for (final k in allKeys) {
            final m = RegExp(r'^__(\w{2})__').firstMatch(k);
            if (m != null) {
              prefixes.update(m.group(1)!, (v) => v + 1, ifAbsent: () => 1);
            }
          }

          // Remove o idioma solicitado
          prefixes.remove(langCode.toLowerCase());

          if (prefixes.isNotEmpty) {
            // Escolher o prefixo com mais ocorrências (provavelmente 'en')
            final sourceLang = prefixes.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
            final src = sourceLang.first.key; // ex: 'en'
            debugPrint('ensureSeededFromAssets: clonando dados do idioma encontrado "$src" para "$langCode"...');

            final srcPrefix = '__${src.toLowerCase()}__';
            final dstPrefix = _langPrefix(langCode);
            int copied = 0;
            for (final k in allKeys) {
              if (k.startsWith(srcPrefix)) {
                final v = box.get(k);
                if (v == null) continue;
                final newKey = k.replaceFirst(srcPrefix, dstPrefix);
                final clone = VerseModel()
                  ..book = v.book
                  ..chapter = v.chapter
                  ..verse = v.verse
                  ..key = v.key
                  ..verseText = v.verseText
                  ..language = langCode
                  ..topics = List<String>.from(v.topics)
                  ..weight = v.weight
                  ..verseRange = v.verseRange;
                await box.put(newKey, clone);
                copied++;
              }
            }
            debugPrint('ensureSeededFromAssets: fallback clone completo — $copied versículos copiados para $langCode');
            return;
          }
        } catch (cloneErr) {
          debugPrint('ensureSeededFromAssets: falha ao tentar clone de fallback: $cloneErr');
        }

        debugPrint('ensureSeededFromAssets: nenhum asset alternativo encontrado, abortando.');
        return;
      }
    }

    debugPrint('ensureSeededFromAssets: inserindo ${models.length} modelos no Hive para idioma $langCode...');
    for (var i = 0; i < models.length; i++) {
      final langKey = _langKey(langCode, models[i].key);
      await box.put(langKey, models[i]);
    }

    final finalCount = _keysForLang(box, langCode).length;
    debugPrint('ensureSeededFromAssets: concluído! Total no banco para $langCode: $finalCount');

    // Debug: print exemplos de keys/preview (até 20) para diagnóstico
    try {
      final exampleKeys = _keysForLang(box, langCode).take(20).toList();
      debugPrint('ensureSeededFromAssets: exemplo de keys (até 20) para $langCode: $exampleKeys');
      for (var i = 0; i < exampleKeys.length; i++) {
        final k = exampleKeys[i];
        final v = box.get(k);
        final previewText = v?.verseText ?? '';
        final preview = previewText.length > 60 ? '${previewText.substring(0, 60)}...' : previewText;
        debugPrint('  [$i] key=$k book=${v?.book} chapter=${v?.chapter} verse=${v?.verse} preview="${preview}"');
      }
    } catch (e) {
      debugPrint('ensureSeededFromAssets: erro ao imprimir exemplos de keys: $e');
    }
  }

  Future<List<VerseModel>> search({
    required String query,
    required AppLanguage language,
    int limit = 50,
    int offset = 0,
  }) async {
    final box = _db;
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];

    final langCode = language.code;
    final langKeys = _keysForLang(box, langCode);
    final allVerses = langKeys.map((k) => box.get(k)).whereType<VerseModel>().toList();
    final filtered = allVerses.where((verse) {
      return verse.verseText.toLowerCase().contains(q);
    }).toList();

    filtered.sort((a, b) {
      final bookCompare = a.book.compareTo(b.book);
      if (bookCompare != 0) return bookCompare;
      final chapterCompare = a.chapter.compareTo(b.chapter);
      if (chapterCompare != 0) return chapterCompare;
      return a.verse.compareTo(b.verse);
    });

    final start = offset.clamp(0, filtered.length);
    final end = (offset + limit).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  Future<List<VerseModel>> listByTopic({
    required String topicId,
    required AppLanguage language,
    int limit = 100,
    int offset = 0,
  }) async {
    final box = _db;
    final id = topicId.trim();
    if (id.isEmpty) return [];

    final langCode = language.code;
    final langKeys = _keysForLang(box, langCode);
    final allVerses = langKeys.map((k) => box.get(k)).whereType<VerseModel>().toList();
    final filtered = allVerses.where((verse) {
      return verse.topics.contains(id);
    }).toList();

    filtered.sort((a, b) {
      final bookCompare = a.book.compareTo(b.book);
      if (bookCompare != 0) return bookCompare;
      final chapterCompare = a.chapter.compareTo(b.chapter);
      if (chapterCompare != 0) return chapterCompare;
      return a.verse.compareTo(b.verse);
    });

    final start = offset.clamp(0, filtered.length);
    final end = (offset + limit).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }

  Future<VerseModel?> getDailyVerse({
    required DateTime date,
    required AppLanguage language,
    bool forceRandom = false,
  }) async {
    try {
      debugPrint('📖 getDailyVerse: Iniciando...');
      // Carrega as mensagens curadas
      final messages = await _holyMessagesDataSource.loadAllMessages();
      debugPrint('📖 getDailyVerse: ${messages.length} mensagens carregadas');
      if (messages.isEmpty) return null;

      // Seleciona uma mensagem preferencialmente do `holy_messages.json`.
      // Tentamos várias mensagens até encontrar uma que tenha versículos no idioma atual.
      final rand = forceRandom ? Random(DateTime.now().microsecondsSinceEpoch) : Random(date.millisecondsSinceEpoch);
      final indices = List<int>.generate(messages.length, (i) => i);

      if (forceRandom) {
        indices.shuffle(rand);
      } else {
        // Ordem determinística baseada no dia do ano para estabilidade
        final dayIdx = date.difference(DateTime(date.year, 1, 1)).inDays % messages.length;
        indices.sort((a, b) => ((a - dayIdx) % messages.length).compareTo((b - dayIdx) % messages.length));
      }

      HolyMessageModel? selectedMessage;
      int selectedMessageIndex = -1;
      final maxAttempts = messages.length < 6 ? messages.length : 6;
      List<VerseModel> verses = [];
      final box = _db;
      final langCode = language.code;

      final langKeys = _keysForLang(box, langCode);
      debugPrint('📖 getDailyVerse: Box tem ${langKeys.length} versículos para $langCode. Tentando mensagens do holy_messages.json...');

      for (int attempt = 0; attempt < maxAttempts; attempt++) {
        final idx = indices[attempt];
        final candidate = messages[idx];
        debugPrint('📖 getDailyVerse: Tentativa de mensagem #$idx -> ${candidate.title}');

        if (candidate.passages.isEmpty) {
          debugPrint('📖 getDailyVerse: Mensagem #$idx não tem passagens, pulando');
          continue;
        }

        final passage = candidate.passages.first;
        debugPrint('📖 getDailyVerse: ${passage.previewKeys.length} versículos na passagem (mensagem #$idx)');
        debugPrint('📖 getDailyVerse: startKey="${passage.startKey}", endKey="${passage.endKey}"');

        // Parse do startKey e endKey (formato: "book:chapter:verse")
        final startParts = passage.startKey.split(':');
        final endParts = passage.endKey.split(':');

        if (startParts.length != 3 || endParts.length != 3) {
          debugPrint('❌ getDailyVerse: Formato inválido de startKey/endKey para mensagem #$idx');
          continue;
        }

        final book = startParts[0];
        final chapter = startParts[1];
        final startVerse = int.parse(startParts[2]);
        final endVerse = int.parse(endParts[2]);

        debugPrint('📖 getDailyVerse: book=$book, chapter=$chapter, verses $startVerse até $endVerse (mensagem #$idx)');

        final found = <VerseModel>[];
        for (int verseNum = startVerse; verseNum <= endVerse; verseNum++) {
          final key = _langKey(langCode, '$book:$chapter:$verseNum');
          debugPrint('📖 getDailyVerse: Tentando buscar key="$key" (mensagem #$idx)');
          final verse = box.get(key);
          if (verse != null) {
            // Só adiciona se o idioma do versículo for igual ao do app
            if (verse.language.toLowerCase().startsWith(language.code.toLowerCase())) {
              if (verse.verseText.trim().isEmpty) {
                debugPrint('⚠️ getDailyVerse: Versículo $key encontrado mas verseText está VAZIO! (mensagem #$idx)');
                continue;
              }
              found.add(verse);
              final textPreview = verse.verseText.length > 30 ? '${verse.verseText.substring(0, 30)}...' : verse.verseText;
              debugPrint('✅ getDailyVerse: Versículo $key adicionado: $textPreview (mensagem #$idx)');
            } else {
              debugPrint('⚠️ getDailyVerse: Versículo $key ignorado por idioma: ${verse.language} (mensagem #$idx)');
            }
          } else {
            debugPrint('❌ getDailyVerse: Versículo $key NÃO encontrado no Hive! (mensagem #$idx)');
          }
        }

        if (found.isNotEmpty) {
          // Achamos versículos válidos para esta mensagem — usamos e saímos
          selectedMessage = candidate;
          selectedMessageIndex = idx;
          verses = found;
          debugPrint('📣 getDailyVerse: Mensagem válida encontrada: #$selectedMessageIndex -> ${selectedMessage.title}');
          break;
        } else {
          debugPrint('ℹ️ getDailyVerse: Nenhum versículo válido encontrado para mensagem #$idx, tentando próxima');
        }
      }

      // Se não encontramos nenhuma mensagem valida localmente, seguimos com fallback anterior
      if (verses.isEmpty) {
        debugPrint('⚠️ getDailyVerse: Nenhuma mensagem de holy_messages.json retornou versículos no idioma $language — mantendo fallback');
      }

      if (verses.isEmpty) {
        debugPrint('❌ getDailyVerse: Nenhum versículo válido encontrado!');
        return null;
      }

      // Combina os versículos em um único VerseModel
      // Usamos o primeiro versículo como base e concatenamos os textos
      final firstVerse = verses.first;
      final lastVerse = verses.last;
      final combinedText = verses.map((v) => v.verseText).join(' ');
      
      final preview = combinedText.length > 100 ? '${combinedText.substring(0, 100)}...' : combinedText;
      debugPrint('📖 getDailyVerse: Texto combinado (${verses.length} versículos): $preview');

      // Cria uma key que representa todos os versículos
      // Formato: book:chapter:verseStart-verseEnd (ex: 43:3:16-18)
      final combinedKey = verses.length == 1
          ? firstVerse.key
          : '${firstVerse.book}:${firstVerse.chapter}:${firstVerse.verse}-${lastVerse.verse}';
      
      // Define o verseRange (ex: "16-18" ou null se for só um versículo)
      final verseRange = verses.length > 1
          ? '${firstVerse.verse}-${lastVerse.verse}'
          : null;

      debugPrint('📖 getDailyVerse: combinedText length: ${combinedText.length}');
      debugPrint('📖 getDailyVerse: verseRange: $verseRange');

      final result = VerseModel()
        ..key = combinedKey
        ..book = firstVerse.book
        ..chapter = firstVerse.chapter
        ..verse = firstVerse.verse
        ..verseRange = verseRange
        ..verseText = combinedText
        ..language = firstVerse.language
        ..topics = [...firstVerse.topics, selectedMessage!.topic]
        ..weight = firstVerse.weight;
      
      debugPrint('✅ getDailyVerse: Retornando versículo $combinedKey com ${verses.length} versículos combinados');
      return result;
    } catch (e) {
      debugPrint('❌ Erro ao buscar daily verse do holy_messages: $e');
      // Fallback para método antigo em caso de erro
      return _getRandomVerse();
    }
  }

  /// Método fallback que pega um versículo aleatório
  Future<VerseModel?> _getRandomVerse({AppLanguage? language}) async {
    final box = _db;
    if (language == null) {
      if (box.isEmpty) return null;
      final allVerses = box.values.toList();
      final random = Random();
      final idx = random.nextInt(allVerses.length);
      return allVerses[idx];
    }
    final langCode = language.code;
    final langKeys = _keysForLang(box, langCode).toList();
    if (langKeys.isEmpty) return null;
    final random = Random();
    final idx = random.nextInt(langKeys.length);
    return box.get(langKeys[idx]);
  }

  // Novos métodos para Browser de Bíblia
  Future<List<String>> getAllBooks({required AppLanguage language}) async {
    try {
      final box = _db;
      final langCode = language.code;
      final langKeys = _keysForLang(box, langCode);
      final count = langKeys.length;
      debugPrint('Total de versículos no banco para $langCode: $count');
      if (count == 0) {
        debugPrint('Nenhum versículo encontrado para $langCode, tentando carregar...');
        return [];
      }
      final bookNumbers = <int>{};
      final verses = langKeys.map((k) => box.get(k)).whereType<VerseModel>().toList();
      for (final verse in verses) {
        if (verse.book > 0) {
          bookNumbers.add(verse.book);
        }
      }
      if (bookNumbers.isEmpty && verses.isNotEmpty) {
        debugPrint('getAllBooks: nenhum book válido encontrado para $langCode. Exemplos:');
        for (var i = 0; i < (verses.length < 5 ? verses.length : 5); i++) {
          final v = verses[i];
          final previewLen = v.verseText.length > 40 ? 40 : v.verseText.length;
          debugPrint(' sample #$i -> key=${v.key} book=${v.book} chapter=${v.chapter} verse=${v.verse} preview=${v.verseText.substring(0, previewLen)}');
        }
      }
      debugPrint('Livros encontrados: $bookNumbers');
      final bookList = bookNumbers.toList()..sort();
      final bookNames = bookList.map((num) => _getBookName(num)).toList();
      debugPrint('Nomes dos livros: $bookNames');
      return bookNames;
    } catch (e) {
      debugPrint('Erro em getAllBooks: $e');
      rethrow;
    }
  }

  Future<List<int>> getChaptersByBook(String bookName, {String? langCode}) async {
    final box = _db;
    final verses = box.values.toList();

    final bookNum = _getBookNumber(bookName, langCode: langCode);
    final chapters = <int>{};

    for (final verse in verses) {
      // Only consider verses matching the requested language (if provided)
      if (langCode != null && !verse.language.toLowerCase().startsWith(langCode.toLowerCase())) {
        continue;
      }
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
    int chapter, {
    String? langCode,
  }) async {
    final box = _db;
    final bookNum = _getBookNumber(bookName, langCode: langCode);
    
    final allVerses = box.values.toList();
    final filtered = allVerses
        .where((v) {
          if (v.book != bookNum || v.chapter != chapter) return false;
          if (langCode != null) {
            return v.language.toLowerCase().startsWith(langCode.toLowerCase());
          }
          return true;
        })
        .toList();
    
    filtered.sort((a, b) => a.verse.compareTo(b.verse));
    return filtered;
  }

  // Mapear nome de livro para número
  int _getBookNumber(String bookName, {String? langCode}) {
    // Support Portuguese and English lookup by delegating to helper
    try {
      final num = getBookNumberByName(bookName, langCode: langCode ?? 'pt');
      if (num <= 0) return 1;
      return num;
    } catch (_) {
      return 1;
    }
  }

  String _getBookName(int bookNum, {String? langCode}) {
    try {
      return getBookNameByNumber(bookNum, langCode: langCode ?? 'pt');
    } catch (_) {
      return 'Desconhecido';
    }
  }
}
