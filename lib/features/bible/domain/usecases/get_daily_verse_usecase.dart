import '../entities/app_language.dart';
import '../entities/verse_entity.dart';
import '../repositories/bible_repository.dart';

class GetDailyVerseUseCase {
  final BibleRepository repository;

  const GetDailyVerseUseCase(this.repository);

  Future<VerseEntity?> call({
    required DateTime date,
    required AppLanguage language,
    bool forceRandom = false,
  }) {
    return repository.getDailyVerse(date: date, language: language, forceRandom: forceRandom);
  }
}