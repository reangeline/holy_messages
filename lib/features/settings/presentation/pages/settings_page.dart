import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/premium_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(premiumProvider);

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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Configurações',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 32),
                // Premium Section
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
                                  isPremium ? 'Versão Premium' : 'Versão Gratuita',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isPremium
                                      ? 'Você tem acesso a todos os recursos'
                                      : 'Desbloqueie todos os recursos',
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
                          title: 'Sem Anúncios',
                          subtitle: 'Leia sem interrupções',
                        ),
                        const SizedBox(height: 12),
                        _PremiumBenefit(
                          icon: Icons.widgets,
                          title: 'Widgets Personalizados',
                          subtitle: 'Adicione à sua tela inicial',
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showPurchaseDialog(context, ref);
                            },
                            icon: const Icon(Icons.shopping_cart),
                            label: const Text('Comprar Premium - R\$ 9,90'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFDCFA1F),
                              foregroundColor: const Color(0xFFB45309),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        _PremiumBenefit(
                          icon: Icons.check_circle,
                          title: 'Sem Anúncios',
                          subtitle: 'Ativado',
                        ),
                        const SizedBox(height: 12),
                        _PremiumBenefit(
                          icon: Icons.check_circle,
                          title: 'Widgets Personalizados',
                          subtitle: 'Disponível',
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // About Section
                Text(
                  'Sobre',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFFB45309),
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                _SettingsTile(
                  icon: Icons.info,
                  title: 'Versão do App',
                  subtitle: '1.0.0',
                ),
                const SizedBox(height: 12),
                _SettingsTile(
                  icon: Icons.favorite,
                  title: 'Sobre Nós',
                  subtitle: 'Mensagens diárias e Bíblia completa',
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
            SizedBox(height: 12),
            _PremiumBenefit(
              icon: Icons.widgets,
              title: 'Widgets',
              subtitle: 'Personalize sua tela',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(premiumProvider.notifier).purchasePremium();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🎉 Bem-vindo à versão Premium!'),
                  backgroundColor: Color(0xFFDCFA1F),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDCFA1F),
              foregroundColor: const Color(0xFFB45309),
            ),
            child: const Text('Comprar - R\$ 9,90'),
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
          color: const Color(0xFFDCFA1F),
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

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        ],
      ),
    );
  }
}
