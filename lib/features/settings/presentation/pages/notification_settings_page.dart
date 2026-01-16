import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:holy_messages/core/services/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettingsPage extends ConsumerStatefulWidget {
  const NotificationSettingsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<NotificationSettingsPage> with WidgetsBindingObserver {
  bool _notificationsEnabled = false;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  bool _isLoading = true;
  bool _hasPermission = false;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAndLoadSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Quando o app volta ao foreground (ex: voltou das configurações)
      print('🔄 App retomado - verificando permissões novamente');
      _checkPermissionAndRefresh();
    }
  }

  Future<void> _checkPermissionAndRefresh() async {
    final hasPermission = await _notificationService.hasNotificationPermission();
    print('🔍 Permissão verificada: $hasPermission');
    
    if (mounted) {
      setState(() {
        _hasPermission = hasPermission;
      });
    }
  }

  Future<void> _initializeAndLoadSettings() async {
    setState(() => _isLoading = true);
    
    try {
      print('🚀 Inicializando serviço de notificações...');
      await _notificationService.initialize();
      print('✅ Serviço inicializado');
      
      await _checkPermissionAndRefresh();
      await _loadSettings();
    } catch (e) {
      print('❌ Erro ao inicializar: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao inicializar notificações: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadSettings() async {
    try {
      print('📋 Carregando configurações...');
      
      final enabled = await _notificationService.isDailyNotificationEnabled();
      final time = await _notificationService.getDailyNotificationTime();
      
      print('✅ Configurações carregadas:');
      print('   - Ativado: $enabled');
      print('   - Horário: ${time['hour']}:${time['minute']}');

      if (mounted) {
        setState(() {
          _notificationsEnabled = enabled;
          _selectedTime = TimeOfDay(hour: time['hour']!, minute: time['minute']!);
          _isLoading = false;
        });
      }
      
      // Verificar se precisa re-agendar (após 5 dias das 7 notificações)
      if (enabled) {
        await _checkAndRescheduleIfNeeded();
      }
    } catch (e, stackTrace) {
      print('❌ Erro ao carregar configurações: $e');
      print('Stack: $stackTrace');
      
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _checkAndRescheduleIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastScheduledStr = prefs.getString('last_scheduled_date');
      
      if (lastScheduledStr != null) {
        final lastScheduled = DateTime.parse(lastScheduledStr);
        final daysSinceScheduled = DateTime.now().difference(lastScheduled).inDays;
        
        print('📅 Dias desde último agendamento: $daysSinceScheduled');
        
        // Re-agendar após 5 dias (quando restam apenas 2 notificações)
        if (daysSinceScheduled >= 5) {
          print('🔄 Re-agendando notificações automaticamente...');
          await _scheduleNotification();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('🔄 Notificações renovadas com novos versículos!'),
                backgroundColor: Colors.blue,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('⚠️ Erro ao verificar re-agendamento: $e');
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    print('🔔 _toggleNotifications chamada: $value');
    
    try {
      // Atualizar status da permissão primeiro
      await _checkPermissionAndRefresh();
      
      // Verificar permissão
      print('📋 Verificando permissão...');
      print('✅ Tem permissão: $_hasPermission');
      
      if (value && !_hasPermission) {
        print('🙏 Solicitando permissão...');
        final granted = await _notificationService.requestNotificationPermission();
        print('📝 Permissão concedida: $granted');
        
        // Atualizar estado da permissão
        await _checkPermissionAndRefresh();
        
        if (!_hasPermission) {
          if (mounted) {
            // Mostrar diálogo para ir às configurações
            final shouldOpenSettings = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('⚠️ Permissão Necessária'),
                content: const Text(
                  'Para receber notificações diárias, você precisa permitir notificações nas configurações do dispositivo.\n\n'
                  'Deseja abrir as configurações agora?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB45309),
                    ),
                    child: const Text('Abrir Configurações'),
                  ),
                ],
              ),
            );
            
            if (shouldOpenSettings == true) {
              await _notificationService.openNotificationSettings();
            }
          }
          return;
        }
      }

      setState(() => _notificationsEnabled = value);

      if (value) {
        print('⏰ Agendando notificação com versículo aleatório...');
        await _scheduleNotification();
        print('✅ Notificação agendada com sucesso');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ 7 notificações agendadas para ${_selectedTime.format(context)}\n'
                '🎲 Cada dia um versículo diferente!',
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        print('🚫 Cancelando notificação...');
        await _notificationService.cancelDailyNotification();
        print('✅ Notificação cancelada');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('🚫 Notificações diárias desativadas'),
              backgroundColor: Colors.grey,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      print('❌ Erro em _toggleNotifications: $e');
      print('Stack: $stackTrace');
      
      setState(() => _notificationsEnabled = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Erro ao configurar notificações: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _scheduleNotification() async {
    print('🎲 Agendando notificações com versículos aleatórios para os próximos 7 dias...');
    
    // Cancelar notificações anteriores
    await _notificationService.cancelDailyNotification();
    
    // Preparar múltiplas notificações com versículos diferentes
    final now = DateTime.now();
    var nextNotification = DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);
    
    // Se o horário de hoje já passou, começar de amanhã
    if (nextNotification.isBefore(now)) {
      nextNotification = nextNotification.add(const Duration(days: 1));
    }
    
    // Agendar 7 notificações, cada uma com versículo diferente
    for (int i = 0; i < 7; i++) {
      final verseData = await _getRandomVerseWithData();
      final scheduledDate = nextNotification.add(Duration(days: i));
      
      print('📅 Dia $i - Agendando para: $scheduledDate');
      print('📖 Versículo: ${verseData['textWithRef']?.toString().substring(0, 50)}...');
      
      await _notificationService.scheduleNotificationAt(
        id: i, // ID único para cada dia
        dateTime: scheduledDate,
        title: '🙏 Não esqueça de rezar!',
        body: verseData['textWithRef'],
        payload: {
          'type': 'verse',
          'book': verseData['book'],
          'chapter': verseData['chapter'],
          'verse': verseData['verse'],
          'text': verseData['text'],
        },
      );
    }
    
    // Salvar configurações
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_notification_enabled', true);
    await prefs.setInt('daily_notification_hour', _selectedTime.hour);
    await prefs.setInt('daily_notification_minute', _selectedTime.minute);
    
    // Salvar data da última vez que agendou (para re-agendar automaticamente)
    await prefs.setString('last_scheduled_date', DateTime.now().toIso8601String());
    
    print('✅ 7 notificações agendadas com versículos diferentes!');
  }

  Future<Map<String, dynamic>> _getRandomVerseWithData() async {
    try {
      final box = await Hive.openBox('verses');
      final allVerses = box.values.toList();
      if (allVerses.isEmpty) {
        return {
          'text': 'Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus.',
          'textWithRef': 'Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus. - Isaías 41:10',
          'book': 23,
          'chapter': 41,
          'verse': 10,
        };
      }
      final random = Random();
      final verse = allVerses[random.nextInt(allVerses.length)];
      final bookName = _getBookName(verse.book);
      return {
        'text': verse.verseText, // Apenas o texto do versículo
        'textWithRef': '${verse.verseText} - $bookName ${verse.chapter}:${verse.verse}', // Texto com referência
        'book': verse.book,
        'chapter': verse.chapter,
        'verse': verse.verse,
      };
    } catch (e) {
      print('❌ Erro ao obter versículo aleatório: $e');
      return {
        'text': 'Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus.',
        'textWithRef': 'Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus. - Isaías 41:10',
        'book': 23,
        'chapter': 41,
        'verse': 10,
      };
    }
  }

  // Método auxiliar antigo para teste removido

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
    return bookNames.length >= bookNum ? bookNames[bookNum - 1] : 'Desconhecido';
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFB45309),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() => _selectedTime = pickedTime);

      if (_notificationsEnabled) {
        await _scheduleNotification();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '⏰ Horário atualizado para ${_selectedTime.format(context)}',
              ),
              backgroundColor: Colors.blue,
            ),
          );
        }
      }
    }
  }

  // Botão de teste removido; método não é mais necessário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB45309)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Ícone
                const Icon(
                  Icons.notifications_active,
                  size: 80,
                  color: Color(0xFFB45309),
                ),
                const SizedBox(height: 20),

                // Título
                const Text(
                  'Notificações Diárias',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Receba versículos bíblicos todos os dias',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                Card(
                  color: _hasPermission ? Colors.green[50] : Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              _hasPermission ? Icons.check_circle : Icons.warning_amber,
                              color: _hasPermission ? Colors.green[700] : Colors.orange[700],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _hasPermission 
                                  ? 'Permissões Concedidas ✓'
                                  : 'Permissão de Notificação Necessária',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _hasPermission ? Colors.green[900] : Colors.orange[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (!_hasPermission) ...[
                          const SizedBox(height: 10),
                          const Text(
                            'Para ativar as notificações, você precisa permitir nas configurações do dispositivo.',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton.icon(
                                onPressed: _checkPermissionAndRefresh,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Verificar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  await _notificationService.openNotificationSettings();
                                },
                                icon: const Icon(Icons.settings),
                                label: const Text('Configurações'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Toggle de notificações
                Card(
                  child: SwitchListTile(
                    value: _notificationsEnabled,
                    onChanged: _toggleNotifications,
                    title: const Text('Ativar Notificações Diárias'),
                    subtitle: const Text('Receba um versículo todo dia'),
                    activeColor: const Color(0xFFB45309),
                    secondary: Icon(
                      _notificationsEnabled
                          ? Icons.notifications_active
                          : Icons.notifications_off,
                      color: const Color(0xFFB45309),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Seletor de horário
                Card(
                  child: ListTile(
                    enabled: _notificationsEnabled,
                    leading: const Icon(
                      Icons.access_time,
                      color: Color(0xFFB45309),
                    ),
                    title: const Text('Horário'),
                    subtitle: Text(_selectedTime.format(context)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _notificationsEnabled ? _selectTime : null,
                  ),
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 16),

                // Informações adicionais
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Sobre as Notificações',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '• As notificações são enviadas localmente no dispositivo\n'
                          '• Você receberá um versículo diferente a cada dia\n'
                          '• O horário pode ser ajustado conforme sua preferência\n'
                          '• As notificações funcionam mesmo com o app fechado',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Informação sobre notificações locais
                Card(
                  color: Colors.blue[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Como funciona?',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[900],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'As notificações diárias são programadas localmente no seu dispositivo. '
                          'Você receberá um versículo bíblico todos os dias no horário escolhido, '
                          'mesmo sem conexão com a internet!',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Seção Firebase Push removida conforme solicitado
              ],
            ),
    );
  }
}
