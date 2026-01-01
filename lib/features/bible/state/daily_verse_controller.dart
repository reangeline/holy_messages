import '../services/widget_service.dart';

// No método que carrega o versículo do dia, adicione:
Future<void> updateWidget({required String verse, required String reference}) async {
  final verseText = verse;
  final referenceText = reference;
  
  if (verseText.isNotEmpty && referenceText.isNotEmpty) {
    await WidgetService.updateDailyVerseWidget(
      verse: verseText,
      reference: referenceText,
    );
  }
}