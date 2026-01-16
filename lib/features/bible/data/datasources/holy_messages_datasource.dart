import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/holy_message_model.dart';

/// Datasource para carregar mensagens sagradas curadas
class HolyMessagesDataSource {
  List<HolyMessageModel>? _cachedMessages;

  /// Carrega todas as mensagens do JSON
  Future<List<HolyMessageModel>> loadAllMessages() async {
    if (_cachedMessages != null) {
      return _cachedMessages!;
    }

    try {
      final jsonString = await rootBundle.loadString('assets/data/holy_messages.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      
      _cachedMessages = jsonList
          .map((json) => HolyMessageModel.fromJson(json as Map<String, dynamic>))
          .toList();
      
      return _cachedMessages!;
    } catch (e) {
      print('Erro ao carregar holy_messages.json: $e');
      rethrow;
    }
  }

  /// Busca uma mensagem pelo ID
  Future<HolyMessageModel?> getMessageById(int id) async {
    final messages = await loadAllMessages();
    try {
      return messages.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Retorna o total de mensagens
  Future<int> getMessageCount() async {
    final messages = await loadAllMessages();
    return messages.length;
  }
}
