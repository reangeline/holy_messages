class BibleRef {
  final int book;     // 1..66 (você define o mapping)
  final int chapter;  // >=1
  final int verse;    // >=1

  const BibleRef({
    required this.book,
    required this.chapter,
    required this.verse,
  });

  /// Mapeamento de números de livros para nomes
  static const Map<int, String> bookNames = {
    1: 'Gênesis', 2: 'Êxodo', 3: 'Levítico', 4: 'Números', 5: 'Deuteronômio',
    6: 'Josué', 7: 'Juízes', 8: '1 Samuel', 9: '2 Samuel', 10: '1 Reis',
    11: '2 Reis', 12: '1 Crônicas', 13: '2 Crônicas', 14: 'Esdras', 15: 'Neemias',
    16: 'Ester', 17: 'Jó', 18: 'Salmos', 19: 'Provérbios', 20: 'Eclesiastes',
    21: 'Cânticos', 22: 'Isaías', 23: 'Jeremias', 24: 'Lamentações', 25: 'Ezequiel',
    26: 'Daniel', 27: 'Oséias', 28: 'Joel', 29: 'Amós', 30: 'Obadias',
    31: 'Jonas', 32: 'Miqueias', 33: 'Naum', 34: 'Habacuque', 35: 'Sofonias',
    36: 'Ageu', 37: 'Zacarias', 38: 'Malaquias', 39: 'Mateus', 40: 'Marcos',
    41: 'Lucas', 42: 'João', 43: 'Atos', 44: 'Romanos', 45: '1 Coríntios',
    46: '2 Coríntios', 47: 'Gálatas', 48: 'Efésios', 49: 'Filipenses', 50: 'Colossenses',
    51: '1 Tessalonicenses', 52: '2 Tessalonicenses', 53: '1 Timóteo', 54: '2 Timóteo', 
    55: 'Tito', 56: 'Filêmon', 57: 'Hebreus', 58: 'Tiago', 59: '1 Pedro',
    60: '2 Pedro', 61: '1 João', 62: '2 João', 63: '3 João', 64: 'Judas', 65: 'Apocalipse',
  };

  /// Obtém o nome do livro
  String get bookName => bookNames[book] ?? 'Livro $book';

  /// Chave estável (boa pra favoritos, share, deep link)
  String get key => '$book:$chapter:$verse';

  /// Chave com nome do livro
  String get keyWithBookName => '$bookName $chapter:$verse';

  @override
  String toString() => key;
}