import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/ads/ad_units.dart';

import 'daily_verse_page.dart';
import 'favorites_page.dart';
import 'bible_browser_page.dart';
import 'verse_detail_page.dart';
import '../state/bible_providers.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../../core/utils/connectivity_provider.dart';
import '../../../../core/services/notification_service.dart';
import '../state/daily_verse_controller.dart';
import '../widgets/banner_ad_widget.dart';
import '../../../settings/state/premium_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _idx = 0;
  InterstitialAd? _refreshAd;

  @override
  void initState() {
    super.initState();
    _setupNotificationCallback();
    // Trigger an initial connectivity check so providers react accordingly
    try {
      ref.read(connectivityProvider.notifier).check();
    } catch (_) {}
  }

  void _setupNotificationCallback() {
    // Configurar callback de navegação de notificação
    onNotificationTapped = (data) {
      print('===== 🎯 CALLBACK DE NOTIFICAÇÃO =====');
      print('Data recebida: $data');
      print('Type: ${data['type']}');
      print('Book: ${data['book']}');
      print('Chapter: ${data['chapter']}');
      print('Verse: ${data['verse']}');
      print('Text: ${data['text']}');
      print('======================================');
      
      if (data['type'] == 'verse' && 
          data['book'] != null && 
          data['chapter'] != null &&
          data['verse'] != null) {
        print('📖 Navegando para detalhes do versículo...');
        
        final bookName = _getBookName(data['book'] as int);
        final chapter = data['chapter'] as int;
        final verse = data['verse'] as int;
        final verseText = data['text'] as String? ?? '';
        final reference = '$bookName $chapter:$verse';
        
        print('🔹 BookName: $bookName');
        print('🔹 Chapter: $chapter');
        print('🔹 Verse: $verse');
        print('🔹 VerseText: $verseText');
        print('🔹 Reference: $reference');
        
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VerseDetailPage(
              verseText: verseText,
              reference: reference,
              bookName: bookName,
              chapter: chapter,
            ),
          ),
        );
        print('✅ Navegação iniciada para $reference');
      } else {
        print('⚠️ Dados de notificação inválidos ou incompletos');
      }
    };
  }

  String _getBookName(int bookNum) {
    final bookNames = [
      'Gênesis', 'Êxodo', 'Levítico', 'Números', 'Deuteronômio',
      'Josué', 'Juízes', 'Rute', '1 Samuel', '2 Samuel',
      '1 Reis', '2 Reis', '1 Crônicas', '2 Crônicas', 'Esdras',
      'Neemias', 'Ester', 'Jó', 'Salmos', 'Provérbios',
      'Eclesiastes', 'Cântico dos Cânticos', 'Isaías', 'Jeremias', 'Lamentações',
      'Ezequiel', 'Daniel', 'Oséias', 'Joel', 'Amós',
      'Obadias', 'Jonas', 'Miquéias', 'Naum', 'Habacuque',
      'Sofonias', 'Ageu', 'Zacarias', 'Malaquias',
      'Mateus', 'Marcos', 'Lucas', 'João', 'Atos',
      'Romanos', '1 Coríntios', '2 Coríntios', 'Gálatas', 'Efésios',
      'Filipenses', 'Colossenses', '1 Tessalonicenses', '2 Tessalonicenses', '1 Timóteo',
      '2 Timóteo', 'Tito', 'Filemon', 'Hebreus', 'Tiago',
      '1 Pedro', '2 Pedro', '1 João', '2 João', '3 João',
      'Judas', 'Apocalipse'
    ];
    return bookNum > 0 && bookNum <= bookNames.length 
        ? bookNames[bookNum - 1] 
        : 'Desconhecido';
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    
    return Scaffold(
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        displacement: 28,
        edgeOffset: 0,
        onRefresh: () async {
          await _refreshWithInterstitial();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: IndexedStack(index: _idx, children: const [
              DailyVersePage(),
              FavoritesPage(),
              BibleBrowserPage(),
              SettingsPage(),
            ]),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Banner por página (recria ao trocar de aba). Não mostrar na aba de Configurações (índice 3)
            if (_idx != 3)
              BannerAdWidget(key: ValueKey('banner-tab-$_idx')),
            BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _idx,
              onTap: (v) => setState(() => _idx = v),
              items: [
                BottomNavigationBarItem(icon: const Icon(Icons.home), label: strings.home),
                BottomNavigationBarItem(icon: const Icon(Icons.favorite), label: strings.favorites),
                BottomNavigationBarItem(icon: const Icon(Icons.menu_book), label: strings.bible),
                BottomNavigationBarItem(icon: const Icon(Icons.settings), label: strings.settings),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doRefreshActions() async {
    // Recheck connectivity and refresh main providers
    try {
      await ref.read(connectivityProvider.notifier).check();
    } catch (_) {}
    // Atualizar mensagem do dia também
    try {
      await ref.read(dailyVerseControllerProvider.notifier).refresh();
      // Força reexecução do provider para garantir atualização visual
      ref.invalidate(dailyVerseControllerProvider);
    } catch (_) {}
    ref.invalidate(biblicalMessagesProvider);
    ref.invalidate(getAllBooksProvider);
  }

  Future<void> _refreshWithInterstitial() async {
    final isPremium = ref.read(premiumProvider);
    if (isPremium) {
      await _doRefreshActions();
      return;
    }

    final completer = Completer<void>();

    // Spinner enquanto carrega o anúncio
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFFB45309).withOpacity(0.8),
              ),
            ),
          ),
        ),
      );
    }

    final id = AdUnits.interstitialId();
    if (kReleaseMode && id.isEmpty) {
      // no real id configured in release, skip ad
      await _doRefreshActions();
      return;
    }
    InterstitialAd.load(
      adUnitId: id,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          if (mounted) Navigator.pop(context);
          _refreshAd = ad;
          _refreshAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _refreshAd = null;
              _doRefreshActions().whenComplete(() => completer.complete());
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _refreshAd = null;
              _doRefreshActions().whenComplete(() => completer.complete());
            },
          );
          _refreshAd!.show();
        },
        onAdFailedToLoad: (error) {
          if (mounted) Navigator.pop(context);
          _refreshAd?.dispose();
          _refreshAd = null;
          _doRefreshActions().whenComplete(() => completer.complete());
        },
      ),
    );

    return completer.future;
  }
}
