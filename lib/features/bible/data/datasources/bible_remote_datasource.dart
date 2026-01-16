import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';

import '../models/verse_model.dart';

/// Datasource que busca o JSON de versículos via HTTP (CDN / Cloud Storage)
class BibleRemoteDataSource {
  static const _cacheBox = 'remote_cache';
  static const _cacheKey = 'verses_json';
  static const _cacheTsKey = 'verses_last_fetch';

  final Duration cacheTTL;
  final String url;

  BibleRemoteDataSource({this.cacheTTL = const Duration(hours: 720), String? url}) : url = url ?? '';

  Future<List<VerseModel>> loadAllVerses({bool forceRefresh = false}) async {
    try {
      // Tentar cache
      final box = await Hive.openBox(_cacheBox);
      final lastFetch = box.get(_cacheTsKey) as int?;
      final cached = box.get(_cacheKey) as String?;

      if (!forceRefresh && cached != null && lastFetch != null) {
        final age = DateTime.now().millisecondsSinceEpoch - lastFetch;
        if (age < cacheTTL.inMilliseconds) {
          print('[BibleRemoteDataSource] Usando cache local dos versículos (age: ${age ~/ 1000}s, TTL: ${cacheTTL.inSeconds}s)');
          final List<dynamic> list = json.decode(cached);
          return list.map((e) => VerseModel.fromJson(Map<String, dynamic>.from(e))).toList();
        } else {
          print('[BibleRemoteDataSource] Cache expirado (age: ${age ~/ 1000}s, TTL: ${cacheTTL.inSeconds}s), baixando da CDN...');
        }
      } else {
        print('[BibleRemoteDataSource] Cache não encontrado ou forceRefresh=true, baixando da CDN...');
      }

      if (url.isEmpty) {
        throw Exception('REMOTE_VERSES_URL não configurado');
      }

      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      print('[BibleRemoteDataSource] Download dos versículos concluído (${resp.body.length} bytes). Salvando no cache...');
      final List<dynamic> list = json.decode(resp.body);
      // Atualizar cache
      await box.put(_cacheKey, resp.body);
      await box.put(_cacheTsKey, DateTime.now().millisecondsSinceEpoch);

      return list.map((e) => VerseModel.fromJson(Map<String, dynamic>.from(e))).toList();
    } catch (e) {
      print('[BibleRemoteDataSource] Erro ao baixar ou usar cache: $e');
      // Em caso de erro, tentar usar cache mesmo que expirado
      try {
        final box = await Hive.openBox(_cacheBox);
        final cached = box.get(_cacheKey) as String?;
        if (cached != null) {
          print('[BibleRemoteDataSource] Usando cache expirado por falha no download.');
          final List<dynamic> list = json.decode(cached);
          return list.map((e) => VerseModel.fromJson(Map<String, dynamic>.from(e))).toList();
        }
      } catch (_) {}

      rethrow;
    }
  }

  Future<VerseModel?> getVerse(String key) async {
    final all = await loadAllVerses();
    try {
      return all.firstWhere((v) => v.key == key);
    } catch (e) {
      return null;
    }
  }

  Future<List<VerseModel>> searchVerses(String query) async {
    final all = await loadAllVerses();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return all.where((v) => v.verseText.toLowerCase().contains(q)).toList();
  }

  Future<List<VerseModel>> getVersesByChapter(int book, int chapter) async {
    final all = await loadAllVerses();
    final filtered = all.where((v) => v.book == book && v.chapter == chapter).toList();
    filtered.sort((a, b) => a.verse.compareTo(b.verse));
    return filtered;
  }
}
