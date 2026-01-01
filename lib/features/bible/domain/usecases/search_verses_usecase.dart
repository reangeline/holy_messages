import '../entities/app_language.dart';
import '../entities/verse_entity.dart';
import '../repositories/bible_repository.dart';

class SearchVersesUseCase {
  final BibleRepository repository;

  const SearchVersesUseCase(this.repository);

  Future<List<VerseEntity>> call({
    required String query,
    required AppLanguage language,
    int limit = 50,
    int offset = 0,
  }) {
    final q = query.trim();
    if (q.isEmpty) return Future.value(const []);
    return repository.searchVerses(
      query: q,
      language: language,
      limit: limit,
      offset: offset,
    );
  }
}