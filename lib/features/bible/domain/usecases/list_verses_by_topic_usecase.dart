import '../entities/app_language.dart';
import '../entities/verse_entity.dart';
import '../repositories/bible_repository.dart';

class ListVersesByTopicUseCase {
  final BibleRepository repository;

  const ListVersesByTopicUseCase(this.repository);

  Future<List<VerseEntity>> call({
    required String topicId,
    required AppLanguage language,
    int limit = 100,
    int offset = 0,
  }) {
    final id = topicId.trim();
    if (id.isEmpty) return Future.value(const []);
    return repository.listVersesByTopic(
      topicId: id,
      language: language,
      limit: limit,
      offset: offset,
    );
  }
}