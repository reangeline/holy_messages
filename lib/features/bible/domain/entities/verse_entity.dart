import 'bible_ref.dart';
import 'app_language.dart';

class VerseEntity {
  final BibleRef ref;

  /// Textos (bilingue)
  final String textPt;
  final String textEn;

  /// ids de temas
  final List<String> topics;

  const VerseEntity({
    required this.ref,
    required this.textPt,
    required this.textEn,
    this.topics = const [],
  });

  String text(AppLanguage lang) =>
      lang == AppLanguage.pt ? textPt : textEn;

  String get key => ref.key;
  
  /// Referência com nome do livro (ex: "João 3:16")
  String get keyWithBookName => ref.keyWithBookName;
  
  /// Capítulo
  int get chapter => ref.chapter;
  
  /// Versículo
  int get verse => ref.verse;
  
  /// Nome do livro (ex: "João")
  String get bookName => ref.bookName;
}