import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../presentation/state/bible_providers.dart';

/// Serviço para gerar e compartilhar imagens de versículos (Premium)
class VerseImageService {
  /// Gera uma imagem do versículo com background e compartilha
  static Future<void> shareVerseAsImage({
    required String verse,
    required String reference,
    required BuildContext context,
    String? backgroundAsset,
  }) async {
    try {
      // Obter strings localizadas
      final container = ProviderScope.containerOf(context);
      final strings = container.read(appStringsProvider);
      
      // Gerar a imagem usando canvas
      final imageFile = await _generateImageWithCanvas(
        verse: verse,
        reference: reference,
        backgroundAsset: backgroundAsset,
      );

      // Compartilhar a imagem
      await Share.shareXFiles(
        [XFile(imageFile.path)],
        text: strings.verseOfDayImage,
      );

      // Limpar arquivo temporário após compartilhar
      Future.delayed(const Duration(seconds: 5), () {
        try {
          imageFile.deleteSync();
        } catch (e) {
          print('Erro ao limpar arquivo temporário: $e');
        }
      });
    } catch (e) {
      print('Erro ao gerar imagem do versículo: $e');
      rethrow;
    }
  }

  /// Gera a imagem usando Canvas nativo
  static Future<File> _generateImageWithCanvas({
    required String verse,
    required String reference,
    String? backgroundAsset,
  }) async {
    const width = 1080.0;
    const height = 1920.0;

    // Criar o recorder para desenhar
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Desenhar fundo
    if (backgroundAsset != null) {
      try {
        // Carregar imagem de fundo
        final data = await rootBundle.load(backgroundAsset);
        final bytes = data.buffer.asUint8List();
        final codec = await ui.instantiateImageCodec(bytes);
        final frame = await codec.getNextFrame();
        final bgImage = frame.image;

        // Desenhar a imagem de fundo cobrindo toda a área
        canvas.drawImageRect(
          bgImage,
          Rect.fromLTWH(0, 0, bgImage.width.toDouble(), bgImage.height.toDouble()),
          const Rect.fromLTWH(0, 0, width, height),
          Paint(),
        );
      } catch (e) {
        print('Erro ao carregar background: $e, usando gradiente');
        _drawGradientBackground(canvas, width, height);
      }
    } else {
      _drawGradientBackground(canvas, width, height);
    }

    // Desenhar overlay escuro
    final overlayPaint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        const Offset(0, height),
        [
          Colors.black.withOpacity(0.3),
          Colors.black.withOpacity(0.5),
          Colors.black.withOpacity(0.7),
        ],
        [0.0, 0.5, 1.0], // colorStops
      );
    canvas.drawRect(const Rect.fromLTWH(0, 0, width, height), overlayPaint);

    // Desenhar textos
    await _drawTexts(canvas, verse, reference, width, height);

    // Finalizar a imagem
    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception('Erro ao converter imagem para bytes');
    }

    // Salvar em arquivo temporário
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/verse_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());

    return file;
  }

  /// Desenha o fundo gradiente
  static void _drawGradientBackground(Canvas canvas, double width, double height) {
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        const Offset(0, 0),
        Offset(width, height),
        [
          const Color(0xFF7C3AED), // purple-600
          const Color(0xFFDB2777), // pink-600
          const Color(0xFFF59E0B), // amber-500
        ],
        [0.0, 0.5, 1.0], // colorStops
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);
  }

  /// Desenha os textos na imagem
  static Future<void> _drawTexts(
    Canvas canvas,
    String verse,
    String reference,
    double width,
    double height,
  ) async {
    const padding = 80.0;
    final maxWidth = width - (padding * 2);

    // Desenhar versículo
    final verseParagraph = _createParagraph(
      '"$verse"',
      maxWidth: maxWidth,
      fontSize: 52,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      textAlign: TextAlign.center,
    );
    
    final verseHeight = verseParagraph.height;
    final verseY = (height - verseHeight - 200) / 2;
    canvas.drawParagraph(verseParagraph, Offset(padding, verseY));

    // Desenhar referência
    final refParagraph = _createParagraph(
      '— $reference',
      maxWidth: maxWidth,
      fontSize: 40,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(0.9),
      textAlign: TextAlign.center,
      fontStyle: FontStyle.italic,
    );
    
    final refY = verseY + verseHeight + 50;
    canvas.drawParagraph(refParagraph, Offset(padding, refY));

    // Desenhar marca do app
    final appNameParagraph = _createParagraph(
      'Holy Messages',
      maxWidth: maxWidth,
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(0.7),
      textAlign: TextAlign.center,
    );
    
    canvas.drawParagraph(
      appNameParagraph,
      Offset(padding, height - 100),
    );
  }

  /// Cria um parágrafo estilizado
  static ui.Paragraph _createParagraph(
    String text, {
    required double maxWidth,
    required double fontSize,
    required FontWeight fontWeight,
    required Color color,
    required TextAlign textAlign,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    final paragraphStyle = ui.ParagraphStyle(
      textAlign: textAlign,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      height: 1.4,
    );

    final textStyle = ui.TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
    );

    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(textStyle)
      ..addText(text);

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: maxWidth));

    return paragraph;
  }

  /// Obtém lista de backgrounds disponíveis automaticamente
  static Future<List<String>> getAvailableBackgrounds() async {
    // Lista de nomes de arquivos conhecidos
    // Adicione novos arquivos aqui quando adicioná-los à pasta
    const backgroundFiles = [
      'arcanjo.jpg',
      'bosque.jpg',
      'jesus_vale.jpg',
      'jesus_vindo_das_nuvem.jpg',
      'leao.jpg',
      'soldado_templario.jpg',
    ];

    // Testar quais arquivos realmente existem
    final existingBackgrounds = <String>[];
    
    for (final filename in backgroundFiles) {
      final assetPath = 'assets/backgrounds/$filename';
      try {
        // Tentar carregar o asset para verificar se existe
        await rootBundle.load(assetPath);
        existingBackgrounds.add(assetPath);
        print('✅ Background encontrado: $assetPath');
      } catch (e) {
        print('⚠️ Background não encontrado: $assetPath');
      }
    }

    print('📸 Total de backgrounds disponíveis: ${existingBackgrounds.length}');
    return existingBackgrounds;
  }
}
