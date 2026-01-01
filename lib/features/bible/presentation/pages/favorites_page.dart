import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

import 'verse_detail_page.dart';
import '../state/favorites_controller.dart';
import '../../domain/entities/favorite.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Meus Favoritos')),
      body: favs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text('Nenhum favorito ainda.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final Favorite fav = list[i];
              return Card(
                child: ListTile(
                  title: Text(fav.verse, maxLines: 2, overflow: TextOverflow.ellipsis),
                  subtitle: Text(fav.reference),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerseDetailPage(
                          verseText: fav.verse,
                          reference: fav.reference,
                        ),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          share_plus.Share.share('"${fav.verse}"\n\n— ${fav.reference}',
                              subject: 'Versículo');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).removeFavorite(fav.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Removido dos favoritos')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
