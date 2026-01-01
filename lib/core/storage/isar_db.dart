import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../features/bible/data/models/verse_model.dart';

class IsarDb {
  IsarDb._();
  static Isar? _isar;

  static Future<Isar> open() async {
    if (_isar != null) return _isar!;
    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [VerseModelSchema],
      directory: dir.path,
      name: 'bible_app',
    );

    return _isar!;
  }
}