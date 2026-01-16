import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart' as share_plus;

import 'verse_detail_page.dart';
import '../state/favorites_controller.dart';
import '../../domain/entities/favorite.dart';
import '../../../settings/state/premium_provider.dart';
import '../widgets/background_selector_dialog.dart';
import '../state/bible_providers.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favs = ref.watch(favoritesProvider);
    final isPremium = ref.watch(premiumProvider);
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(strings.myFavorites)),
      body: favs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (list) {
          if (list.isEmpty) {
            return Center(child: Text(strings.noFavorites));
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
                        icon: Stack(
                          alignment: Alignment.center,
                          children: [
                            const Icon(Icons.share),
                            if (isPremium)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF7C3AED),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () {
                          if (isPremium) {
                            showDialog(
                              context: context,
                              builder: (context) => BackgroundSelectorDialog(
                                verse: fav.verse,
                                reference: fav.reference,
                              ),
                            );
                          } else {
                            share_plus.Share.share('"${fav.verse}"\n\n— ${fav.reference}',
                                subject: 'Versículo');
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          ref.read(favoritesProvider.notifier).removeFavorite(fav.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.removedFromFavorites)),
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
