import 'package:hive/hive.dart';

part 'verse_model.g.dart';

@HiveType(typeId: 0)
class VerseModel extends HiveObject {
  @HiveField(0)
  late String key;

  @HiveField(1)
  late int book;

  @HiveField(2)
  late int chapter;

  @HiveField(3)
  late int verse;

  @HiveField(4)
  late String verseText;

  @HiveField(5)
  late String language;

  @HiveField(6)
  List<String> topics = [];

  @HiveField(7)
  int weight = 1;

  @HiveField(8)
  String? verseRange;

  VerseModel();

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    // Accept several possible field names from different JSON sources
    String? extractString(Map<String, dynamic> j, List<String> keys) {
      for (final k in keys) {
        final v = j[k];
        if (v != null) return v.toString();
      }
      return null;
    }

    int? extractInt(Map<String, dynamic> j, String key) {
      final v = j[key];
      if (v is int) return v;
      if (v is String) return int.tryParse(v);
      return null;
    }

    final keyVal = extractString(json, ['key', 'id']);
    final bookVal = extractInt(json, 'book') ?? 0;
    final chapterVal = extractInt(json, 'chapter') ?? 0;
    final verseVal = extractInt(json, 'verse') ?? 0;
    final textVal = extractString(json, ['text', 'verseText', 'verse_text', 'text_pt', 'textPt']) ?? '';
    final langVal = extractString(json, ['language', 'lang']) ?? 'pt-BR';
    final topicsRaw = json['topics'];
    final topicsVal = (topicsRaw is List) ? topicsRaw.map((e) => e?.toString() ?? '').where((s) => s.isNotEmpty).toList() : <String>[];
    final weightVal = (json['weight'] is int) ? (json['weight'] as int) : (json['weight'] is String ? int.tryParse(json['weight'] as String) : null) ?? 1;

    return VerseModel()
      ..key = keyVal ?? '$bookVal:$chapterVal:$verseVal'
      ..book = bookVal
      ..chapter = chapterVal
      ..verse = verseVal
      ..verseText = textVal
      ..language = langVal
      ..topics = topicsVal
      ..weight = weightVal;
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'text': verseText,
      'language': language,
      'topics': topics,
      'weight': weight,
    };
  }
}