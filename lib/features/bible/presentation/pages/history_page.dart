import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:intl/intl.dart';

import '../state/bible_providers.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  void _openDetail(dynamic message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text((message['reference'] as String?) ?? ''),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('"${(message['verse'] as String?) ?? ''}"', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 12),
              if (message['reflection'] != null) Text(message['reflection'] as String),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              share_plus.Share.share('"${(message['verse'] as String?) ?? ''}"\n\n— ${(message['reference'] as String?) ?? ''}',
                  subject: 'Mensagem Bíblica');
              Navigator.of(context).pop();
            },

            child: const Text('Compartilhar'),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(biblicalMessagesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: messagesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (messages) {
          if (messages.isEmpty) return const Center(child: Text('Nenhuma mensagem ainda.'));
          final grouped = <String, List<dynamic>>{};
          for (var m in messages) {
            if (m['date'] == null) continue;
            final dt = DateTime.tryParse(m['date'] as String) ?? DateTime.now();
            final key = DateFormat('MMMM yyyy', 'pt_BR').format(dt);
            grouped.putIfAbsent(key, () => []).add(m);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: grouped.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ...entry.value.map((message) {
                    final dt = DateTime.tryParse(message['date'] as String? ?? '') ?? DateTime.now();
                    return ListTile(
                      onTap: () => _openDetail(message),
                      title: Text('"${(message['verse'] as String?) ?? ''}"', maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: Text((message['reference'] as String?) ?? ''),
                      trailing: Text(DateFormat("dd 'de' MMM", 'pt_BR').format(dt)),
                    );
                  }).toList(),
                  const SizedBox(height: 12),
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
