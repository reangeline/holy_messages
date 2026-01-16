class LiturgyModel {
  final String date;
  final String season;
  final String celebration;
  final String color;
  final List<ReadingModel> readings;

  LiturgyModel({
    required this.date,
    required this.season,
    required this.celebration,
    required this.color,
    required this.readings,
  });

  factory LiturgyModel.fromJson(Map<String, dynamic> json) {
    return LiturgyModel(
      date: json['date'] ?? '',
      season: json['season'] ?? '',
      celebration: json['celebration'] ?? '',
      color: json['color'] ?? '',
      readings: (json['readings'] as List?)
              ?.map((r) => ReadingModel.fromJson(r))
              .toList() ??
          [],
    );
  }

  DateTime get dateTime => DateTime.parse(date);
}

class ReadingModel {
  final String type;
  final String ref;
  final ReadingStart start;
  final ReadingRange? range;

  ReadingModel({
    required this.type,
    required this.ref,
    required this.start,
    this.range,
  });

  factory ReadingModel.fromJson(Map<String, dynamic> json) {
    return ReadingModel(
      type: json['type'] ?? '',
      ref: json['ref'] ?? '',
      start: ReadingStart.fromJson(json['start'] ?? {}),
      range: json['range'] != null ? ReadingRange.fromJson(json['range']) : null,
    );
  }
}

class ReadingStart {
  final String key;
  final int book;
  final String bookName;
  final int chapter;
  final int verse;

  ReadingStart({
    required this.key,
    required this.book,
    required this.bookName,
    required this.chapter,
    required this.verse,
  });

  factory ReadingStart.fromJson(Map<String, dynamic> json) {
    return ReadingStart(
      key: json['key'] ?? '',
      book: json['book'] ?? 0,
      bookName: json['book_name'] ?? '',
      chapter: json['chapter'] ?? 0,
      verse: json['verse'] ?? 0,
    );
  }
}

class ReadingRange {
  final int? endChapter;
  final int? endVerse;

  ReadingRange({
    this.endChapter,
    this.endVerse,
  });

  factory ReadingRange.fromJson(Map<String, dynamic> json) {
    return ReadingRange(
      endChapter: json['endChapter'],
      endVerse: json['endVerse'],
    );
  }
}
