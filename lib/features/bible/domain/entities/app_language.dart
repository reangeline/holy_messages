enum AppLanguage {
  pt,
  en;

  static AppLanguage fromCode(String code) {
    final c = code.toLowerCase();
    if (c.startsWith('pt')) return AppLanguage.pt;
    return AppLanguage.en;
  }

  String get code => this == AppLanguage.pt ? 'pt' : 'en';
}