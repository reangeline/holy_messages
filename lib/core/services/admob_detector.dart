import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdMobDetector {
  static const _prefsKey = 'admob_test_device_ids';

  /// Tenta detectar o device ID do AdMob carregando um BannerAd e
  /// analisando a mensagem de erro retornada pelo SDK.
  /// Salva IDs detectados em SharedPreferences e atualiza RequestConfiguration.
  static Future<void> detectAndSaveTestDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_prefsKey);
    if (existing != null && existing.isNotEmpty) {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(testDeviceIds: existing),
      );
      print('✅ Test device IDs carregados das preferências: $existing');
      return;
    }

    final completer = Completer<void>();

    final ad = BannerAd(
      size: AdSize.banner,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Official AdMob test banner ad unit ID
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          // Se carregar com sucesso, apenas descartamos — dispositivo já autorizado como teste.
          ad.dispose();
          print('ℹ️ Banner carregou sem erro (não obteve device id).');
          completer.complete();
        },
        onAdFailedToLoad: (ad, error) async {
          try {
            final msg = error.toString();

            // Padrões comuns do SDK que incluem o device id. Tentamos extrair sequências hex/ASCII.
            final regex = RegExp(r'([A-F0-9]{6,})');
            final matches = regex.allMatches(msg).map((m) => m.group(0)!).toSet().toList();

            if (matches.isNotEmpty) {
              // Garantir que 'EMULATOR' não seja salvo aqui.
              final filtered = matches.where((s) => s.toUpperCase() != 'EMULATOR').toList();
              if (filtered.isNotEmpty) {
                await prefs.setStringList(_prefsKey, filtered);
                await MobileAds.instance.updateRequestConfiguration(
                  RequestConfiguration(testDeviceIds: filtered),
                );
                print('✅ Device IDs detectados e salvos: $filtered');
              } else {
                print('⚠️ Padrão detectado, mas sem IDs válidos: $matches');
              }
            } else {
              print('⚠️ Não foi possível extrair device id do erro: $msg');
            }
          } catch (e) {
            print('⚠️ Erro ao processar erro do Ad: $e');
          } finally {
            ad.dispose();
            completer.complete();
          }
        },
      ),
      request: const AdRequest(),
    );

    // Tentar carregar — se nenhuma resposta em 6s, aborta.
    ad.load();
    return completer.future.timeout(const Duration(seconds: 6), onTimeout: () {
      try {
        ad.dispose();
      } catch (_) {}
      print('⚠️ Timeout detectando device id');
      return Future.value();
    });
  }
}
