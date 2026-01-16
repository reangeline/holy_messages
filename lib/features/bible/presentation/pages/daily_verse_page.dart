import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:holy_messages/features/bible/presentation/pages/verse_detail_page.dart';
import 'package:holy_messages/features/bible/presentation/widgets/header.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:uuid/uuid.dart';

import '../../domain/entities/favorite.dart';
import '../state/bible_providers.dart';
import '../state/daily_verse_controller.dart';
import '../state/favorites_controller.dart';
import '../widgets/daily_verse_card.dart';
// Global banner is shown in HomePage above bottom navigation bar
import '../widgets/background_selector_dialog.dart';
import '../../services/verse_image_service.dart';
import '../../../settings/state/premium_provider.dart';
import '../../../settings/state/auth_provider.dart';
import '../../../settings/presentation/pages/social_login_page.dart';
import '../../../liturgy/presentation/pages/liturgy_page.dart';
import '../../../../core/utils/connectivity_helper.dart';

class DailyVersePage extends ConsumerWidget {
  const DailyVersePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appLanguageProvider);
    final strings = ref.watch(appStringsProvider);
    final daily = ref.watch(dailyVerseControllerProvider);
    final favoritesAsync = ref.watch(favoritesProvider);
    final isPremium = ref.watch(premiumProvider);
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFFB45309), size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFEF3C7),
                Colors.white,
                Color(0xFFFED7AA),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color.fromARGB(255, 242, 242, 241), Color(0xFFFCD34D)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isPremium ? Icons.verified : Icons.card_giftcard,
                      size: 48,
                      color: const Color(0xFFB45309),
                    ),
                    const SizedBox(height: 12),
                    Consumer(
                      builder: (context, ref, child) {
                        final strings = ref.watch(appStringsProvider);
                        return Text(
                          isPremium ? strings.premiumActive : strings.freeVersion,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // Premium promo removed from Drawer as requested

              if (isPremium)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer(
                        builder: (context, ref, child) {
                          final strings = ref.watch(appStringsProvider);
                          return Text(
                            '${strings.premiumUnlocked} 🌟',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:  Color(0xFFB45309),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),

              // divider removed as requested
              ListTile(
                leading: const Icon(Icons.calendar_today, color: Color(0xFFB45309)),
                title: Consumer(
                  builder: (context, ref, child) {
                    final strings = ref.watch(appStringsProvider);
                    return Text(strings.dailyLiturgy);
                  },
                ),
                subtitle: Consumer(
                  builder: (context, ref, child) {
                    final strings = ref.watch(appStringsProvider);
                    return Text(strings.dailyReadings);
                  },
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LiturgyPage(),
                    ),
                  );
                },
              ),
              const Divider(thickness: 2),
              ListTile(
                leading: const Icon(Icons.info, color: Color(0xFFB45309)),
                title: Consumer(
                  builder: (context, ref, child) {
                    final strings = ref.watch(appStringsProvider);
                    return Text(strings.about);
                  },
                ),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (dialogContext) => Consumer(
                      builder: (context, ref, child) {
                        final strings = ref.watch(appStringsProvider);
                        return AlertDialog(
                          title: Text(strings.about),
                          content: Text(
                            '${strings.holyMessages}\n${strings.appVersion}\n\n${strings.dailyBibleDescription}',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: Text(strings.close),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),

              if (currentUser == null)
                ListTile(
                  leading: const Icon(Icons.login, color:Color(0xFFB45309)),
                  title: Consumer(
                    builder: (context, ref, child) {
                      final strings = ref.watch(appStringsProvider);
                      return Text(strings.login);
                    },
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SocialLoginPage(),
                      ),
                    );
                  },
                ),

              if (currentUser != null) ...[
                ListTile(
                  leading: const Icon(Icons.account_circle, color: Color(0xFFB45309)),
                  title: Consumer(
                    builder: (context, ref, child) {
                      final strings = ref.watch(appStringsProvider);
                      return Text(strings.account);
                    },
                  ),
                  subtitle: Text(currentUser.email ?? currentUser.uid,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: Consumer(
                    builder: (context, ref, child) {
                      final strings = ref.watch(appStringsProvider);
                      return Text(strings.exit);
                    },
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (dialogContext) => Consumer(
                        builder: (context, ref, child) {
                          final strings = ref.watch(appStringsProvider);
                          return AlertDialog(
                            title: Text(strings.logoutConfirm),
                            content: Text(strings.logoutMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: Text(strings.cancel),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await FirebaseAuth.instance.signOut();
                                  ref.invalidate(authNotifierProvider);
                                  if (context.mounted) {
                                    Navigator.pop(dialogContext);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Consumer(
                                          builder: (context, ref, child) {
                                            final strings = ref.watch(appStringsProvider);
                                            return Text(strings.logoutSuccess);
                                          },
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: Text(strings.exit),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
      ),
      body: daily.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Consumer(
          builder: (context, ref, child) {
            final strings = ref.watch(appStringsProvider);
            return Text(strings.error(e.toString()));
          },
        )),
        data: (verse) {
          if (verse == null) return Center(child: Consumer(
            builder: (context, ref, child) {
              final strings = ref.watch(appStringsProvider);
              return Text(strings.noData);
            },
          ));
          final isFavorited = favoritesAsync.maybeWhen(
            data: (list) => list.whereType<Favorite>().any((f) => f.messageId == verse.key),
            orElse: () => false,
          );
          final existingFavorite = favoritesAsync.maybeWhen(
            data: (list) {
              try {
                return list.firstWhere((f) => (f as Favorite?)?.messageId == verse.key);
              } catch (_) {
                return null;
              }
            },
            orElse: () => null,
          );

          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Header(
                          title: strings.verseOfTheDay,
                          subtitle: strings.dailyInspiration,
                        ),
                        const SizedBox(height: 16),
                       DailyVerseCard(
                          verse: verse.text(lang),
                          reference: verse.keyWithBookName,
                          isFavorited: isFavorited,
                          isPremium: isPremium,
                          isLoggedIn: currentUser != null,
                          onTap: () async {
                            final online = await isOnlineNow().catchError((_) => false);
                            if (!isPremium && !online) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Requer conexão ou Premium para ver detalhes')),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerseDetailPage(
                                  verseText: verse.text(lang),
                                  reference: verse.keyWithBookName,
                                  bookName: verse.bookName,
                                  chapter: verse.chapter,
                                ),
                              ),
                            );
                          },
                          onFavorite: () async {
                            final favNotifier = ref.read(favoritesProvider.notifier);
                            if (isFavorited && existingFavorite != null) {
                              favNotifier.removeFavorite(existingFavorite.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(strings.removedFromFavoritesSingle)),
                              );
                            } else {
                              final newFav = Favorite(
                                id: const Uuid().v4(),
                                messageId: verse.key,
                                verse: verse.text(lang),
                                reference: verse.key,
                                savedAt: DateTime.now().toIso8601String(),
                              );
                              final success = await favNotifier.addFavorite(newFav, isPremium: isPremium);
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(strings.addedToFavoritesSingle)),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(strings.favoriteLimitReached),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                          onShare: () async {
                            if (isPremium) {
                              // Premium: Show background selector
                              final selectedBackground = await showDialog<String>(
                                context: context,
                                builder: (context) => BackgroundSelectorDialog(
                                  verse: verse.text(lang),
                                  reference: verse.keyWithBookName,
                                ),
                              );
                              
                              if (selectedBackground != null && context.mounted) {
                                try {
                                  await VerseImageService.shareVerseAsImage(
                                    verse: verse.text(lang),
                                    reference: verse.keyWithBookName,
                                    context: context,
                                    backgroundAsset: selectedBackground,
                                  );
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(strings.shareError(e.toString()))),
                                    );
                                  }
                                }
                              }
                            } else {
                              // Free: Share as text
                              share_plus.Share.share(
                                '${verse.text(lang)}\n\n— ${verse.keyWithBookName}',
                                subject: strings.verseOfDayImage,
                              );
                            }
                          },
                          onRefresh: () async {
                            final online = await isOnlineNow().catchError((_) => false);
                            if (!isPremium && !online) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Requer conexão ou Premium para atualizar a mensagem do dia')),
                              );
                              return;
                            }
                            await ref.read(dailyVerseControllerProvider.notifier).refresh();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Banner moved to HomePage bottomNavigationBar for consistent placement
            ],
          );
        },
      ),
    );
  }
}