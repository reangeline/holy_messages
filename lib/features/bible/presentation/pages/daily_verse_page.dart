import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holy_messages/features/bible/presentation/pages/verse_detail_page.dart';
import 'package:holy_messages/features/bible/presentation/widgets/header.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import 'package:uuid/uuid.dart';

import '../../domain/entities/favorite.dart';
import '../state/bible_providers.dart';
import '../state/daily_verse_controller.dart';
import '../state/favorites_controller.dart';
import '../widgets/daily_verse_card.dart';
import '../widgets/banner_ad_widget.dart';
import '../../../settings/state/premium_provider.dart';
import '../../../settings/state/in_app_purchase_provider.dart';
import '../../../settings/state/auth_provider.dart';
import '../../../settings/presentation/pages/social_login_page.dart';

class DailyVersePage extends ConsumerWidget {
  const DailyVersePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(appLanguageProvider);
    final daily = ref.watch(dailyVerseControllerProvider);
    final favoritesAsync = ref.watch(favoritesProvider);
    final isPremium = ref.watch(premiumProvider);
    final authNotifier = ref.watch(authNotifierProvider);
    final currentUser = authNotifier.getCurrentUser();

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
                    Text(
                      isPremium ? 'Premium Ativo ✨' : 'Versão Gratuita',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isPremium)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Desbloqueie Premium',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '✓ Sem Anúncios\n✓ Widgets Personalizados\n✓ Acesso Ilimitado\n✓ Experiência Pura',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            // Verificar se está logado
                            if (currentUser == null) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Cadastro Necessário'),
                                  content: const Text(
                                    'Para realizar uma compra, você precisa fazer o cadastro ou login em sua conta. Isso garante que suas compras sejam sincronizadas entre dispositivos.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context); // Fecha o menu
                                        
                                        // Navegar para login e esperar resultado
                                        final loginSuccess = await Navigator.of(context).push<bool>(
                                          MaterialPageRoute(
                                            builder: (context) => const SocialLoginPage(),
                                          ),
                                        );

                                        // Se login foi bem-sucedido, mostrar diálogo de compra
                                        if (loginSuccess == true && context.mounted) {
                                          await Future.delayed(const Duration(milliseconds: 500));
                                          ref.refresh(authNotifierProvider); // Atualizar estado de auth
                                          
                                          if (context.mounted) {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: const Text('🎉 Bem-vindo!'),
                                                content: const Text('Você está logado! Deseja comprar Premium agora?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context),
                                                    child: const Text('Depois'),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                      // Mostrar loading
                                                      showDialog(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (context) => const Dialog(
                                                          child: Padding(
                                                            padding: EdgeInsets.all(20),
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                CircularProgressIndicator(
                                                                  valueColor: AlwaysStoppedAnimation<Color>(
                                                                    Color(0xFFB45309),
                                                                  ),
                                                                ),
                                                                SizedBox(height: 16),
                                                                Text('Processando compra com Apple...'),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                      
                                                      // Fazer a compra
                                                      await ref.read(inAppPurchaseProvider.notifier).purchasePremium();
                                                      await Future.delayed(const Duration(milliseconds: 500));
                                                      await ref.read(premiumProvider.notifier).purchasePremium();
                                                      
                                                      if (context.mounted) {
                                                        Navigator.pop(context);
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          const SnackBar(
                                                            content: Text('🎉 Bem-vindo ao Premium!'),
                                                            backgroundColor: Color(0xFFB45309),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: const Color(0xFFB45309),
                                                    ),
                                                    child: const Text('Comprar Premium'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFB45309),
                                      ),
                                      child: const Text('Fazer Login'),
                                    ),
                                  ],
                                ),
                              );
                              return;
                            }

                            Navigator.pop(context);
                            // Mostrar loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Dialog(
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Color(0xFFB45309),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text('Processando compra com Apple...'),
                                    ],
                                  ),
                                ),
                              ),
                            );
                            
                            // Fazer a compra pela Apple
                            await ref.read(inAppPurchaseProvider.notifier).purchasePremium();
                            
                            // Depois que a Apple confirmar, atualizar o estado
                            await Future.delayed(const Duration(milliseconds: 500));
                            await ref.read(premiumProvider.notifier).purchasePremium();
                            
                            if (context.mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🎉 Bem-vindo ao Premium!'),
                                  backgroundColor:Color(0xFFB45309),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFCD34D).withOpacity(0.8),
                            foregroundColor:  Color(0xFFB45309),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            'Comprar - R\$ 9,90',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (isPremium)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Você é Premium! 🌟',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDCFA1F),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Obrigado por apoiar nosso ministério!\n\nVocê desbloqueou:\n✓ Sem anúncios\n✓ Widgets personalizados\n✓ Acesso ilimitado\n✓ Experiência pura',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ref.read(premiumProvider.notifier).removePremium();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Premium removido para teste'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade300,
                            foregroundColor: Colors.red.shade900,
                          ),
                          child: const Text('Resetar Premium (Teste)'),
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(thickness: 2),
              ListTile(
                leading: const Icon(Icons.info, color: Color(0xFFB45309)),
                title: const Text('Sobre'),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Sobre'),
                      content: const Text(
                        'Mensagens Sagradas\nVersão 1.0.0\n\nSua Bíblia diária com mensagens inspiradoras.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Fechar'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (currentUser == null)
                ListTile(
                  leading: const Icon(Icons.login, color:Color(0xFFB45309)),
                  title: const Text('Login'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SocialLoginPage(),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      body: daily.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erro: $e')),
        data: (verse) {
          if (verse == null) return const Center(child: Text('Sem dados.'));
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
                        const Header(
                          title: 'Versículo do Dia',
                          subtitle: 'Inspiração diária para você',
                        ),
                        const SizedBox(height: 16),
                       DailyVerseCard(
                          verse: verse.text(lang),
                          reference: verse.keyWithBookName,
                          isFavorited: isFavorited,
                          isPremium: isPremium,
                          isLoggedIn: currentUser != null,
                          onTap: () {
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
                                const SnackBar(content: Text('Removido dos favoritos')),
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
                                  const SnackBar(content: Text('✅ Adicionado aos favoritos')),
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
                          onShare: () {
                            share_plus.Share.share(
                              '${verse.text(lang)}\n\n— ${verse.keyWithBookName}',
                              subject: 'Versículo do Dia',
                            );
                          },
                          onRefresh: () async {
                            await ref.read(dailyVerseControllerProvider.notifier).refresh();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const BannerAdWidget(),
            ],
          );
        },
      ),
    );
  }
}