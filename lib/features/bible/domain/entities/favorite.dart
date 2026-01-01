import 'package:hive/hive.dart';

class Favorite {
  final String id;
  final String messageId;
  final String verse;
  final String reference;
  final String savedAt;

  Favorite({
    required this.id,
    required this.messageId,
    required this.verse,
    required this.reference,
    required this.savedAt,
  });
}

class FavoriteAdapter extends TypeAdapter<Favorite> {
  @override
  final int typeId = 1;

  @override
  Favorite read(BinaryReader reader) {
    final id = reader.readString();
    final messageId = reader.readString();
    final verse = reader.readString();
    final reference = reader.readString();
    final savedAt = reader.readString();
    return Favorite(
      id: id,
      messageId: messageId,
      verse: verse,
      reference: reference,
      savedAt: savedAt,
    );
  }

  @override
  void write(BinaryWriter writer, Favorite obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.messageId);
    writer.writeString(obj.verse);
    writer.writeString(obj.reference);
    writer.writeString(obj.savedAt);
  }
}
