import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'pt': {
      // Settings Page
      'settings_title': 'Configurações',
      'premium_version': 'Versão Premium ⭐',
      'free_version': 'Versão Gratuita',
      'thank_you': 'Obrigado pelo apoio!',
      'no_ads_forever': 'Contém anúncios.',
      'no_ads': 'Sem Anúncios',
      'premium_experience': 'Experiência premium sem interrupções',
      'buy_premium_apple': 'Comprar Premium',
      'restore_purchases': 'Restaurar Compras',
      'premium_active': 'Premium Ativo',
      'premium_unlocked': 'Experiência completa desbloqueada',
      'about': 'Sobre',
      'notifications': 'Notificações',
      'notifications_subtitle': 'Configure notificações diárias',
      'app_version': 'Versão do App',
      'about_us': 'Sobre Nós',
      'about_us_subtitle': 'Mensagens diárias e Bíblia completa',
      'account': 'Conta',
      'logout': 'Sair da Conta',
      'logout_subtitle': 'Fazer logout',
      'logout_title': 'Sair da Conta',
      'logout_message': 'Tem certeza que deseja sair da sua conta?',
      'cancel': 'Cancelar',
      'logout_button': 'Sair',
      'logged_out': '👋 Você saiu da sua conta',
      'buy_premium': 'Comprar Premium',
      'unlock_features': 'Desbloqueie:',
      'read_in_peace': 'Leia em paz',
      'close': 'Fechar',
      'purchases_restored': '✅ Compras restauradas!',
      'error': 'Erro',
      'language': 'Idioma',
      'language_subtitle': 'Alterar idioma do aplicativo',
      'select_language': 'Selecionar Idioma',
      'portuguese': 'Português',
      'english': 'English',
      'language_changed': '✅ Idioma alterado!',
      
      // Notification Settings
      'notification_settings_title': 'Configurações de Notificações',
      'enable_notifications': 'Ativar Notificações',
      'notification_time': 'Horário da Notificação',
      'select_time': 'Selecionar Horário',
      
      // Home Page
      'home_title': 'Mensagens Sagradas',
      'verse_of_day': 'Versículo do Dia',
      'liturgy': 'Liturgia',
      'bible': 'Bíblia',
      'favorites': 'Favoritos',
      
      // Common
      'save': 'Salvar',
      'loading': 'Carregando...',
      'error_loading': 'Erro ao carregar',
      'try_again': 'Tentar novamente',
      'success': 'Sucesso!',
      'share': 'Compartilhar',
      'share_photo': 'Compartilhar Foto',
      'share_verses': 'Compartilhar Versículos com Imagens Personalizadas',

      'delete_account': 'Excluir conta',
      'delete_account_confirmation': 'Tem certeza que deseja excluir sua conta? Esta ação não poderá ser desfeita.',
      'account_excluded_with_success': '✅ Conta excluída com sucesso!',
      'relogin_to_delete_account': 'Faça login novamente para excluir sua conta.',
      'error_deleting_account': 'Erro ao excluir conta: {error}',
      'login_required': 'Login necessário',
      'login_required_message': 'Você precisa estar logado para comprar o Premium e restaurar em outros dispositivos.',

    },
    'en': {
      // Settings Page
      'settings_title': 'Settings',
      'premium_version': 'Premium Version ⭐',
      'free_version': 'Free Version',
      'thank_you': 'Thank you for your support!',
      'no_ads_forever': 'Contains ads.',
      'no_ads': 'No Ads',
      'premium_experience': 'Premium experience without interruptions',
      'buy_premium_apple': 'Buy Premium',
      'restore_purchases': 'Restore Purchases',
      'premium_active': 'Premium Active',
      'premium_unlocked': 'Full experience unlocked',
      'about': 'About',
      'notifications': 'Notifications',
      'notifications_subtitle': 'Configure daily notifications',
      'app_version': 'App Version',
      'about_us': 'About Us',
      'about_us_subtitle': 'Daily messages and complete Bible',
      'account': 'Account',
      'logout': 'Log Out',
      'logout_subtitle': 'Sign out',
      'logout_title': 'Log Out',
      'logout_message': 'Are you sure you want to log out?',
      'cancel': 'Cancel',
      'logout_button': 'Log Out',
      'logged_out': '👋 You have logged out',
      'buy_premium': 'Buy Premium',
      'unlock_features': 'Unlock:',
      'read_in_peace': 'Read in peace',
      'close': 'Close',
      'purchases_restored': '✅ Purchases restored!',
      'error': 'Error',
      'language': 'Language',
      'language_subtitle': 'Change app language',
      'select_language': 'Select Language',
      'portuguese': 'Português',
      'english': 'English',
      'language_changed': '✅ Language changed!',
      
      // Notification Settings
      'notification_settings_title': 'Notification Settings',
      'enable_notifications': 'Enable Notifications',
      'notification_time': 'Notification Time',
      'select_time': 'Select Time',
      
      // Home Page
      'home_title': 'Holy Messages',
      'verse_of_day': 'Verse of the Day',
      'liturgy': 'Liturgy',
      'bible': 'Bible',
      'favorites': 'Favorites',
      
      // Common
      'save': 'Save',
      'loading': 'Loading...',
      'error_loading': 'Error loading',
      'try_again': 'Try again',
      'success': 'Success!',
      'share': 'Share',

      'share_photo': 'Share Photo',
      'share_verses': 'Share Verses',

      'delete_account': 'Delete Account',
      'delete_account_confirmation': 'Are you sure you want to delete your account? This action cannot be undone.',
      'account_excluded_with_success': '✅ Account successfully deleted!',
      'relogin_to_delete_account': 'Please log in again to delete your account.',
      'error_deleting_account': 'Error deleting account: {error}',
      'login_required': 'Login Required',
      'login_required_message': 'You need to be logged in to purchase Premium and restore on other devices.',



    },
  };

  String translate(String key) {
    final languageCode = locale.languageCode;
    final translation = _localizedValues[languageCode]?[key];
    
    if (translation == null) {
      print('⚠️ Translation missing for key: $key in language: $languageCode');
      return key;
    }
    
    return translation;
  }

  // Getters convenientes para acesso fácil às traduções
  String get settingsTitle => translate('settings_title');
  String get premiumVersion => translate('premium_version');
  String get freeVersion => translate('free_version');
  String get thankYou => translate('thank_you');
  String get noAdsForever => translate('no_ads_forever');
  String get noAds => translate('no_ads');
  String get sharePhoto => translate('share_photo');

  String get premiumExperience => translate('premium_experience');
  String get shareVerses => translate('share_verses');

  String get buyPremiumApple => translate('buy_premium_apple');
  String get restorePurchases => translate('restore_purchases');
  String get premiumActive => translate('premium_active');
  String get premiumUnlocked => translate('premium_unlocked');
  String get about => translate('about');
  String get notifications => translate('notifications');
  String get notificationsSubtitle => translate('notifications_subtitle');
  String get appVersion => translate('app_version');
  String get aboutUs => translate('about_us');
  String get aboutUsSubtitle => translate('about_us_subtitle');
  String get account => translate('account');
  String get logout => translate('logout');
  String get logoutSubtitle => translate('logout_subtitle');
  String get logoutTitle => translate('logout_title');
  String get logoutMessage => translate('logout_message');
  String get cancel => translate('cancel');
  String get logoutButton => translate('logout_button');
  String get loggedOut => translate('logged_out');
  String get buyPremium => translate('buy_premium');
  String get unlockFeatures => translate('unlock_features');
  String get readInPeace => translate('read_in_peace');
  String get close => translate('close');
  String get purchasesRestored => translate('purchases_restored');
  String get error => translate('error');
  String get language => translate('language');
  String get languageSubtitle => translate('language_subtitle');
  String get selectLanguage => translate('select_language');
  String get portuguese => translate('portuguese');
  String get english => translate('english');
  String get languageChanged => translate('language_changed');
  
  // Notification Settings
  String get notificationSettingsTitle => translate('notification_settings_title');
  String get enableNotifications => translate('enable_notifications');
  String get notificationTime => translate('notification_time');
  String get selectTime => translate('select_time');
  
  // Home Page
  String get homeTitle => translate('home_title');
  String get verseOfDay => translate('verse_of_day');
  String get liturgy => translate('liturgy');
  String get bible => translate('bible');
  String get favorites => translate('favorites');
  
  // Common
  String get save => translate('save');
  String get loading => translate('loading');
  String get errorLoading => translate('error_loading');
  String get tryAgain => translate('try_again');
  String get success => translate('success');
  String get share => translate('share');

  String get deleteAccount => translate('delete_account');
  String get deleteAccountConfirmation => translate('delete_account_confirmation');
  String get accountExcludedWithSuccess => translate('account_excluded_with_success');
  String get reloginToDeleteAccount => translate('relogin_to_delete_account');
  String errorDeletingAccount(String errorMessage) {
    return translate('error_deleting_account').replaceFirst('{error}', errorMessage);
  }

  String get loginRequired => translate('login_required');
  String get loginRequiredMessage => translate('login_required_message');

}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['pt', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
