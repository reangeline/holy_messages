import 'package:hive_flutter/hive_flutter.dart';
import '../../features/bible/data/models/verse_model.dart';
import '../../features/bible/domain/entities/favorite.dart';

class IsarDb {
  IsarDb._();
  static Box<VerseModel>? _verseBox;

  static Future<void> initialize() async {
    // Não inicializar Hive aqui - já foi inicializado no main.dart
    // Apenas registrar os adapters e abrir o box
    try {
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(VerseModelAdapter());
        print('✅ VerseModelAdapter registrado');
      }
      
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(FavoriteAdapter());
        print('✅ FavoriteAdapter registrado');
      }
      
      _verseBox = await Hive.openBox<VerseModel>('verses');
      print('✅ Box verses aberto: ${_verseBox?.length ?? 0} itens');
    } catch (e) {
      print('❌ Erro ao inicializar IsarDb: $e');
      rethrow;
    }
  }

  static Box<VerseModel> get verseBox {
    if (_verseBox == null) {
      throw Exception('IsarDb not initialized. Call initialize() first.');
    }
    return _verseBox!;
  }
}