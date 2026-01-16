import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

/// Script simples para subir versículos para Firestore
/// Execute com: dart upload_simple.dart
void main() async {
  print('🚀 Iniciando upload simples de versículos...');

  try {
    // Configuração manual do Firebase (sem firebase_options.dart)
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', // Substitua pela sua chave
        appId: '1:XXXXXXXXXXXX:ios:XXXXXXXXXXXXXXXXXXXXXX', // Substitua pelo seu app ID
        messagingSenderId: 'XXXXXXXXXXXX', // Substitua pelo seu sender ID
        projectId: 'holy-messages-XXXXX', // Substitua pelo seu project ID
      ),
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

    print('📖 Carregados ${versesJson.length} versículos');

    // Conectar ao Firestore
    final firestore = FirebaseFirestore.instance;

    // Upload simples de alguns versículos para teste
    const testCount = 10;
    print('🧪 Fazendo upload de teste com $testCount versículos...');

    final batch = firestore.batch();

    for (var i = 0; i < testCount && i < versesJson.length; i++) {
      final verseData = versesJson[i] as Map<String, dynamic>;
      final key = verseData['key'] as String;
      final docRef = firestore.collection('verses').doc(key);
      batch.set(docRef, verseData);
    }

    await batch.commit();
    print('✅ Upload de teste concluído! $testCount versículos enviados');

  } catch (e) {
    print('❌ Erro: $e');
  }
}