import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../bible/presentation/state/bible_providers.dart';
import '../../state/liturgy_provider.dart';
import '../../../bible/presentation/pages/chapter_verses_page.dart';

class LiturgyPage extends ConsumerStatefulWidget {
  const LiturgyPage({super.key});

  @override
  ConsumerState<LiturgyPage> createState() => _LiturgyPageState();
}

class _LiturgyPageState extends ConsumerState<LiturgyPage> {
  bool _isLocaleInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('pt_BR', null);
    await initializeDateFormatting('en_US', null);
    if (mounted) {
      setState(() {
        _isLocaleInitialized = true;
      });
    }
  }

  Color _getColorForLiturgy(String color) {
    switch (color.toLowerCase()) {
      case 'branco':
        return Colors.white;
      case 'verde':
        return Colors.green;
      case 'roxo':
      case 'violeta':
        return Colors.purple;
      case 'vermelho':
        return Colors.red;
      case 'rosa':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final liturgiesAsync = ref.watch(liturgyProvider);

    final strings = ref.watch(appStringsProvider);
    
    if (!_isLocaleInitialized) {
      return Scaffold(
        appBar: AppBar(
          title: Text(strings.dailyLiturgy),
          backgroundColor: const Color(0xFFB45309),
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB45309)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.dailyLiturgy),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFFB45309),
      ),
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
        child: liturgiesAsync.when(
        data: (liturgies) {
          if (liturgies.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma liturgia disponível',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF64748B),
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: liturgies.length,
            itemBuilder: (context, index) {
              final liturgy = liturgies[index];
              final lang = ref.watch(appLanguageProvider);
              final locale = lang.code == 'en' ? 'en_US' : 'pt_BR';
              final dateFormat = DateFormat('EEEE, d MMMM yyyy', locale);
              final isToday = DateTime.now().difference(liturgy.dateTime).inDays == 0;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: isToday ? 4 : 2,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isToday
                      ? const BorderSide(color: Color(0xFFFCD34D), width: 3)
                      : BorderSide.none,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header com data e cor litúrgica
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFFFEF3C7),
                            Color(0xFFFCD34D),
                          ],
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dateFormat.format(liturgy.dateTime),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                                if (isToday)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFCD34D),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: const Text(
                                      'HOJE',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFB45309),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getColorForLiturgy(liturgy.color),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                liturgy.color,
                                style: TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                  color: liturgy.color.toLowerCase() == 'branco'
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tempo Litúrgico e Celebração
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            liturgy.season,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            liturgy.celebration,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 12),

                          // Leituras
                          const Text(
                            'Leituras do dia:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB45309),
                            ),
                          ),
                          const SizedBox(height: 12),

                          ...liturgy.readings.map((reading) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () {
                                  // Navegar para o capítulo da Bíblia
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChapterVersesPage(
                                        bookName: reading.start.bookName,
                                        chapter: reading.start.chapter,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFEF3C7),
                                        Color(0xFFFED7AA),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFFCD34D).withOpacity(0.5)),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFCD34D),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          reading.type,
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFB45309),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              reading.start.bookName,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              reading.ref,
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey.shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16,
                                        color: Color(0xFFB45309),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB45309)),
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Color(0xFFB45309)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Erro ao carregar liturgias: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(liturgyProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFCD34D),
                  foregroundColor: const Color(0xFFB45309),
                ),
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
