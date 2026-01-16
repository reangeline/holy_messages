import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/verse_model.dart';

/// Datasource para carregar versículos do Firestore (para usuários não premium)
class BibleFirestoreDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Carrega todos os versículos do Firestore
  Future<List<VerseModel>> loadAllVerses() async {
    try {
      print('🔥 Carregando versículos do Firestore...');
      final snapshot = await _firestore.collection('verses').get();

      final verses = snapshot.docs.map((doc) {
        final data = doc.data();
        return VerseModel.fromJson(data);
      }).toList();

      print('✅ Carregados ${verses.length} versículos do Firestore');
      return verses;
    } catch (e) {
      print('❌ Erro ao carregar versículos do Firestore: $e');
      rethrow;
    }
  }

  /// Busca versículos por livro e capítulo
  Future<List<VerseModel>> getVersesByChapter(int book, int chapter) async {
    try {
      final snapshot = await _firestore
          .collection('verses')
          .where('book', isEqualTo: book)
          .where('chapter', isEqualTo: chapter)
          .orderBy('verse')
          .get();

      return snapshot.docs.map((doc) => VerseModel.fromJson(doc.data())).toList();
    } catch (e) {
      print('❌ Erro ao buscar versículos por capítulo: $e');
      rethrow;
    }
  }

  /// Busca versículo específico
  Future<VerseModel?> getVerse(String key) async {
    try {
      final doc = await _firestore.collection('verses').doc(key).get();
      if (doc.exists) {
        return VerseModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      print('❌ Erro ao buscar versículo: $e');
      return null;
    }
  }

  /// Busca versículos por busca de texto
  Future<List<VerseModel>> searchVerses(String query) async {
    try {
      // Como o Firestore não suporta busca de texto livre eficientemente,
      // vamos buscar todos e filtrar localmente
      final allVerses = await loadAllVerses();
      return allVerses.where((verse) =>
        verse.verseText.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      print('❌ Erro ao buscar versículos: $e');
      rethrow;
    }
  }
}