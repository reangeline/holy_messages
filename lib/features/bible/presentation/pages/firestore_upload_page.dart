import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Widget para upload dos versículos para Firestore
/// Use apenas em modo debug para desenvolvimento
class FirestoreUploadWidget extends StatefulWidget {
  const FirestoreUploadWidget({super.key});

  @override
  State<FirestoreUploadWidget> createState() => _FirestoreUploadWidgetState();
}

class _FirestoreUploadWidgetState extends State<FirestoreUploadWidget> {
  String _status = 'Pronto para upload';
  bool _isUploading = false;
  int _uploaded = 0;
  int _total = 0;

  Future<void> _uploadVerses() async {
    setState(() {
      _isUploading = true;
      _status = 'Carregando JSON...';
    });

    try {
      // Carregar JSON
      final jsonString = await rootBundle.loadString('assets/data/verses-pt-BR.json');
      final List<dynamic> versesJson = json.decode(jsonString);

      setState(() {
        _total = versesJson.length;
        _status = 'Subindo $_total versículos...';
      });

      // Conectar ao Firestore
      final firestore = FirebaseFirestore.instance;

      // Subir em lotes
      const batchSize = 500;
      var uploaded = 0;

      for (var i = 0; i < versesJson.length; i += batchSize) {
        debugPrint('📤 Preparando lote ${i ~/ batchSize + 1}: versículos ${i + 1} a ${((i + batchSize < versesJson.length) ? i + batchSize : versesJson.length)}');
        final batch = firestore.batch();
        final end = (i + batchSize < versesJson.length) ? i + batchSize : versesJson.length;

        for (var j = i; j < end; j++) {
          final verseData = versesJson[j] as Map<String, dynamic>;
          final key = verseData['key'] as String;
          final docRef = firestore.collection('verses').doc(key);
          batch.set(docRef, verseData);
          if (j < i + 3) {
            debugPrint('🔹 Versículo exemplo: $verseData');
          }
        }

        await batch.commit();
        uploaded += (end - i);

        setState(() {
          _uploaded = uploaded;
          _status = 'Subindo... $_uploaded/$_total';
        });
        debugPrint('✅ Lote ${i ~/ batchSize + 1} enviado: $uploaded/${versesJson.length} versículos');
      }

      setState(() {
        _status = '✅ Upload concluído! $_uploaded versículos';
        _isUploading = false;
      });
      debugPrint('🎉 Upload concluído! Total: $uploaded versículos');

    } catch (e) {
      setState(() {
        _status = '❌ Erro: $e';
        _isUploading = false;
      });
      debugPrint('❌ Erro durante upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload para Firestore')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_status, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadVerses,
              child: Text(_isUploading ? 'Subindo...' : 'Iniciar Upload'),
            ),
          ],
        ),
      ),
    );
  }
}