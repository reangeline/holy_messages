// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VerseModelAdapter extends TypeAdapter<VerseModel> {
  @override
  final int typeId = 0;

  @override
  VerseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VerseModel()
      ..key = fields[0] as String
      ..book = fields[1] as int
      ..chapter = fields[2] as int
      ..verse = fields[3] as int
      ..verseText = fields[4] as String
      ..language = fields[5] as String
      ..topics = (fields[6] as List).cast<String>()
      ..weight = fields[7] as int
      ..verseRange = fields[8] as String?;
  }

  @override
  void write(BinaryWriter writer, VerseModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.key)
      ..writeByte(1)
      ..write(obj.book)
      ..writeByte(2)
      ..write(obj.chapter)
      ..writeByte(3)
      ..write(obj.verse)
      ..writeByte(4)
      ..write(obj.verseText)
      ..writeByte(5)
      ..write(obj.language)
      ..writeByte(6)
      ..write(obj.topics)
      ..writeByte(7)
      ..write(obj.weight)
      ..writeByte(8)
      ..write(obj.verseRange);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
