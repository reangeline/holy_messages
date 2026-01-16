import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../settings/state/locale_provider.dart';

class LanguageSelectionPage extends ConsumerWidget {
  const LanguageSelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);
    
    // Fallback se localização não estiver disponível
    if (l10n == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      color: const Color(0xFFB45309),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.selectLanguage,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB45309),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Language Options
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    _LanguageOption(
                      flagEmoji: '🇧🇷',
                      languageName: l10n.portuguese,
                      languageCode: 'pt',
                      isSelected: currentLocale.languageCode == 'pt',
                      onTap: () async {
                        await ref.read(localeProvider.notifier).setLocale(
                              const Locale('pt'),
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.languageChanged),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _LanguageOption(
                      flagEmoji: '🇺🇸',
                      languageName: l10n.english,
                      languageCode: 'en',
                      isSelected: currentLocale.languageCode == 'en',
                      onTap: () async {
                        await ref.read(localeProvider.notifier).setLocale(
                              const Locale('en'),
                            );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(l10n.languageChanged),
                              backgroundColor: Colors.green,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flagEmoji;
  final String languageName;
  final String languageCode;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flagEmoji,
    required this.languageName,
    required this.languageCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFDCFA1F).withOpacity(0.3)
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFDCFA1F)
                : const Color(0xFFFCD34D).withOpacity(0.3),
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFFDCFA1F).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
          ],
        ),
        child: Row(
          children: [
            // Flag Emoji
            Text(
              flagEmoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(width: 20),
            // Language Name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    languageName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xFFB45309)
                          : const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    languageCode.toUpperCase(),
                    style: TextStyle(
                      fontSize: 14,
                      color: isSelected
                          ? const Color(0xFFB45309).withOpacity(0.7)
                          : const Color(0xFF64748B).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            // Check Icon
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFDCFA1F),
                size: 32,
              ),
          ],
        ),
      ),
    );
  }
}
