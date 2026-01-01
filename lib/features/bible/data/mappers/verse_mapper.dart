import '../../domain/entities/bible_ref.dart';
import '../../domain/entities/verse_entity.dart';
import '../models/verse_model.dart';

class VerseMapper {
  static VerseEntity toEntity(VerseModel m) {
    return VerseEntity(
      ref: BibleRef(book: m.book, chapter: m.chapter, verse: m.verse),
      textPt: m.textPt,
      textEn: m.textEn,
      topics: m.topics,
    );
  }

  static VerseModel toModel(VerseEntity e) {
    final m = VerseModel()
      ..key = e.key
      ..book = e.ref.book
      ..chapter = e.ref.chapter
      ..verse = e.ref.verse
      ..textPt = e.textPt
      ..textEn = e.textEn
      ..topics = e.topics;
    return m;
  }
}