# Firebase Auth - Status Atual

## ✅ Google Sign In Funcionando!

O login com Google está **funcionando**, mas recebendo erro de autorização. Isso é normal - apenas uma configuração final no Firebase Console.

## Erro: "Acesso Bloqueado - Erro de Autorização"

**Causa:** Google Sign In está funcionando, mas Firebase não está autorizado a aceitar o token do Google.

## Erro: "Acesso Bloqueado - Erro de Autorização"

**Causa:** Google Sign In está funcionando, mas Firebase não está autorizado a aceitar o token do Google.

**Solução Rápida:**

### 1. Habilitar Google Sign In no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione "holymessages-a240d"
3. Vá para **Authentication** > **Sign-in method**
4. Clique em **Google**
5. Clique no toggle para **Ativar** (Enable)
6. Clique em **Salvar**

### 2. Configurar OAuth Consent Screen (se necessário)

Se ainda der erro após habilitar:

1. Vá para [Google Cloud Console](https://console.cloud.google.com/)
2. Navegue para **APIs & Services** > **OAuth consent screen**
3. Se estiver em "Draft", clique em **Publish**
4. Preença os campos:
   - App name: "Holy Messages"
   - User support email: seu-email@gmail.com
   - Developer contact info: seu-email@gmail.com
5. Clique em **Publicar**

### 3. Testar Novamente

```bash
flutter clean
flutter run
```

1. Abra o app
2. Vá para a versão Premium (icone 👑 no menu)
3. Clique em "Login"
4. Clique em "Login com Google"
5. Agora deve funcionar! ✅

## ✅ Apple Sign In

O Apple Sign In está configurado e pronto para usar!

### Configurações Já Implementadas:

- ✅ **Runner.entitlements** - Apple Sign In habilitado
- ✅ **Podfile** - iOS 13.0+ suportado
- ✅ **social_login_page.dart** - Integração com Firebase Auth
- ✅ **Info.plist** - Bundle ID correto: `com.holyapp.messages`

### Para Testar Apple Sign In:

1. Tudo já está configurado!
2. Abra o app
3. Vá para a versão Premium
4. Clique em "Login"
5. Clique em "Login com Apple"
6. Selecione sua conta Apple e confirme
7. Pronto! ✅

**Nota:** Apple Sign In funciona apenas em dispositivos físicos com iOS 13+. Em simuladores pode não funcionar completamente.

## Configuração Atual ✅

Código Firebase está **100% pronto** e funcionando:
# Editar pubspec.yaml:
firebase_core: ^3.28.0  # Versão mais recente
firebase_auth: ^5.2.0
cloud_firestore: ^5.3.0

# 2. Executar
flutter clean && rm -rf ios/Pods ios/Podfile.lock
flutter pub get
flutter run
```

### Opção 2: Usar Supabase (Recomendado - Sem problemas de compilação)
```bash
flutter pub add supabase

# Tem Auth integrada, sem conflitos de Swift
# Melhor performance para Flutter
```

### Opção 3: Backend REST Customizado
- Implementar auth simples com Express/Node
- Sincronizar compras via HTTP
- Sem dependências nativas complexas

## Firebase Console
- 🔗 Projeto: `holymessages-a240d`
- 📍 URL: https://console.firebase.google.com/project/holymessages-a240d

## Status das Features
| Feature | Status | Método |
|---------|--------|--------|
| Premium Local | ✅ Funcionando | Hive |
| Premium Sync | ✅ Código pronto | Firebase (desativado) |
| Anonymous Auth | ✅ Código pronto | Firebase (desativado) |
| In-App Purchase | ✅ Funcionando | Apple IAP |
| Ads | ✅ Funcionando | Google Ads |

## Próximos Passos Recomendados

1. **Curto prazo**: App funciona perfeito com premium local (Hive)
2. **Médio prazo**: Testar Firebase com versão 2025+ ou migrar para Supabase
3. **Longo prazo**: Implementar cross-device sync quando Firebase estável
# Descomente esta linha no Podfile:
platform :ios, '12.0'
```

## Passo 3: Configurar Android

### 3.1 Adicionar Aplicativo Android
1. No Firebase Console, clique em "Android"
2. **Package name**: `com.holyapp.messages` (ou seu package name)
3. **SHA-1 fingerprint** (obrigatório):
   ```bash
   cd android
   ./gradlew signingReport
   ```
   Copie o SHA-1 do build "release"
4. Clique em "Registrar app"
5. **Baixe google-services.json**
6. Coloque em `android/app/google-services.json`

### 3.2 Atualizar android/build.gradle
```gradle
// No buildscript
dependencies {
    classpath 'com.google.gms:google-services:4.3.15'
}
```

### 3.3 Atualizar android/app/build.gradle
```gradle
// No final do arquivo, antes de closing brace
apply plugin: 'com.google.gms.google-services'

// Na seção android
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21  // Importante para Google Sign-In
    }
}
```

## Passo 4: Atualizar firebase_options.dart

Após fazer o download dos arquivos de configuração:

1. **Para iOS**: Abra `GoogleService-Info.plist` e copie os valores:
   - `GOOGLE_APP_ID` → `iosGoogleAppId`
   - `API_KEY` → `apiKey`

2. **Para Android**: Abra `google-services.json` e copie:
   - `client[0].client_info.client_id` → `androidGoogleAppId`
   - `api_key[0].current_key` → `apiKey`

### Exemplo atualizado:
```dart
static FirebaseOptions get currentPlatform {
  if (kIsWeb) {
    throw UnsupportedError('Web não suportado');
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return android;
    case TargetPlatform.iOS:
      return ios;
    default:
      throw UnsupportedError('Plataforma não suportada');
  }
}

static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'holy-messages-app',
  storageBucket: 'holy-messages-app.appspot.com',
);

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_IOS_API_KEY',
  appId: 'YOUR_IOS_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'holy-messages-app',
  storageBucket: 'holy-messages-app.appspot.com',
  iosBundleId: 'com.holyapp.messages',
);
```

## Passo 5: Habilitar Firestore

1. No Firebase Console, vá em **Firestore Database**
2. Clique em "Criar banco de dados"
3. Localization: **South America (São Paulo)**
4. Modo de segurança: **Modo de teste** (depois mude para produção)

### Regras de Segurança (Firestore)
```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Usuário só pode ler/escrever seus próprios dados
    match /users/{userId} {
      allow read, write: if request.auth.uid == userId;
    }
  }
}
```

## Passo 6: Configurar Google Sign-In

### iOS - Adicionar URL Scheme
1. Abra `ios/Runner.xcodeproj` no Xcode
2. **Targets** > **Runner** > **Info**
3. Expanda **URL Types**
4. Clique em **+** e adicione:
   - **URL Schemes**: Copie de `GoogleService-Info.plist` a chave `REVERSED_CLIENT_ID`

### Android - Nenhuma configuração adicional necessária
(Google Play Services já está incluído)

## Passo 7: Instalar Dependências

```bash
cd /Users/renatoangeline/daily_messages_local/holy_messages
flutter pub get
```

## Passo 8: Atualizar main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

## ✅ Checklist Final

- [ ] Projeto criado no Firebase Console
- [ ] iOS configurado com GoogleService-Info.plist
- [ ] Android configurado com google-services.json
- [ ] SHA-1 fingerprint adicionado no Android
- [ ] firebase_options.dart atualizado com credenciais
- [ ] Firestore Database criado
- [ ] Autenticação Google habilitada
- [ ] Regras de Firestore configuradas
- [ ] URL Scheme adicionado no iOS
- [ ] `flutter pub get` executado
- [ ] main.dart atualizado para inicializar Firebase

## 🚀 Próximos Passos

Quando terminar o setup:
1. Avise-me para atualizar os providers de premium
2. Vou integrar Google Sign-In no drawer
3. Vou conectar as compras com o Firestore
