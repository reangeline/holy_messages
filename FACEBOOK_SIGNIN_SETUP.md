# 📘 Facebook Sign In Setup Guide

## Pré-requisitos
- Conta no [Facebook Developers](https://developers.facebook.com/)
- App criado no Facebook Developers
- Flutter Facebook Auth 6.0.0 ✅ (já instalado)
- Firebase Auth configurado ✅

## Step 1: Configurar App no Facebook Developers

### 1.1 Criar/Configurar App
1. Acesse [Facebook Developers](https://developers.facebook.com/)
2. Vá para **My Apps** → **Create App** (se não tiver)
3. Selecione **Consumer** como tipo de app
4. Preencha as informações do app

### 1.2 Adicionar Produto Facebook Login
1. Na página do app, clique **+ Add Product**
2. Procure por **Facebook Login** e clique **Set Up**
3. Escolha **Mobile App** como plataforma

### 1.3 Obter App ID e App Secret
- Vá para **Settings** → **Basic**
- Copie o **App ID** e **App Secret** (guarde esses valores!)

## Step 2: Configurar iOS

### 2.1 Adicionar URL Scheme no Info.plist
Abra `ios/Runner/Info.plist` e adicione:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb{APP_ID}</string>
    </array>
  </dict>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbapi{APP_ID}</string>
    </array>
  </dict>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbdb{APP_ID}</string>
    </array>
  </dict>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fbauth2</string>
    </array>
  </dict>
</array>
```

**Troque `{APP_ID}` pelo seu App ID do Facebook.**

### 2.2 Adicionar FacebookAppID no Info.plist

Também no `Info.plist`, adicione:

```xml
<key>FacebookAppID</key>
<string>{APP_ID}</string>
<key>FacebookDisplayName</key>
<string>Holy Messages</string>
```

### 2.3 No Facebook Developers - Configurar iOS

1. Em **Facebook Login** → **Settings**
2. Clique em **Add Platform** → **iOS**
3. Preencha:
   - **Bundle ID**: `com.holy.messages` (ou seu Bundle ID real)
   - **Class Name**: `GeneratedPluginRegistrant`
   - **Single Sign On**: Ativar
4. Clique **Save Changes**

### 2.4 Hash da Chave Privada (Importante para iOS)

1. No Xcode, abra `ios/Runner.xcworkspace`
2. Vá para **Build Settings**
3. Procure por **Code Signing Identity**
4. Use o certificado de desenvolvimento padrão
5. Na linha de comando, execute para gerar o hash:

```bash
security find-identity -v -p codesigning
```

5. Copie o certificado usado e insira no Facebook Developers em **iOS Key Hashes**

## Step 3: Configurar Android

### 3.1 Obter Key Hash do Android

Execute no terminal:

```bash
keytool -exportcert -alias androiddebugkey -keystore ~/.android/debug.keystore -storepass android -keypass android | openssl dgst -sha1 -binary | openssl enc -base64
```

### 3.2 Adicionar Key Hash no Facebook Developers

1. Em **Facebook Login** → **Settings**
2. Clique em **Add Platform** → **Android**
3. Em **Key Hashes**, cole o hash obtido acima
4. Preencha:
   - **Package Name**: `com.holy.messages`
   - **Class Name**: `com.holyapp.holy_messages.MainActivity`
5. Clique **Save Changes**

### 3.3 Atualizar android/build.gradle

Adicione as dependências do Facebook (geralmente já estão):

```gradle
dependencies {
    // Facebook SDK
    implementation 'com.facebook.android:facebook-android-sdk:latest.release'
}
```

### 3.4 Atualizar AndroidManifest.xml

Adicione no `android/app/src/main/AndroidManifest.xml`:

```xml
<meta-data
    android:name="com.facebook.sdk.ApplicationId"
    android:value="@string/facebook_app_id" />

<meta-data
    android:name="com.facebook.sdk.ClientToken"
    android:value="@string/facebook_client_token" />
```

### 3.5 Adicionar Strings no strings.xml

Em `android/app/src/main/res/values/strings.xml`:

```xml
<string name="facebook_app_id">{APP_ID}</string>
<string name="facebook_client_token">{CLIENT_TOKEN}</string>
```

Onde:
- `{APP_ID}` é seu App ID do Facebook
- `{CLIENT_TOKEN}` é obtido em **Settings** → **Basic** do Facebook Developers

## Step 4: Configurar Firebase Console

### 4.1 Ativar Facebook Provider

1. Acesse [Firebase Console](https://console.firebase.google.com/)
2. Selecione seu projeto
3. Vá para **Authentication** → **Sign-in method**
4. Clique em **Facebook**
5. Ative o provider
6. Preencha:
   - **App ID**: Seu Facebook App ID
   - **App Secret**: Seu Facebook App Secret (copie do Facebook Developers)
7. Clique **Save**

### 4.2 Configurar OAuth Redirect URI

1. Copie a URL de redirecionamento exibida no Firebase Console
2. No Facebook Developers, vá para **Settings** → **Basic**
3. Em **App Domains**, adicione o domínio da URL
4. Em **Facebook Login** → **Settings** → **Valid OAuth Redirect URIs**, adicione a URL completa do Firebase

## Step 5: Testar

### 5.1 Executar App

```bash
flutter clean
flutter pub get
flutter run
```

### 5.2 Testar Facebook Login

1. Execute o app no simulador/dispositivo
2. Clique em **Login com Facebook**
3. Se aparecer a tela de login do Facebook, está funcionando! ✅

### 5.3 Possíveis Erros

#### Erro: "No app found with Bundle ID"
- Verifique se o Bundle ID no Info.plist matches o registrado no Facebook Developers

#### Erro: "Invalid OAuth Redirect URI"
- Certifique-se de ter adicionado a URL exata do Firebase no Facebook Developers

#### Erro: "App Not Set Up"
- Verifique se Facebook Login foi adicionado como produto no app

## Step 6: Deployment para App Store / Google Play

### Para App Store:
1. Use seu certificado de produção (não debug)
2. Obtenha o key hash de produção
3. Adicione no Facebook Developers (Production Mode)

### Para Google Play:
1. Obtenha o key hash da keystore de produção:

```bash
keytool -exportcert -alias [ALIAS] -keystore [PATH_TO_KEYSTORE] | openssl dgst -sha1 -binary | openssl enc -base64
```

2. Adicione no Facebook Developers (Production Mode)
3. Atualize o App ID no strings.xml de produção

## Resumo do Checklist

- [ ] Criar/configurar app no Facebook Developers
- [ ] Obter App ID e App Secret
- [ ] Configurar URL Schemes no Info.plist (iOS)
- [ ] Configurar FacebookAppID no Info.plist (iOS)
- [ ] Configurar iOS no Facebook Developers
- [ ] Obter e adicionar Key Hash no Facebook Developers (iOS)
- [ ] Obter e adicionar Key Hash no Facebook Developers (Android)
- [ ] Adicionar Facebook SDK ao android/build.gradle
- [ ] Configurar AndroidManifest.xml
- [ ] Adicionar strings ao strings.xml
- [ ] Ativar Facebook Provider no Firebase Console
- [ ] Testar login com Facebook
- [ ] Configurar URLs de redirecionamento no Facebook Developers

## Referências

- [Facebook Developers Docs](https://developers.facebook.com/docs/facebook-login)
- [Flutter Facebook Auth](https://pub.dev/packages/flutter_facebook_auth)
- [Firebase Authentication - Facebook Login](https://firebase.google.com/docs/auth/social/facebook)
