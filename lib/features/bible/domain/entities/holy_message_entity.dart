/// Representa uma mensagem sagrada curada com versículos relevantes
class HolyMessageEntity {
  final int id;
  final String topic;
  final String title;
  final String slug;
  final List<PassageEntity> passages;

  const HolyMessageEntity({
    required this.id,
    required this.topic,
    required this.title,
    required this.slug,
    required this.passages,
  });
}

/// Representa uma passagem bíblica (pode ter múltiplos versículos)
class PassageEntity {
  final String startKey;
  final String endKey;
  final List<String> previewKeys;

  const PassageEntity({
    required this.startKey,
    required this.endKey,
    required this.previewKeys,
  });
}
