import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

// Callback global para navegação de notificação
Function(Map<String, dynamic>)? onNotificationTapped;

/// Handler para notificações em background (deve estar fora da classe)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('===== 📱 NOTIFICAÇÃO EM BACKGROUND =====');
  print('Título: ${message.notification?.title}');
  print('Corpo: ${message.notification?.body}');
  print('Dados: ${message.data}');
  print('Message ID: ${message.messageId}');
  print('========================================');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _isInitialized = false;
  String? _fcmToken;

  /// Inicializa o serviço de notificações
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      print('🔔 Inicializando serviço de notificações...');

      // Inicializar timezone
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));

      // Configurar notificações locais
      await _initializeLocalNotifications();

      // Configurar Firebase Cloud Messaging
      await _initializeFirebaseMessaging();

      _isInitialized = true;
      print('✅ Serviço de notificações inicializado');
    } catch (e) {
      print('❌ Erro ao inicializar notificações: $e');
    }
  }

  /// Inicializa notificações locais
  Future<void> _initializeLocalNotifications() async {
    print('🔧 Inicializando flutter_local_notifications...');
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final initialized = await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    print('📱 Local notifications initialized: $initialized');

    // Criar canal de notificação (Android)
    const androidChannel = AndroidNotificationChannel(
      'daily_verses',
      'Versículos Diários',
      description: 'Notificações diárias com versículos bíblicos',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  /// Inicializa Firebase Cloud Messaging
  Future<void> _initializeFirebaseMessaging() async {
    try {
      print('🚀 Iniciando Firebase Cloud Messaging...');
      
      // Solicitar permissão
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('🔐 Permissão de notificação: ${settings.authorizationStatus}');
      
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print('❌ Permissão de notificação negada pelo usuário');
        return;
      }

      // Nota: FCM Token não é necessário para notificações locais
      print('💡 Firebase Cloud Messaging configurado (FCM token não necessário para notificações locais)');

      // Configurar handler para notificações em background
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      print('✅ Background message handler configurado');

      // Handler quando o app está em foreground
      FirebaseMessaging.onMessage.listen((message) {
        print('🎯 onMessage disparado!');
        _handleForegroundMessage(message);
      });
      print('✅ Foreground message listener configurado');

      // Handler quando usuário toca na notificação (app em background)
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('🎯 onMessageOpenedApp disparado!');
        _handleMessageOpenedApp(message);
      });
      print('✅ Message opened listener configurado');

      // Verificar se foi aberto por uma notificação
      print('🔍 Verificando initial message...');
      final initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        print('📨 App foi aberto por notificação!');
        _handleMessageOpenedApp(initialMessage);
      } else {
        print('ℹ️ App não foi aberto por notificação');
      }

      // Listener para atualização do token
      _firebaseMessaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        print('🔄 FCM Token atualizado: ${newToken.substring(0, 20)}...');
        // Aqui você pode enviar o token para seu backend
      });
      
      print('✅ Firebase Cloud Messaging configurado');
    } catch (e) {
      print('❌ Erro ao inicializar Firebase Cloud Messaging: $e');
    }
  }

  /// Força atualização do FCM Token
  Future<String?> refreshFcmToken() async {
    try {
      print('🔄 Solicitando novo FCM Token...');
      _fcmToken = await _firebaseMessaging.getToken();
      if (_fcmToken != null) {
        print('✅ FCM Token atualizado: ${_fcmToken!.substring(0, 20)}...');
      } else {
        print('⚠️ FCM Token não disponível (Firebase pode não estar configurado)');
      }
      return _fcmToken;
    } catch (e) {
      print('⚠️ Não foi possível obter FCM Token: $e');
      print('💡 Isso é normal se o Firebase não estiver configurado. Notificações locais funcionarão normalmente.');
      return null;
    }
  }

  /// Handler para notificações quando app está em foreground
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('===== 📬 NOTIFICAÇÃO EM FOREGROUND =====');
    print('Título: ${message.notification?.title}');
    print('Corpo: ${message.notification?.body}');
    print('Dados: ${message.data}');
    print('Message ID: ${message.messageId}');
    print('========================================');

    final notification = message.notification;
    if (notification == null) {
      print('⚠️ Notificação veio sem notification payload');
      return;
    }

    // Mostrar notificação local
    print('🔔 Mostrando notificação local...');
    await _showLocalNotification(
      title: notification.title ?? 'Holy Messages',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
    );
    print('✅ Notificação local exibida');
  }

  /// Handler quando usuário toca em uma notificação
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('🚀 App aberto por notificação: ${message.notification?.title}');
    print('📦 Dados: ${message.data}');
    
    // Aqui você pode navegar para uma tela específica baseado nos dados
    // Por exemplo: Navigator.pushNamed(context, '/verse', arguments: message.data);
  }

  /// Callback quando usuário toca em notificação local
  void _onNotificationTapped(NotificationResponse response) {
    print('===== 👆 NOTIFICAÇÃO TOCADA =====');
    print('Payload: ${response.payload}');
    
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!);
        print('📦 Payload decodificado: $data');
        
        // Chamar o callback global se estiver configurado
        if (onNotificationTapped != null) {
          print('🎯 Chamando callback de navegação');
          onNotificationTapped!(data);
        } else {
          print('⚠️ Callback de navegação não configurado ainda');
        }
      } catch (e) {
        print('❌ Erro ao processar payload: $e');
      }
    }
    print('=================================');
  }

  /// Mostra uma notificação local
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      print('===== 🔔 SHOWING LOCAL NOTIFICATION =====');
      print('Título: $title');
      print('Body: $body');
      print('Payload: $payload');
      print('Initialized: $_isInitialized');
      
      const androidDetails = AndroidNotificationDetails(
        'daily_verses',
        'Versículos Diários',
        channelDescription: 'Notificações diárias com versículos bíblicos',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        icon: '@mipmap/ic_launcher',
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final notificationId = Random().nextInt(100000);
      print('🆔 ID da notificação: $notificationId');
      
      await _localNotifications.show(
        notificationId,
        title,
        body,
        details,
        payload: payload,
      );
      
      print('✅ Notificação exibida com sucesso');
    } catch (e, stackTrace) {
      print('❌ Erro ao mostrar notificação: $e');
      print('Stack: $stackTrace');
      rethrow;
    }
  }

  /// Agenda uma notificação diária recorrente
  Future<void> scheduleDailyNotification({
    required int hour,
    required int minute,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    print('===== ⏰ AGENDANDO NOTIFICAÇÃO DIÁRIA =====');
    print('Horário: $hour:$minute');
    print('Título: $title');
    print('Body: $body');
    print('Payload: $payload');
    print('Initialized: $_isInitialized');

    final now = tz.TZDateTime.now(tz.local);
    print('Agora: $now');
    
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    print('Data inicial: $scheduledDate');

    // Se o horário já passou hoje, agendar para amanhã
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
      print('Horário passou, ajustado para: $scheduledDate');
    }

    const androidDetails = AndroidNotificationDetails(
      'daily_verses',
      'Versículos Diários',
      channelDescription: 'Notificações diárias com versículos bíblicos',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    print('📲 Chamando zonedSchedule...');
    await _localNotifications.zonedSchedule(
      0, // ID fixo para notificação diária
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload != null ? jsonEncode(payload) : null,
    );
    print('✅ zonedSchedule concluído');

    // Verificar se foi agendada
    final pending = await _localNotifications.pendingNotificationRequests();
    print('Total de notificações pendentes: ${pending.length}');
    for (final p in pending) {
      print('  - ID: ${p.id}, Título: ${p.title}');
    }

    // Salvar configuração
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notification_enabled', true);
    await prefs.setInt('daily_notification_hour', hour);
    await prefs.setInt('daily_notification_minute', minute);

    print('✅ Notificações diárias agendadas');
    print('=========================================');
  }

  /// Agenda uma notificação para um horário específico (não recorrente)
  Future<void> scheduleNotificationAt({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local);
    
    const androidDetails = AndroidNotificationDetails(
      'daily_verses',
      'Versículos Diários',
      channelDescription: 'Notificações diárias com versículos bíblicos',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload != null ? jsonEncode(payload) : null,
    );
  }

  /// Cancela todas as notificações agendadas
  Future<void> cancelDailyNotification() async {
    // Cancelar todas as notificações (IDs 0-6 das notificações diárias)
    for (int i = 0; i < 7; i++) {
      await _localNotifications.cancel(i);
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notification_enabled', false);
    
    print('🚫 Notificações diárias canceladas');
  }

  /// Cancela todas as notificações
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    print('🚫 Todas as notificações canceladas');
  }

  /// Verifica se notificações diárias estão ativadas
  Future<bool> isDailyNotificationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('daily_notification_enabled') ?? false;
  }

  /// Obtém o horário configurado para notificação diária
  Future<Map<String, int>> getDailyNotificationTime() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'hour': prefs.getInt('daily_notification_hour') ?? 9,
      'minute': prefs.getInt('daily_notification_minute') ?? 0,
    };
  }

  /// Solicita permissão de notificação
  Future<bool> requestNotificationPermission() async {
    try {
      // No iOS, solicitar via flutter_local_notifications
      final iosImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      
      if (iosImplementation != null) {
        print('🍎 Solicitando permissão no iOS via flutter_local_notifications...');
        final bool? granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        print('📝 iOS permission granted: $granted');
        return granted ?? false;
      }
      
      // No Android, usar permission_handler
      print('🤖 Solicitando permissão no Android via permission_handler...');
      final status = await Permission.notification.request();
      print('📝 Android permission status: ${status.isGranted}');
      return status.isGranted;
    } catch (e) {
      print('❌ Erro ao solicitar permissão: $e');
      return false;
    }
  }

  /// Verifica se tem permissão de notificação
  Future<bool> hasNotificationPermission() async {
    try {
      // No iOS, verificar via flutter_local_notifications
      final iosImplementation = _localNotifications
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      
      if (iosImplementation != null) {
        print('🍎 Verificando permissão no iOS via flutter_local_notifications...');
        final bool? granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        print('🔍 iOS permission granted: $granted');
        return granted ?? false;
      }
      
      // No Android, usar permission_handler
      print('🤖 Verificando permissão no Android via permission_handler...');
      final status = await Permission.notification.status;
      print('🔍 Android permission status: ${status.isGranted}');
      return status.isGranted;
    } catch (e) {
      print('❌ Erro ao verificar permissão: $e');
      return false;
    }
  }

  /// Abre as configurações de notificação do sistema
  Future<void> openNotificationSettings() async {
    await openAppSettings();
  }

  /// Obtém o FCM token
  String? get fcmToken => _fcmToken;

  /// Envia uma notificação de teste
  Future<void> sendTestNotification() async {
    try {
      print('===== 📤 TESTE DE NOTIFICAÇÃO =====');
      print('Initialized: $_isInitialized');
      
      if (!_isInitialized) {
        print('⚠️ Serviço não inicializado, inicializando...');
        await initialize();
      }
      
      // Verificar permissões antes de tentar
      print('🔍 Verificando permissões...');
      final hasPermission = await hasNotificationPermission();
      print('Tem permissão: $hasPermission');
      
      if (!hasPermission) {
        print('❌ Sem permissão de notificação!');
        throw Exception('Permissão de notificação não concedida');
      }
      
      // Verificar se há pending notifications
      final pending = await _localNotifications.pendingNotificationRequests();
      print('Notificações pendentes: ${pending.length}');
      
      print('📝 Criando notificação local de teste...');
      await _showLocalNotification(
        title: '🙏 Holy Messages - Teste',
        body: 'Se você está vendo isso, as notificações estão funcionando! ${DateTime.now().toString().substring(11, 19)}',
      );
      print('✅ sendTestNotification concluído');
      print('===================================');
    } catch (e, stackTrace) {
      print('===== ❌ ERRO NO TESTE =====');
      print('Erro: $e');
      print('Stack: $stackTrace');
      print('============================');
      rethrow;
    }
  }
}
