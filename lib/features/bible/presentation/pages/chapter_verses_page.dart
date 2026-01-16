import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/ads/ad_units.dart';
import '../state/bible_providers.dart';
import '../state/font_size_provider.dart';
import 'verse_detail_page.dart';
import '../../../settings/state/premium_provider.dart';
// Premium gating for Bible removed; no settings CTA here

// Provedor global para contar cliques de volta
final backClickCountProvider = StateProvider<int>((ref) => 0);

class ChapterVersesPage extends ConsumerStatefulWidget {
  final String bookName;
  final int chapter;

  const ChapterVersesPage({
    super.key,
    required this.bookName,
    required this.chapter,
  });

  @override
  ConsumerState<ChapterVersesPage> createState() => _ChapterVersesPageState();
}

class _ChapterVersesPageState extends ConsumerState<ChapterVersesPage> {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  void _loadInterstitialAd() {
    // Verificar se é Premium - se for, não mostrar anúncio
    final isPremium = ref.read(premiumProvider);
    if (isPremium) {
      _navigateToNextChapter();
      return;
    }
    
    // Mostrar dialog de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFFB45309).withOpacity(0.8),
              ),
            ),
          ),
        );
      },
    );
    
    final id = AdUnits.interstitialId();
    if (kReleaseMode && id.isEmpty) {
      _navigateToNextChapter();
      return;
    }
    InterstitialAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // Fechar o spinner de carregamento
          if (mounted) {
            Navigator.pop(context);
          }
          _interstitialAd = ad;
          _isAdLoaded = true;
          _showInterstitialAd();
        },
        onAdFailedToLoad: (error) {
          // Fechar o spinner de carregamento
          if (mounted) {
            Navigator.pop(context);
          }
          _isAdLoaded = false;
          _navigateToNextChapter();
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          _navigateToNextChapter();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          _navigateToNextChapter();
        },
      );
      _interstitialAd!.show();
    } else {
      _navigateToNextChapter();
    }
  }

  void _navigateToNextChapter() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChapterVersesPage(
          bookName: widget.bookName,
          chapter: widget.chapter + 1,
        ),
      ),
    );
  }

  void _loadInterstitialAdForBack() {
    // Verificar se é Premium - se for, não mostrar anúncio
    final isPremium = ref.read(premiumProvider);
    if (isPremium) {
      Navigator.pop(context);
      return;
    }
    
    // Incrementar o contador global
    ref.read(backClickCountProvider.notifier).state++;
    int clickCount = ref.read(backClickCountProvider);
    
    // Mostrar ad apenas a cada 2 cliques
    if (clickCount % 2 != 0) {
      Navigator.pop(context);
      return;
    }
    
    // Mostrar dialog de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFFB45309).withOpacity(0.8),
              ),
            ),
          ),
        );
      },
    );
    
    final id = AdUnits.interstitialId();
    if (kReleaseMode && id.isEmpty) {
      Navigator.pop(context);
      Navigator.pop(context);
      return;
    }
    InterstitialAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // Fechar o spinner de carregamento
          if (mounted) {
            Navigator.pop(context);
          }
          _interstitialAd = ad;
          _isAdLoaded = true;
          _showInterstitialAdForBack();
        },
        onAdFailedToLoad: (error) {
          // Fechar o spinner de carregamento
          if (mounted) {
            Navigator.pop(context);
          }
          _isAdLoaded = false;
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showInterstitialAdForBack() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          Navigator.pop(context);
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          Navigator.pop(context);
        },
      );
      _interstitialAd!.show();
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final versesAsync =
      ref.watch(getVersesByChapterProvider((widget.bookName, widget.chapter)));
    // Premium/online gating removed: verses always accessible
    final fontSize = ref.watch(fontSizeProvider);

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
        child: versesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Erro: $e')),
          data: (verseModels) {
            return CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  expandedHeight: 140,
                  pinned: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: const Color(0xFFB45309),
                        onPressed: () => _loadInterstitialAdForBack(),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      color: const Color(0xFFB45309),
                      onPressed: () async {
                        await ref.read(fontSizeProvider.notifier).increaseFontSize();
                      },
                      tooltip: 'Aumentar fonte',
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      color: const Color(0xFFB45309),
                      onPressed: () async {
                        await ref.read(fontSizeProvider.notifier).decreaseFontSize();
                      },
                      tooltip: 'Diminuir fonte',
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bookName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB45309),
                          ),
                        ),
                        Text(
                          'Capítulo ${widget.chapter}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
                  ),
                ),
                // Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...verseModels.asMap().entries.map((entry) {
                          final index = entry.key;
                          final verseModel = entry.value;
                          final reference =
                              '${widget.bookName} ${verseModel.chapter}:${verseModel.verse}';
                          final isLast = index == verseModels.length - 1;

                          // Interactions are always allowed (no premium/online gating)
                          return Padding(
                            padding: EdgeInsets.only(bottom: isLast ? 32 : 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerseDetailPage(
                                      verseText: verseModel.verseText,
                                      reference: reference,
                                      bookName: widget.bookName,
                                      chapter: widget.chapter,
                                    ),
                                  ),
                                );
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    // Número do versículo
                                    TextSpan(
                                      text: '${verseModel.verse}',
                                      style: TextStyle(
                                        fontSize: fontSize * 0.75,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFFB45309),
                                        height: 1.8,
                                      ),
                                    ),
                                    const TextSpan(text: '  '),
                                    // Texto do versículo
                                    TextSpan(
                                      text: verseModel.verseText,
                                      style: TextStyle(
                                        fontSize: fontSize,
                                        color: const Color(0xFF1E293B),
                                        height: 1.8,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                        // Final spacing
                        const SizedBox(height: 32),
                        Center(
                          child: Text(
                            '✦ Fim do Capítulo ✦',
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFFB45309).withOpacity(0.5),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Next chapter button (uses provider so offline/non-premium checks apply)
                        Builder(builder: (context) {
                          final chaptersAsync = ref.watch(getChaptersByBookProvider(widget.bookName));
                          return chaptersAsync.when(
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                            data: (chapters) {
                              if (chapters.isEmpty) return const SizedBox.shrink();
                              final hasNextChapter = widget.chapter < chapters.last;
                              if (!hasNextChapter) return const SizedBox.shrink();

                              return Center(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    _loadInterstitialAd();
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                  label: const Text('Próximo Capítulo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFCD34D),
                                    foregroundColor: const Color(0xFFB45309),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

