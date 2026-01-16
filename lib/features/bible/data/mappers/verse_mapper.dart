import '../../domain/entities/bible_ref.dart';
import '../../domain/entities/verse_entity.dart';
import '../models/verse_model.dart';

class VerseMapper {
  static VerseEntity toEntity(VerseModel m) {
    // Parse a key para extrair os versículos
    // Formato pode ser "43:3:16" ou "43:3:16-18"
    final parts = m.key.split(':');
    String verseRange = parts.length >= 3 ? parts[2] : m.verse.toString();
    
    return VerseEntity(
      ref: BibleRef(book: m.book, chapter: m.chapter, verse: m.verse),
      verseText: m.verseText,
      language: m.language,
      topics: m.topics,
      verseRange: verseRange, // Passa o range completo
    );
  }

  static VerseModel toModel(VerseEntity e) {
    final m = VerseModel()
      ..key = e.key
      ..book = e.ref.book
      ..chapter = e.ref.chapter
      ..verse = e.ref.verse
      ..verseText = e.verseText
      ..language = e.language
      ..topics = e.topics;
    return m;
  }
}