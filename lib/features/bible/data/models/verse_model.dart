import 'package:isar/isar.dart';

part 'verse_model.g.dart';

@collection
class VerseModel {
  VerseModel();

  Id id = Isar.autoIncrement;

  /// chave estável: "book:chapter:verse" (ex "43:3:16")
  @Index(unique: true)
  late String key;

  @Index()
  late int book;

  @Index()
  late int chapter;

  late int verse;

  /// Full-text search em ambos idiomas
  @Index()
  late String textPt;

  @Index()
  late String textEn;

  /// Ex: ["faith","anxiety"]
  List<String> topics = [];

  /// opcional: pra curadoria/ranking
  int weight = 1;
}