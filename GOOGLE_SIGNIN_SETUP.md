# Configuração do Google Sign In com Firebase

## ⚠️ IMPORTANTE: Configuração Necessária

O Login com Google requer configuração adicional no Firebase Console e Google Cloud Console.

## Passos para Configurar:

### 1. Habilitar Google Sign In no Firebase Console

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto "holymessages-a240d"
3. Vá para **Authentication** (Autenticação) > **Sign-in method**
4. Clique em **Google**
5. Ative a opção
6. Salve

### 2. Gerar SHA-1 para iOS

```bash
# No diretório do projeto
cd /Users/renatoangeline/daily_messages_local/holy_messages
keytool -list -v -keystore ~/.ssh/id_rsa -storepass @Renato
```

Ou obter do Xcode:
1. Abra `ios/Runner.xcworkspace` no Xcode
2. Selecione "Runner" no Project Navigator
3. Vá para **Build Settings**
4. Procure por "Code Signing Identity"
5. Anote o Team ID

### 3. Registrar Aplicativo iOS no Firebase

1. No Firebase Console > Project Settings > iOS apps
2. Clique em "+ Adicionar app"
3. Bundle ID: `com.holyapp.messages`
4. Download do arquivo `GoogleService-Info.plist` (já deve estar configurado)

### 4. Configurar Google Cloud OAuth

1. Acesse [Google Cloud Console](https://console.cloud.google.com/)
2. Selecione o projeto "holy-messages-a240d"
3. Vá para **APIs & Services** > **Credentials**
4. Clique em **+ Create Credentials** > **OAuth Client ID**
5. Selecione **iOS** como tipo de aplicativo
6. Bundle ID: `com.holyapp.messages`
7. Team ID: (Seu Team ID da Apple)
8. Copie o **Web Client ID** gerado
9. Salve o ID no `lib/app/firebase_options.dart`

### 5. Configurar URL Scheme no iOS

O URL scheme já deve estar configurado no `Info.plist`, mas verifique:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLName</key>
    <string>com.google.Firebase</string>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.googleusercontent.apps.475899270664-ohq2d50n3n5n5n5n5n5n5n5n5n5n5n5n</string>
    </array>
  </dict>
</array>
```

## Testes

Após configurar:

1. `flutter clean`
2. `flutter pub get`
3. `flutter run`
4. Navegue para a versão Premium
5. Clique em "Login"
6. Tente fazer login com Google

## Solução de Problemas

### App fecha ao clicar em "Login com Google"

**Causas possíveis:**
- Web Client ID não configurado
- URL Scheme não registrado
- Team ID inválido
- SHA-1 não registrado

**Solução:**
1. Verifique os logs com `flutter run` para ver mensagens de erro
2. Procure por "Erro Firebase" ou "Erro Google" nos logs
3. Siga os passos acima novamente

### "Erro Firebase (INVALID_CREDENTIAL)"

Significa que o ID token do Google não está sendo aceito. Verifique:
- OAuth Client ID está correto
- Web Client ID está no formato correto
- Credenciais não expiram

## Arquivo de Configuração

O arquivo `lib/app/firebase_options.dart` deve conter:

```dart
static const String webClientId = '475899270664-ohq2d50n3n5n5n5n5n5n5n5n5n5n5n5n.apps.googleusercontent.com';
```

Obtenha o valor real do Google Cloud Console OAuth Credentials.

## Referências

- [Google Sign In Flutter Package](https://pub.dev/packages/google_sign_in)
- [Firebase Authentication iOS Setup](https://firebase.google.com/docs/auth/ios/start)
- [Google Cloud OAuth 2.0](https://developers.google.com/identity/protocols/oauth2)
