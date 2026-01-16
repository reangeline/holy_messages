import '../../domain/entities/holy_message_entity.dart';

/// Model para HolyMessage (carregamento do JSON)
class HolyMessageModel extends HolyMessageEntity {
  const HolyMessageModel({
    required super.id,
    required super.topic,
    required super.title,
    required super.slug,
    required super.passages,
  });

  factory HolyMessageModel.fromJson(Map<String, dynamic> json) {
    return HolyMessageModel(
      id: json['id'] as int,
      topic: json['topic'] as String,
      title: json['title'] as String,
      slug: json['slug'] as String,
      passages: (json['passages'] as List)
          .map((p) => PassageModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'topic': topic,
      'title': title,
      'slug': slug,
      'passages': passages.map((p) => (p as PassageModel).toJson()).toList(),
    };
  }
}

/// Model para Passage
class PassageModel extends PassageEntity {
  const PassageModel({
    required super.startKey,
    required super.endKey,
    required super.previewKeys,
  });

  factory PassageModel.fromJson(Map<String, dynamic> json) {
    return PassageModel(
      startKey: json['startKey'] as String,
      endKey: json['endKey'] as String,
      previewKeys: List<String>.from(json['previewKeys'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startKey': startKey,
      'endKey': endKey,
      'previewKeys': previewKeys,
    };
  }
}
