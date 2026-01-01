import 'package:flutter/material.dart';
import '../../domain/entities/app_language.dart';
import '../../domain/entities/verse_entity.dart';

class VerseCard extends StatelessWidget {
  final VerseEntity verse;
  final AppLanguage language;

  const VerseCard({
    super.key,
    required this.verse,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final text = verse.text(language);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(
              verse.key, // depois formatamos "João 3:16 / John 3:16"
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}