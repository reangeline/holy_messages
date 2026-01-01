import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holy_messages/core/utils/custom_snackbar.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:uuid/uuid.dart';

import '../../domain/entities/favorite.dart';
import '../state/favorites_controller.dart';
import '../widgets/banner_ad_widget.dart';
import 'chapter_verses_page.dart';
import '../../../settings/state/premium_provider.dart';
import '../../../settings/state/auth_provider.dart';


class VerseDetailPage extends ConsumerWidget {
  final String verseText;
  final String reference;
  final String? bookName;
  final int? chapter;

  const VerseDetailPage({
    super.key,
    required this.verseText,
    required this.reference,
    this.bookName,
    this.chapter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);
    final isPremium = ref.watch(premiumProvider);
    final authNotifier = ref.watch(authNotifierProvider);
    final currentUser = authNotifier.getCurrentUser();
    
    final isFavorited = favoritesAsync.maybeWhen(
      data: (list) => list.whereType<Favorite>().any((f) => f.messageId == reference),
      orElse: () => false,
    );
    final existingFavorite = favoritesAsync.maybeWhen(
      data: (list) {
        try {
          return list.firstWhere((f) => (f as Favorite?)?.messageId == reference);
        } catch (_) {
          return null;
        }
      },
      orElse: () => null,
    );

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFEF3C7), // amber-50
              Colors.white,
              Color(0xFFFED7AA), // orange-50
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16, top: 64),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),

                            child: const SizedBox(
                              width: 56,
                              height: 56,
                             
                              child: Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: Color(0xFF78350F),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Main content card
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        fit: StackFit.loose,
                        children: [
                          // Decorative elements
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    const Color(0xFFFCD34D).withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: 128,
                              height: 128,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    const Color(0xFFFED7AA).withOpacity(0.2),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                          ),
                          // Cross symbol
                          const Positioned(
                            top: 24,
                            right: 24,
                            child: Opacity(
                              opacity: 0.1,
                              child: Icon(
                                Icons.add,
                                size: 60,
                                color: Color(0xFF78350F),
                              ),
                            ),
                          ),
                          // Main content
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Badge
                                const SizedBox(height: 32),
                                // Verse text
                                Text(
                                  '"$verseText"',
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Georgia',
                                    fontStyle: FontStyle.italic,
                                    color: Color(0xFF1E293B),
                                    height: 1.8,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: null,
                                ),
                                const SizedBox(height: 32),
                                // Reference
                                Text(
                                  '— $reference',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                // Action buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Favorite button
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: currentUser == null ? () {
                                          showTopSnackBar(
                                            context,
                                            message: 'Faça login para adicionar favoritos',
                                            backgroundColor: const Color(0xFFFF9800),
                                          );
                                        } : () async {
                                          final favNotifier = ref.read(favoritesProvider.notifier);
                                          if (isFavorited && existingFavorite != null) {
                                            favNotifier.removeFavorite(existingFavorite.id);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                content: Text('Removido dos favoritos'),
                                              ),
                                            );
                                          } else {
                                            final newFav = Favorite(
                                              id: const Uuid().v4(),
                                              messageId: reference,
                                              verse: verseText,
                                              reference: reference,
                                              savedAt: DateTime.now().toIso8601String(),
                                            );
                                            final success = await favNotifier.addFavorite(newFav, isPremium: isPremium);
                                            if (success) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('✅ Adicionado aos favoritos'),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('❌ Limite de 5 favoritos atingido. Upgrade para Premium!'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(28),
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: currentUser == null
                                                ? const Color(0xFFE2E8F0)
                                                : isFavorited
                                                    ? const Color(0xFFFEE2E2)
                                                    : const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(28),
                                          ),
                                          child: Icon(
                                            isFavorited ? Icons.favorite : Icons.favorite_border,
                                            size: 24,
                                            color: currentUser == null
                                                ? const Color(0xFFCBD5E1)
                                                : isFavorited
                                                    ? const Color(0xFFEF4444)
                                                    : const Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Share button
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          share_plus.Share.share(
                                            '$verseText\n\n— $reference',
                                            subject: 'Versículo',
                                          );
                                        },
                                        borderRadius: BorderRadius.circular(28),
                                        child: Container(
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF1F5F9),
                                            borderRadius: BorderRadius.circular(28),
                                          ),
                                          child: const Icon(
                                            Icons.share,
                                            size: 24,
                                            color: Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // View chapter button (se bookName e chapter estiverem disponíveis)
                                    if (bookName != null && chapter != null) ...[
                                      const SizedBox(width: 16),
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ChapterVersesPage(
                                                  bookName: bookName!,
                                                  chapter: chapter!,
                                                ),
                                              ),
                                            );
                                          },
                                          borderRadius: BorderRadius.circular(28),
                                          child: Container(
                                            width: 56,
                                            height: 56,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFCD34D)
                                                  .withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(28),
                                            ),
                                            child: const Icon(
                                              Icons.menu_book,
                                              size: 24,
                                              color: Color(0xFFB45309),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
