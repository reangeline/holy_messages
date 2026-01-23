import '../../features/bible/domain/entities/app_language.dart';

class AppStrings {
  final AppLanguage _language;

  AppStrings(this._language);

  // Navigation & Bottom Bar
  String get home => _language == AppLanguage.pt ? 'Início' : 'Home';
  String get favorites => _language == AppLanguage.pt ? 'Favoritos' : 'Favorites';
  String get bible => _language == AppLanguage.pt ? 'Bíblia' : 'Bible';
  String get liturgy => _language == AppLanguage.pt ? 'Liturgia' : 'Liturgy';
  String get history => _language == AppLanguage.pt ? 'Histórico' : 'History';
  String get settings => _language == AppLanguage.pt ? 'Configurações' : 'Settings';

  // Common Actions
  String get share => _language == AppLanguage.pt ? 'Compartilhar' : 'Share';
  String get favorite => _language == AppLanguage.pt ? 'Favoritar' : 'Favorite';
  String get remove => _language == AppLanguage.pt ? 'Remover' : 'Remove';
  String get cancel => _language == AppLanguage.pt ? 'Cancelar' : 'Cancel';
  String get confirm => _language == AppLanguage.pt ? 'Confirmar' : 'Confirm';
  String get close => _language == AppLanguage.pt ? 'Fechar' : 'Close';
  String get save => _language == AppLanguage.pt ? 'Salvar' : 'Save';
  String get loading => _language == AppLanguage.pt ? 'Carregando...' : 'Loading...';

  // Headers & Titles
  String get wordOfGod => _language == AppLanguage.pt ? 'Palavra de Deus' : 'Word of God';
  String get messageOfTheDay => _language == AppLanguage.pt ? 'Mensagem do Dia' : 'Message of the Day';
  String get myFavorites => _language == AppLanguage.pt ? 'Meus Favoritos' : 'My Favorites';
  String get dailyLiturgy => _language == AppLanguage.pt ? 'Liturgia Diária' : 'Daily Liturgy';
  String get bibleReader => _language == AppLanguage.pt ? 'Leitor da Bíblia' : 'Bible Reader';
  String get verseHistory => _language == AppLanguage.pt ? 'Histórico de Versículos' : 'Verse History';

  // Messages & Notifications
  String get loginToFavorite => _language == AppLanguage.pt 
      ? 'Faça login para adicionar favoritos' 
      : 'Login to add favorites';
  String get addedToFavorites => _language == AppLanguage.pt 
      ? 'Adicionado aos favoritos' 
      : 'Added to favorites';
  String get removedFromFavorites => _language == AppLanguage.pt 
      ? 'Removido dos favoritos' 
      : 'Removed from favorites';
  String get noFavorites => _language == AppLanguage.pt 
      ? 'Nenhum favorito ainda' 
      : 'No favorites yet';
  String get noHistory => _language == AppLanguage.pt 
      ? 'Nenhum histórico ainda' 
      : 'No history yet';
  String get noLiturgyAvailable => _language == AppLanguage.pt 
      ? 'Nenhuma liturgia disponível' 
      : 'No liturgy available';

  // Error Messages
  String get errorLoadingBible => _language == AppLanguage.pt 
      ? 'Erro ao carregar a Bíblia' 
      : 'Error loading Bible';
  String errorLoadingLiturgies(String error) => _language == AppLanguage.pt 
      ? 'Erro ao carregar liturgias: $error' 
      : 'Error loading liturgies: $error';
  String get errorLoadingVerse => _language == AppLanguage.pt 
      ? 'Erro ao carregar versículo' 
      : 'Error loading verse';

  // Premium & Settings
  String get premiumFeatures => _language == AppLanguage.pt 
      ? 'Recursos Premium' 
      : 'Premium Features';
  String get dailyMessagesAndFullBible => _language == AppLanguage.pt 
      ? 'Mensagens diárias e Bíblia completa' 
      : 'Daily messages and complete Bible';
  String get notifications => _language == AppLanguage.pt 
      ? 'Notificações' 
      : 'Notifications';
  String get languageLabel => _language == AppLanguage.pt 
      ? 'Idioma' 
      : 'Language';
  String get aboutApp => _language == AppLanguage.pt 
      ? 'Sobre o App' 
      : 'About the App';

  // Bible Books & References
  String get book => _language == AppLanguage.pt ? 'Livro' : 'Book';
  String get chapter => _language == AppLanguage.pt ? 'Capítulo' : 'Chapter';
  String get verse => _language == AppLanguage.pt ? 'Versículo' : 'Verse';
  String verses(int count) => _language == AppLanguage.pt 
      ? '$count versículos' 
      : '$count verses';
  String chapters(int count) => _language == AppLanguage.pt 
      ? '$count capítulos' 
      : '$count chapters';

  // Share Image Options
  String get chooseBackground => _language == AppLanguage.pt 
      ? 'Escolha o fundo' 
      : 'Choose background';
  String get generateImage => _language == AppLanguage.pt 
      ? 'Gerar imagem' 
      : 'Generate image';
  String get generatingImage => _language == AppLanguage.pt 
      ? 'Gerando imagem...' 
      : 'Generating image...';
  String get shareAsText => _language == AppLanguage.pt 
      ? 'Compartilhar como texto' 
      : 'Share as text';
  String get shareAsImage => _language == AppLanguage.pt 
      ? 'Compartilhar como imagem' 
      : 'Share as image';

  // Date & Time
  String get today => _language == AppLanguage.pt ? 'Hoje' : 'Today';
  String get yesterday => _language == AppLanguage.pt ? 'Ontem' : 'Yesterday';
  String get thisWeek => _language == AppLanguage.pt ? 'Esta semana' : 'This week';
  String get thisMonth => _language == AppLanguage.pt ? 'Este mês' : 'This month';

  // Topics & Categories
  String get topics => _language == AppLanguage.pt ? 'Tópicos' : 'Topics';
  String get allTopics => _language == AppLanguage.pt ? 'Todos os tópicos' : 'All topics';
  String get search => _language == AppLanguage.pt ? 'Pesquisar' : 'Search';
  String get searchVerses => _language == AppLanguage.pt 
      ? 'Pesquisar versículos' 
      : 'Search verses';
    // Search hints
    String get searchBooksHint => _language == AppLanguage.pt ? 'Buscar livros' : 'Search books';

  // Navigation to Bible chapter
  String get readFullChapter => _language == AppLanguage.pt 
      ? 'Ler capítulo completo' 
      : 'Read full chapter';
  String get goToVerse => _language == AppLanguage.pt 
      ? 'Ir para versículo' 
      : 'Go to verse';

  // Previous Messages
  String get previousMessages => _language == AppLanguage.pt 
      ? 'Mensagens Anteriores' 
      : 'Previous Messages';
  String get viewAll => _language == AppLanguage.pt 
      ? 'Ver todas' 
      : 'View all';

  // Auth & User
  String get login => _language == AppLanguage.pt ? 'Entrar' : 'Login';
  String get logout => _language == AppLanguage.pt ? 'Sair' : 'Logout';
  String get signUp => _language == AppLanguage.pt ? 'Cadastrar' : 'Sign Up';
  String get profile => _language == AppLanguage.pt ? 'Perfil' : 'Profile';
  String get account => _language == AppLanguage.pt ? 'Conta' : 'Account';

  // Empty States
  String get noResultsFound => _language == AppLanguage.pt 
      ? 'Nenhum resultado encontrado' 
      : 'No results found';
  String get tryAnotherSearch => _language == AppLanguage.pt 
      ? 'Tente outra pesquisa' 
      : 'Try another search';
  String get startReadingBible => _language == AppLanguage.pt 
      ? 'Comece a ler a Bíblia' 
      : 'Start reading the Bible';

  // Drawer & Premium
  String get premiumActive => _language == AppLanguage.pt ? 'Premium Ativo ✨' : 'Premium Active ✨';
  String get freeVersion => _language == AppLanguage.pt ? 'Versão Gratuita' : 'Free Version';
  String get unlockPremium => _language == AppLanguage.pt ? 'Desbloqueie Premium' : 'Unlock Premium';
  String get noAds => _language == AppLanguage.pt ? 'Sem Anúncios' : 'No Ads';
  String get customWidgets => _language == AppLanguage.pt ? 'Widgets Personalizados' : 'Custom Widgets';
  String get unlimitedAccess => _language == AppLanguage.pt ? 'Acesso Ilimitado' : 'Unlimited Access';
  String get pureExperience => _language == AppLanguage.pt ? 'Experiência Pura' : 'Pure Experience';
  String get buyPremium => _language == AppLanguage.pt ? 'Comprar Premium' : 'Buy Premium';
  String buyPremiumWithPrice(String price) => _language == AppLanguage.pt 
      ? 'Comprar - $price' 
      : 'Buy - $price';
  String get youArePremium => _language == AppLanguage.pt ? 'Você é Premium! 🌟' : 'You are Premium! 🌟';
 
  String get youUnlocked => _language == AppLanguage.pt ? 'Você desbloqueou:' : 'You unlocked:';
  String get premiumUnlocked => _language == AppLanguage.pt ? 'Experiência completa desbloqueada' : 'Full experience unlocked';
  String get resetPremium => _language == AppLanguage.pt ? 'Resetar Premium (Teste)' : 'Reset Premium (Test)';
  String get dailyReadings => _language == AppLanguage.pt ? 'Leituras do dia' : 'Daily readings';
  String get about => _language == AppLanguage.pt ? 'Sobre' : 'About';
  String get holyMessages => _language == AppLanguage.pt ? 'Mensagens Sagradas' : 'Holy Messages';
  String get appVersion => _language == AppLanguage.pt ? 'Versão 1.0.0' : 'Version 1.0.0';
  String get dailyBibleDescription => _language == AppLanguage.pt 
      ? 'Sua Bíblia diária com mensagens inspiradoras.' 
      : 'Your daily Bible with inspiring messages.';

  // Auth dialogs
  String get signupRequired => _language == AppLanguage.pt ? 'Cadastro Necessário' : 'Signup Required';
  String get signupToLogin => _language == AppLanguage.pt ? 'Fazer Login' : 'Login';
  String get signupMessage => _language == AppLanguage.pt 
      ? 'Para realizar uma compra, você precisa fazer o cadastro ou login em sua conta. Isso garante que suas compras sejam sincronizadas entre dispositivos.' 
      : 'To make a purchase, you need to sign up or log in to your account. This ensures your purchases are synchronized across devices.';
  String get welcome => _language == AppLanguage.pt ? '🎉 Bem-vindo!' : '🎉 Welcome!';
  String get youAreLoggedIn => _language == AppLanguage.pt 
      ? 'Você está logado! Deseja comprar Premium agora?' 
      : 'You are logged in! Do you want to buy Premium now?';
  String get later => _language == AppLanguage.pt ? 'Depois' : 'Later';
  String get buyNow => _language == AppLanguage.pt ? 'Comprar Premium' : 'Buy Premium';
  String get processingPurchase => _language == AppLanguage.pt 
      ? 'Processando compra com Apple...' 
      : 'Processing purchase with Apple...';
  String get welcomeToPremium => _language == AppLanguage.pt 
      ? '🎉 Bem-vindo ao Premium!' 
      : '🎉 Welcome to Premium!';
  String get purchaseNotCompleted => _language == AppLanguage.pt 
      ? '⚠️ Compra não foi concluída. Tente novamente.' 
      : '⚠️ Purchase was not completed. Try again.';
  String purchaseError(String error) => _language == AppLanguage.pt 
      ? '❌ Erro ao processar compra: $error' 
      : '❌ Error processing purchase: $error';
  String get logoutConfirm => _language == AppLanguage.pt ? 'Sair da Conta' : 'Sign Out';
  String get logoutMessage => _language == AppLanguage.pt 
      ? 'Tem certeza que deseja sair?' 
      : 'Are you sure you want to sign out?';
  String get logoutSuccess => _language == AppLanguage.pt 
      ? '✅ Logout realizado com sucesso' 
      : '✅ Successfully logged out';
  String get exit => _language == AppLanguage.pt ? 'Sair' : 'Exit';

  // Verse detail page
  String get verseOfTheDay => _language == AppLanguage.pt ? 'Versículo do Dia' : 'Verse of the Day';
  String get dailyInspiration => _language == AppLanguage.pt 
      ? 'Inspiração diária para você' 
      : 'Daily inspiration for you';
  String get removedFromFavoritesSingle => _language == AppLanguage.pt 
      ? 'Removido dos favoritos' 
      : 'Removed from favorites';
  String get addedToFavoritesSingle => _language == AppLanguage.pt 
      ? '✅ Adicionado aos favoritos' 
      : '✅ Added to favorites';
  String get favoriteLimitReached => _language == AppLanguage.pt 
      ? '❌ Limite de 5 favoritos atingido. Upgrade para Premium!' 
      : '❌ Limit of 5 favorites reached. Upgrade to Premium!';
  String shareError(String error) => _language == AppLanguage.pt 
      ? 'Erro ao compartilhar: $error' 
      : 'Error sharing: $error';
  String error(String error) => _language == AppLanguage.pt ? 'Erro: $error' : 'Error: $error';
  String get noData => _language == AppLanguage.pt ? 'Sem dados.' : 'No data.';

  // Settings page
  String get premiumVersion => _language == AppLanguage.pt ? 'Versão Premium' : 'Premium Version';
  String get freeVersionSettings => _language == AppLanguage.pt ? 'Versão Gratuita' : 'Free Version';
  String get allFeaturesAccess => _language == AppLanguage.pt 
      ? 'Você tem acesso a todos os recursos' 
      : 'You have access to all features';
  String get unlockAllFeatures => _language == AppLanguage.pt 
      ? 'Desbloqueie todos os recursos' 
      : 'Unlock all features';
  String get readWithoutInterruptions => _language == AppLanguage.pt 
      ? 'Leia sem interrupções' 
      : 'Read without interruptions';
  String get active => _language == AppLanguage.pt ? 'Ativado' : 'Active';
  String get configureNotifications => _language == AppLanguage.pt 
      ? 'Configure notificações diárias' 
      : 'Configure daily notifications';
  String get aboutUs => _language == AppLanguage.pt ? 'Sobre Nós' : 'About Us';
  String get logoutAccount => _language == AppLanguage.pt ? 'Sair da Conta' : 'Sign Out';
  String get doLogout => _language == AppLanguage.pt ? 'Fazer logout' : 'Log out';
  String get welcomeToPremiumVersion => _language == AppLanguage.pt 
      ? '🎉 Bem-vindo à versão Premium!' 
      : '🎉 Welcome to Premium version!';
  String get logoutAccountConfirm => _language == AppLanguage.pt 
      ? 'Tem certeza que deseja sair da sua conta?' 
      : 'Are you sure you want to sign out of your account?';

  // Verse Image Service
  String get verseOfDayImage => _language == AppLanguage.pt ? 'Versículo do dia' : 'Verse of the day';
}
