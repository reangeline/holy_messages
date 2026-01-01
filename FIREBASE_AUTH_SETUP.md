# ✅ Firebase Auth + Apple IAP + Google IAP - Setup

## Status Atual

O app agora tem **Firebase Auth + Pagamentos Nativos (Apple IAP e Google Play IAP)** sem Supabase.

### ✅ O Que Está Funcionando

- **Firebase Auth** - Email/senha e anônima
- **Premium local** - Hive (funciona offline)
- **Apple IAP** - Compra nativa do App Store
- **Google Play IAP** - Compra nativa do Google Play
- **31,103 versículos** - Todos carregados e indexados
- **Ads** - Google Mobile Ads funcionando

## Próximas Etapas - Configurar Firebase

### 1️⃣ Criar Projeto Firebase (5 min)

Acesse: https://console.firebase.google.com

- Clique em "Criar Projeto"
- Nome: `holy-messages`
- Ative Google Analytics (opcional)

### 2️⃣ Registrar Apps no Firebase

#### Para iOS:
1. No Firebase Console → Project Settings → iOS
2. Clique "Adicionar app"
3. Bundle ID: `com.example.holyMessages` (ou seu bundle ID)
4. Download `GoogleService-Info.plist`
5. Abra Xcode: `open ios/Runner.xcworkspace`
6. Arraste o arquivo para dentro de `Runner` → marcando "Copy items if needed"

#### Para Android:
1. No Firebase Console → Project Settings → Android
2. Clique "Adicionar app"
3. Package name: `com.example.holy_messages` (ou seu package name)
4. SHA-1 fingerprint: Execute no terminal:
   ```bash
   cd android
   ./gradlew signingReport
   ```
5. Download `google-services.json`
6. Coloque em: `android/app/google-services.json` (já existe neste projeto)

### 3️⃣ Habilitar Métodos de Autenticação

No Firebase Console:
1. Vá para **Authentication > Sign-in method**
2. Habilite:
   - ✅ **Email/Password**
   - ✅ **Anonymous** (importante para usuários sem conta)

### 4️⃣ Executar o App

```bash
flutter clean
flutter pub get
flutter run
```

## Como Usar no Código

### Verificar se está logado
```dart
final auth = ref.watch(authNotifierProvider);
bool isLogged = auth.isLoggedIn();
```

### Login Anônimo
```dart
final auth = ref.watch(authNotifierProvider);
await auth.signInAnonymous();
```

### Criar Conta
```dart
final auth = ref.watch(authNotifierProvider);
await auth.signUpWithEmail(
  email: 'user@example.com',
  password: 'senha123'
);
```

### Fazer Login
```dart
final auth = ref.watch(authNotifierProvider);
await auth.signInWithEmail(
  email: 'user@example.com',
  password: 'senha123'
);
```

### Logout
```dart
final auth = ref.watch(authNotifierProvider);
await auth.signOut();
```

### Obter Usuário Atual
```dart
final auth = ref.watch(authNotifierProvider);
final user = auth.getCurrentUser();
final userId = auth.getCurrentUserId();
```

### Verificar se é Anônimo
```dart
final auth = ref.watch(authNotifierProvider);
bool isAnon = auth.isAnonymous();
```

## Fluxo de Autenticação

```
┌─────────────────────────────────────────────┐
│  App (Offline Mode)                         │
│  - Premium armazenado em Hive               │
│  - Funciona sem internet                    │
└────────────┬────────────────────────────────┘
             │
             ├─ Usuário faz login ou login anônimo
             │
             ▼
┌─────────────────────────────────────────────┐
│  Firebase Auth                              │
│  - Email/Senha                              │
│  - Anônimo (sem criar conta)                │
└────────────┬────────────────────────────────┘
             │
             ├─ Autenticação sucesso
             │
             ▼
┌─────────────────────────────────────────────┐
│  In-App Purchase (Nativo)                   │
│  - Apple IAP (iOS)                          │
│  - Google Play IAP (Android)                │
│  - Sincronização de compras                 │
└─────────────────────────────────────────────┘
```

## Arquivos Importantes

### Core Firebase
- 📄 `lib/app/firebase_config.dart` - Configuração do Firebase
- 📄 `lib/features/settings/state/auth_provider.dart` - Autenticação Firebase

### Configuração
- 📄 `ios/Runner/GoogleService-Info.plist` - Credenciais iOS
- 📄 `android/app/google-services.json` - Credenciais Android

## Benefícios desta Abordagem

✅ **Firebase Auth** - Autenticação simples e confiável
✅ **Pagamentos Nativos** - Sem intermediários (Apple e Google direto)
✅ **Offline-first** - Funciona sem internet com Hive
✅ **Sem dependência de backend** - Apenas auth + pagamentos nativos
✅ **Menor complexidade** - Menos dependências, mais estável
✅ **Melhor performance** - Sincronização local apenas

## Resolução de Problemas

### Firebase não inicializa
1. Verifique se `GoogleService-Info.plist` (iOS) ou `google-services.json` (Android) estão corretos
2. Execute: `flutter clean && flutter pub get && flutter run`

### Login não funciona
1. Verifique se a autenticação está habilitada no Firebase Console
2. Cheque os logs: `flutter logs`

### Erro ao compilar
1. `flutter clean`
2. `flutter pub get`
3. `flutter run`

## Próximos Passos

- 📱 Adicionar Google Sign-In (opcional)
- 💳 Testar Apple IAP e Google Play IAP
- 📊 Implementar analytics
- 🔐 2FA (Two-Factor Authentication) - opcional
- 📦 Sistema de restauração de compras

---

**Status**: ✅ Pronto para configuração Firebase Auth
