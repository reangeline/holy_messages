import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../settings/state/premium_provider.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/verse_entity.dart';
import '../../domain/repositories/bible_repository.dart';
import '../datasources/bible_firestore_datasource.dart';
import '../datasources/bible_local_datasource.dart';
import '../mappers/verse_mapper.dart';

/// Repository que decide entre dados locais (premium/offline) ou Firestore (não premium/online)
class BibleRepositoryPremium implements BibleRepository {
  final BibleLocalDataSource local;
  final BibleFirestoreDataSource firestore;
  final dynamic remote; // BibleRemoteDataSource (kept dynamic to avoid import cycle in this file path)
  final Ref ref;

  const BibleRepositoryPremium({
    required this.local,
    required this.firestore,
    this.remote,
    required this.ref,
  });

  /// Verifica se o usuário é premium
  bool _isPremium() {
    // Aqui você pode injetar o premiumProvider ou usar uma função
    // Por enquanto, vamos assumir que temos acesso via ref
    try {
      final isPremium = ref.read(premiumProvider);
      return isPremium;
    } catch (e) {
      print('⚠️ Erro ao verificar premium status: $e');
      return false;
    }
  }

  @override
  Future<VerseEntity?> getDailyVerse({
    required DateTime date,
    required AppLanguage language,
    bool forceRandom = false,
  }) async {
    final isPremium = _isPremium();

    if (isPremium) {
      print('⭐ Usuário premium: usando dados locais (offline)');
      final m = await local.getDailyVerse(date: date, language: language, forceRandom: forceRandom);
      if (m == null) return null;
      return VerseMapper.toEntity(m);
    } else {
      // Para usuários não premium, preferimos mensagens do arquivo `holy_messages.json` (via local)
      print('🌐 Usuário não premium: tentando mensagens locais do holy_messages.json primeiro');
      try {
        final localModel = await local.getDailyVerse(date: date, language: language, forceRandom: forceRandom);
        if (localModel != null) {
          print('🌐 daily (local): escolhida a partir de holy_messages.json -> key=${localModel.key}');
          return VerseMapper.toEntity(localModel);
        }

        // Se não houver mensagem válida em local, cai para o datasource remoto
        print('⚠️ daily (local): nenhuma mensagem válida em local, caindo para remote');
        // Preferir remote (CDN) se disponível
        final allVerses = remote != null
            ? await remote.loadAllVerses()
            : await firestore.loadAllVerses();

        if (allVerses.isEmpty) return null;
        if (forceRandom) {
          final rand = Random(DateTime.now().microsecondsSinceEpoch);
          final index = rand.nextInt(allVerses.length);
          final selectedModel = allVerses[index];
          final previewLen = selectedModel.verseText?.length ?? 0;
          final snippet = selectedModel.verseText != null ? selectedModel.verseText!.substring(0, previewLen < 80 ? previewLen : 80) : '';
          print('🌐 daily (random remote): index=$index of ${allVerses.length}, preview="$snippet"');
          return VerseMapper.toEntity(selectedModel);
        }

        final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
        final index = dayOfYear % allVerses.length;
        final selectedModel = allVerses[index];
        return VerseMapper.toEntity(selectedModel);
      } catch (e) {
        print('❌ Erro ao buscar daily verse remoto: $e');
        return null;
      }
    }
  }

  @override
  Future<List<VerseEntity>> searchVerses({
    required String query,
    required AppLanguage language,
    int limit = 50,
    int offset = 0,
  }) async {
    final isPremium = _isPremium();

    if (isPremium) {
      print('⭐ Usuário premium: buscando localmente');
      final list = await local.search(
        query: query,
        language: language,
        limit: limit,
        offset: offset,
      );
      return list.map(VerseMapper.toEntity).toList();
    } else {
      print('🌐 Usuário não premium: buscando no datasource remoto');
      final list = remote != null
          ? await remote.searchVerses(query)
          : await firestore.searchVerses(query);
      return list
          .skip(offset)
          .take(limit)
          .map(VerseMapper.toEntity)
          .toList();
    }
  }

  @override
  Future<List<VerseEntity>> listVersesByTopic({
    required String topicId,
    required AppLanguage language,
    int limit = 100,
    int offset = 0,
  }) async {
    final isPremium = _isPremium();

    if (isPremium) {
      final list = await local.listByTopic(
        topicId: topicId,
        language: language,
        limit: limit,
        offset: offset,
      );
      return list.map(VerseMapper.toEntity).toList();
    } else {
      // Para não premium, buscar todos e filtrar por tópico
      try {
        final allVerses = remote != null
            ? await remote.loadAllVerses()
            : await firestore.loadAllVerses();
        final filtered = allVerses
            .where((verse) => verse.topics.contains(topicId))
            .skip(offset)
            .take(limit)
            .toList();
        return filtered.map(VerseMapper.toEntity).toList();
      } catch (e) {
        print('❌ Erro ao buscar versículos por tópico no Firestore: $e');
        return [];
      }
    }
  }

  @override
  Future<List<TopicEntity>> listTopics() async {
    // Tópicos são os mesmos para todos
    return const [
      TopicEntity(id: 'faith', labelPt: 'Fé', labelEn: 'Faith'),
      TopicEntity(id: 'anxiety', labelPt: 'Ansiedade', labelEn: 'Anxiety'),
      TopicEntity(id: 'family', labelPt: 'Família', labelEn: 'Family'),
      TopicEntity(id: 'forgiveness', labelPt: 'Perdão', labelEn: 'Forgiveness'),
      TopicEntity(id: 'gratitude', labelPt: 'Gratidão', labelEn: 'Gratitude'),
      TopicEntity(id: 'strength', labelPt: 'Força', labelEn: 'Strength'),
    ];
  }
}