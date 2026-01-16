import 'bible_ref.dart';
import 'app_language.dart';

class VerseEntity {
  final BibleRef ref;

  /// Texto do versículo
  final String verseText;

  /// Idioma do texto
  final String language;

  /// ids de temas
  final List<String> topics;
  
  /// Range de versículos (ex: "16" ou "16-18")
  final String? verseRange;

  const VerseEntity({
    required this.ref,
    required this.verseText,
    required this.language,
    this.topics = const [],
    this.verseRange,
  });

  String text(AppLanguage lang) {
    // Por enquanto, retorna o texto único. Futuramente, pode suportar múltiplos idiomas.
    return verseText;
  }

  String get key => ref.key;
  
  /// Referência com nome do livro (ex: "João 3:16" ou "João 3:16-18")
  String get keyWithBookName {
    if (verseRange != null && verseRange!.isNotEmpty) {
      return '${ref.bookName} ${ref.chapter}:$verseRange';
    }
    return ref.keyWithBookName;
  }
  
  /// Capítulo
  int get chapter => ref.chapter;
  
  /// Versículo
  int get verse => ref.verse;
  
  /// Nome do livro (ex: "João")
  String get bookName => ref.bookName;
}