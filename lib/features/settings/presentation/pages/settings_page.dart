import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../state/premium_provider.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'notification_settings_page.dart';
import 'language_selection_page.dart';
import 'social_login_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 32),
                Text(
                  l10n.settingsTitle,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 32),
                // Premium Section (Apple In-App Purchase)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isPremium
                        ? const Color(0xFFDCFA1F).withOpacity(0.3)
                        : const Color(0xFFFCD34D).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isPremium
                          ? const Color(0xFFDCFA1F)
                          : const Color(0xFFFCD34D),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isPremium ? Icons.verified : Icons.card_giftcard,
                            color: const Color(0xFFB45309),
                            size: 32,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isPremium ? l10n.premiumVersion : l10n.freeVersion,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isPremium
                                      ? l10n.thankYou
                                      : l10n.noAdsForever,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (!isPremium) ...[
                        _PremiumBenefit(
                          icon: Icons.remove_circle,
                          title: l10n.noAds,
                          subtitle: l10n.premiumExperience,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;
                              if (user == null) {
                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Login necessário'),
                                      content: const Text('Você precisa estar logado para comprar o Premium e restaurar em outros dispositivos.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => const SocialLoginPage(),
                                              ),
                                            );
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return;
                              }
                              try {
                                await ref.read(premiumProvider.notifier).purchasePremium();
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.shopping_cart),
                            label: Text(l10n.buyPremiumApple),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB45309), // Mesma cor do texto Versão Gratuita
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              if (context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Login necessário'),
                                    content: const Text('Você precisa estar logado para restaurar sua compra em outros dispositivos.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => const SocialLoginPage(),
                                            ),
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return;
                            }
                            await ref.read(premiumProvider.notifier).restorePurchase();
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(l10n.purchasesRestored),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }
                          },
                          child: Text(l10n.restorePurchases),
                        ),
                      ] else ...[
                        _PremiumBenefit(
                          icon: Icons.check_circle,
                          title: l10n.premiumActive,
                          subtitle: l10n.premiumUnlocked,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Sobre Section
                Text(
                  l10n.about,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _SettingsTile(
                  icon: Icons.notifications,
                  title: l10n.notifications,
                  subtitle: l10n.notificationsSubtitle,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationSettingsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.language,
                  title: l10n.language,
                  subtitle: l10n.languageSubtitle,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LanguageSelectionPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.info,
                  title: l10n.appVersion,
                  subtitle: '1.0.1',
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.favorite,
                  title: l10n.aboutUs,
                  subtitle: l10n.aboutUsSubtitle,
                ),
                const SizedBox(height: 32),
                // Conta Section
                Text(
                  l10n.account,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                if (FirebaseAuth.instance.currentUser != null)
                  _SettingsTile(
                    icon: Icons.logout,
                    title: l10n.logout,
                    subtitle: l10n.logoutSubtitle,
                    onTap: () => _showLogoutDialog(context),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPurchaseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Comprar Premium'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Desbloqueie:'),
            SizedBox(height: 12),
            _PremiumBenefit(
              icon: Icons.remove_circle,
              title: 'Sem Anúncios',
              subtitle: 'Leia em paz',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // Remover premium localmente ao fazer logout
              // ignore: use_build_context_synchronously
              final container = ProviderScope.containerOf(context, listen: false);
              await container.read(premiumProvider.notifier).removePremium();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.loggedOut),
                  backgroundColor: Color(0xFFB45309),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB45309),
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.logoutButton),
          ),
        ],
      ),
    );
  }
}

class _PremiumBenefit extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PremiumBenefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFFB45309), // Mesma cor do texto 'Versão Gratuita'
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFCD34D).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFB45309),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFB45309),
              ),
          ],
        ),
      ),
    );
  }
}
