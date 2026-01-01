# Configuração do Apple Sign In com Firebase

## ⚠️ ERRO: Apple AuthenticationServices Error 1000

Se recebeu esse erro ao tentar fazer login com Apple:

```
SignInWithAppleAuthorizationException(AuthorizationErrorCode.unknown, 
The operation couldn't be completed. (com.apple.AuthenticationServices.AuthorizationError error 1000.))
```

Significa que Apple Sign In não está habilitado no Firebase Console.

## Solução: Habilitar Apple Sign In no Firebase

### Passo 1: Acesse Firebase Console
1. Vá para [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto **"holymessages-a240d"**
3. No menu lateral, clique em **Authentication**
4. Clique em **Sign-in method**

### Passo 2: Habilitar Apple Sign In
1. Na lista de provedores, procure por **Apple**
2. Clique em **Apple**
3. Clique no toggle para **Ativar** (Enable)
4. Um painel irá aparecer com opções:
   - **Team ID:** Seu Apple Developer Team ID (ex: ABC123XYZ)
   - **Key ID:** ID da chave (ex: 1ABC2DEF3G)
   - **Private Key:** Sua chave privada (em formato .p8)

### Passo 3: Obter Credenciais da Apple

#### Para obter o Team ID:
1. Vá para [Apple Developer](https://developer.apple.com/)
2. Clique em **Account**
3. No menu lateral, vá para **Membership**
4. Copie o **Team ID**

#### Para obter Key ID e Private Key:
1. Em [Apple Developer](https://developer.apple.com/)
2. Vá para **Certificates, Identifiers & Profiles**
3. Clique em **Keys** no menu lateral
4. Procure por uma chave que tenha "Sign in with Apple" habilitado
5. Se não houver, clique em **+** para criar uma nova chave:
   - Selecione **Sign in with Apple**
   - Clique em **Continue**
   - Clique em **Register**
   - Clique em **Download** para baixar o arquivo .p8
6. Copie o **Key ID** e o conteúdo do arquivo .p8

### Passo 4: Preencher no Firebase Console
1. De volta ao Firebase Console, na aba Apple:
   - Cole o **Team ID**
   - Cole o **Key ID**
   - Cole o conteúdo da **Private Key** (arquivo .p8)
2. Clique em **Salvar**

### Passo 5: Registrar App no Apple Developer
1. Em [Apple Developer](https://developer.apple.com/)
2. Vá para **Certificates, Identifiers & Profiles** > **Identifiers**
3. Selecione seu App ID (Bundle ID: `com.holyapp.messages`)
4. Habilite "Sign In with Apple"
5. Clique em **Save**

### Passo 6: Testar

```bash
flutter clean
flutter run
```

1. Abra o app
2. Vá para a seção Premium (ícone 👑)
3. Clique em "Login"
4. Clique em "Login com Apple"
5. Agora deve funcionar! ✅

## Possíveis Erros Restantes

### "Firebase Error (INVALID_CREDENTIAL)"
- Significa que os dados de autenticação foram rejeitados
- Verifique se o Team ID, Key ID e Private Key estão corretos no Firebase
- Verifique se a chave não expirou

### "Erro desconhecido do Apple"
- Apple Sign In ainda não está habilitado no Firebase
- Verifique que você clicou em "Save" após preencher os dados

### "Login cancelado pelo usuário"
- O usuário tocou em "Cancel" durante a autenticação
- É um comportamento normal, não é um erro

## Referências

- [Firebase Authentication - Apple Sign In](https://firebase.google.com/docs/auth/ios/apple)
- [Apple Developer - Sign in with Apple](https://developer.apple.com/sign-in-with-apple/)
- [Sign In with Apple Flutter Package](https://pub.dev/packages/sign_in_with_apple)
