import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'lib/app/firebase_options.dart';

/// Script para subir os versículos do JSON para o Firestore
/// Execute com: dart run upload_verses.dart
void main() async {
  print('🚀 Iniciando upload de versículos para Firestore...');

  try {
    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    print('✅ Firebase inicializado');

    // Carregar JSON
    final jsonFile = File('assets/data/verses-pt-BR.json');
    if (!jsonFile.existsSync()) {
      print('❌ Arquivo verses.json não encontrado');
      return;
    }

    final jsonString = await jsonFile.readAsString();
    final List<dynamic> versesJson = json.decode(jsonString);

    print('📖 Carregados ${versesJson.length} versículos do JSON');

    // Conectar ao Firestore
    final firestore = FirebaseFirestore.instance;

    // Subir em lotes para não sobrecarregar
    const batchSize = 500;
    var uploaded = 0;

    for (var i = 0; i < versesJson.length; i += batchSize) {
      final batch = firestore.batch();
      final end = (i + batchSize < versesJson.length) ? i + batchSize : versesJson.length;

      print('📤 Preparando lote ${i ~/ batchSize + 1}: versículos ${i + 1} a $end');

      for (var j = i; j < end; j++) {
        final verseData = versesJson[j] as Map<String, dynamic>;
        final key = verseData['key'] as String;

        // Adicionar documento ao batch
        final docRef = firestore.collection('verses').doc(key);
        batch.set(docRef, verseData);
      }

      // Executar batch
      await batch.commit();
      uploaded += (end - i);
      print('✅ Lote ${i ~/ batchSize + 1} enviado: $uploaded/${versesJson.length} versículos');
    }

    print('🎉 Upload concluído! Total: $uploaded versículos');

  } catch (e) {
    print('❌ Erro durante upload: $e');
  }
}