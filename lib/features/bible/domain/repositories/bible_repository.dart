import '../entities/app_language.dart';
import '../entities/verse_entity.dart';
import '../entities/topic_entity.dart';

abstract class BibleRepository {
  /// Versículo do dia (determinístico ou vindo de tabela)
  Future<VerseEntity?> getDailyVerse({
    required DateTime date,
    required AppLanguage language,
  });

  /// Busca por texto no idioma atual
  Future<List<VerseEntity>> searchVerses({
    required String query,
    required AppLanguage language,
    int limit = 50,
    int offset = 0,
  });

  /// Lista versículos por tema (faith, anxiety, etc.)
  Future<List<VerseEntity>> listVersesByTopic({
    required String topicId,
    required AppLanguage language,
    int limit = 100,
    int offset = 0,
  });

  /// Retorna os temas suportados (fixo, sem depender do banco)
  Future<List<TopicEntity>> listTopics();
}