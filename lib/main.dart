import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app/firebase_config.dart';
import 'core/storage/isar_db.dart';
import 'core/services/notification_service.dart';
import 'core/l10n/app_localizations.dart';
import 'features/settings/state/locale_provider.dart';

import 'features/bible/presentation/pages/home_page.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'core/services/admob_detector.dart';


Future<void> main() async {
  // Capturar erros do Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    print('🔴 Flutter Error: ${details.exception}');
  };

  runZonedGuarded(() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      // IDs de dispositivo de teste - substitua pelos seus IDs reais.
      // Para obter o ID do dispositivo, rode o app e verifique os logs de AdMob
      // (procure por "Use RequestConfiguration to set test device IDs" ou o ID nos logs).
      const List<String> testDeviceIds = [
        'EMULATOR', // mantém o emulador como dispositivo de teste
        'YOUR_DEVICE_ID_HERE',
      ];

      // Atualizar configuração de requisições com dispositivos de teste
      try {
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(testDeviceIds: testDeviceIds),
        );
        print('✅ RequestConfiguration atualizada com dispositivos de teste');
      } catch (e) {
        print('⚠️ Falha ao atualizar RequestConfiguration: $e');
      }

      // Inicializar Google Mobile Ads
      try {
        await MobileAds.instance.initialize();
        print('✅ Mobile Ads inicializado');

        // Tentar detectar e gravar device ID automaticamente (se necessário)
        AdMobDetector.detectAndSaveTestDeviceId().catchError((e) {
          print('⚠️ DetectAdMobDevice falhou: $e');
        });
      } catch (e) {
        print('⚠️ Falha ao inicializar Mobile Ads: $e');
      }
      
      // Inicializar Hive
      await Hive.initFlutter().catchError((e) {
        print('⚠️ Erro Hive: $e');
        throw e;
      });
      
      // Inicializar Firebase com timeout e fallback
      try {
        await FirebaseConfig.initialize().timeout(
          const Duration(seconds: 5),
          onTimeout: () => print('⏰ Firebase timeout'),
        );
      } catch (e) {
        print('⚠️ Firebase falhou (continuando): $e');
      }
      
      // Inicializar Database
      await IsarDb.initialize().catchError((e) {
        print('⚠️ Erro IsarDb: $e');
        throw e;
      });
      
      runApp(
        const ProviderScope(
          child: MyApp(),
        ),
      );
      
      // Notificações em background (não bloqueia)
      Future.delayed(const Duration(seconds: 2), () {
        NotificationService().initialize().catchError((e) {
          print('⚠️ Notificações falhou: $e');
        });
      });
      
    } catch (e, stackTrace) {
      print('🔴 ERRO: $e');
      print('Stack: $stackTrace');
      
      runApp(
        MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.red.shade50,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 80, color: Colors.red),
                      const SizedBox(height: 24),
                      const Text(
                        'Erro ao iniciar',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        e.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }, (error, stack) {
    print('🔴 Erro não tratado: $error');
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Configurar status bar transparente
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );

    final locale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Holy Messages',
      theme: ThemeData(primarySwatch: Colors.amber),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', ''),
        Locale('en', ''),
      ],
      home: const HomePage(),
    );
  }
}