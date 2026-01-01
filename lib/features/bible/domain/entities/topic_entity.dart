class TopicEntity {
  final String id;       // ex: "faith", "anxiety"
  final String labelPt;  // ex: "Fé"
  final String labelEn;  // ex: "Faith"

  const TopicEntity({
    required this.id,
    required this.labelPt,
    required this.labelEn,
  });

  String label({required bool isPt}) => isPt ? labelPt : labelEn;
}