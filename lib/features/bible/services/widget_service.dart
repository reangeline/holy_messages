import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WidgetService {
  static Future<void> updateDailyVerseWidget({
    required String verse,
    required String reference,
  }) async {
    try {
      // Salvar em SharedPreferences para acesso nativo
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('daily_verse', verse);
      await prefs.setString('daily_verse_ref', reference);

      // Atualizar widget (se disponível)
      await HomeWidget.updateWidget(
        androidName: 'AppWidget',
        qualifiedAndroidName: 'com.example.holy_messages.AppWidget',
      );

      print('✅ Widget atualizado: $reference');
    } catch (e) {
      print('❌ Erro ao atualizar widget: $e');
    }
  }
}