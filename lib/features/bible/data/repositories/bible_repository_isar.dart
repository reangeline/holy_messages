import '../../domain/entities/app_language.dart';
import '../../domain/entities/topic_entity.dart';
import '../../domain/entities/verse_entity.dart';
import '../../domain/repositories/bible_repository.dart';
import '../datasources/bible_local_datasource.dart';
import '../mappers/verse_mapper.dart';

class BibleRepositoryIsar implements BibleRepository {
  final BibleLocalDataSource local;

  const BibleRepositoryIsar({required this.local});

  @override
  Future<VerseEntity?> getDailyVerse({
    required DateTime date,
    required AppLanguage language,
    bool forceRandom = false,
  }) async {
    final m = await local.getDailyVerse(date: date, language: language, forceRandom: forceRandom);
    if (m == null) return null;
    return VerseMapper.toEntity(m);
  }

  @override
  Future<List<VerseEntity>> searchVerses({
    required String query,
    required AppLanguage language,
    int limit = 50,
    int offset = 0,
  }) async {
    final list = await local.search(
      query: query,
      language: language,
      limit: limit,
      offset: offset,
    );
    return list.map(VerseMapper.toEntity).toList();
  }

  @override
  Future<List<VerseEntity>> listVersesByTopic({
    required String topicId,
    required AppLanguage language,
    int limit = 100,
    int offset = 0,
  }) async {
    // idioma não altera o filtro; só altera o texto exibido no Entity
    final list = await local.listByTopic(
      topicId: topicId,
      limit: limit,
      offset: offset, language: language,
    );
    return list.map(VerseMapper.toEntity).toList();
  }

  @override
  Future<List<TopicEntity>> listTopics() async {
    // Recomendo estático (rápido, controlado). Você pode colocar isso em core/constants também.
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