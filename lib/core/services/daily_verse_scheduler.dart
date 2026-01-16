import 'dart:async';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../features/bible/data/models/verse_model.dart';
import '../../../features/bible/data/book_names.dart';
import 'notification_service.dart';

/// Serviço para agendar versículos diários com randomização
class DailyVerseScheduler {
  static final DailyVerseScheduler _instance = DailyVerseScheduler._internal();
  factory DailyVerseScheduler() => _instance;
  DailyVerseScheduler._internal();

  final NotificationService _notificationService = NotificationService();
  Timer? _dailyTimer;

  /// Inicia o agendador de versículos diários
  Future<void> start({required int hour, required int minute}) async {
    print('🕐 Iniciando agendador de versículos diários...');
    
    // Salvar configurações
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notification_enabled', true);
    await prefs.setInt('daily_notification_hour', hour);
    await prefs.setInt('daily_notification_minute', minute);

    // Cancelar timer anterior se existir
    _dailyTimer?.cancel();

    // Agendar primeira notificação para hoje/amanhã
    await _scheduleNextNotification(hour, minute);

    // Configurar timer para verificar diariamente
    _setupDailyTimer(hour, minute);

    print('✅ Agendador iniciado!');
  }

  /// Para o agendador
  Future<void> stop() async {
    print('🛑 Parando agendador de versículos diários...');
    
    _dailyTimer?.cancel();
    _dailyTimer = null;

    // Cancelar notificações pendentes
    await _notificationService.cancelDailyNotification();

    // Atualizar configurações
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notification_enabled', false);

    print('✅ Agendador parado!');
  }

  /// Configura timer para executar diariamente
  void _setupDailyTimer(int hour, int minute) {
    final now = DateTime.now();
    var nextRun = DateTime(now.year, now.month, now.day, hour, minute);
    
    // Se já passou hoje, agendar para amanhã
    if (nextRun.isBefore(now)) {
      nextRun = nextRun.add(const Duration(days: 1));
    }

    final durationUntilNextRun = nextRun.difference(now);
    print('⏰ Próxima execução em: ${durationUntilNextRun.inHours}h ${durationUntilNextRun.inMinutes % 60}min');

    // Timer que executa a cada 24 horas
    _dailyTimer = Timer.periodic(const Duration(days: 1), (timer) {
      print('🔄 Timer disparado! Agendando novo versículo...');
      _scheduleNextNotification(hour, minute);
    });

    // Timer inicial para primeira execução
    Timer(durationUntilNextRun, () {
      print('🔔 Primeira execução! Agendando versículo...');
      _scheduleNextNotification(hour, minute);
    });
  }

  /// Agenda a próxima notificação com versículo aleatório
  Future<void> _scheduleNextNotification(int hour, int minute) async {
    try {
      print('📖 Buscando versículo aleatório...');
      
      // Pegar versículo aleatório
      final verseData = await _getRandomVerseWithData();
      
      print('✨ Versículo selecionado: ${verseData['text']}');

      // Agendar notificação
      await _notificationService.scheduleDailyNotification(
        hour: hour,
        minute: minute,
        title: '🙏 Não esqueça de rezar!',
        body: verseData['text'],
        payload: {
          'type': 'verse',
          'book': verseData['book'],
          'chapter': verseData['chapter'],
          'verse': verseData['verse'],
          'text': verseData['text'],
        },
      );

      print('✅ Notificação agendada para $hour:${minute.toString().padLeft(2, '0')}');
    } catch (e) {
      print('❌ Erro ao agendar notificação: $e');
    }
  }

  /// Pega um versículo aleatório do banco de dados
  Future<Map<String, dynamic>> _getRandomVerseWithData() async {
    try {
      final box = await Hive.openBox('verses');
      final allVerses = box.values.toList().cast<VerseModel>();
      
      if (allVerses.isEmpty) {
        return {
          'text': 'Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus. - Isaías 41:10',
          'book': 23,
          'chapter': 41,
          'verse': 10,
        };
      }

      // Selecionar versículo aleatório
      final random = Random();
      final verse = allVerses[random.nextInt(allVerses.length)];
      final bookName = _getBookName(verse.book);

      return {
        'text': '${verse.verseText} - $bookName ${verse.chapter}:${verse.verse}',
        'book': verse.book,
        'chapter': verse.chapter,
        'verse': verse.verse,
      };
    } catch (e) {
      print('❌ Erro ao obter versículo aleatório: $e');
      return {
        'text': 'Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus. - Isaías 41:10',
        'book': 23,
        'chapter': 41,
        'verse': 10,
      };
    }
  }

  /// Converte número do livro para nome
  String _getBookName(int bookNumber) {
    // Use English names for notifications by default. If you need Portuguese,
    // call the shared helper with langCode: 'pt'.
    try {
      return getBookNameByNumber(bookNumber, langCode: 'en');
    } catch (_) {
      return 'Book $bookNumber';
    }
  }
}
