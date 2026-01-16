# 🔔 Como Testar Notificações

Este app agora suporta **DOIS TIPOS** de notificações:

## 1️⃣ Notificações Locais (Versículos Diários)

### Como Funciona
- O app agenda notificações **localmente** no seu dispositivo
- **Cada dia um versículo diferente** é selecionado aleatoriamente
- Funciona **sem internet** e **sem servidor**
- Versículos vêm do arquivo `assets/data/verses.json`

### Como Testar
1. Abra o app
2. Vá em **Settings** → **Notificações**
3. Ative o toggle **"Ativar Notificações Diárias"**
4. Escolha um horário (ex: daqui 2 minutos)
5. Aguarde a notificação aparecer
6. Clique na notificação → deve abrir o versículo

### Verificar se está Funcionando
```bash
# Ver logs de agendamento
flutter run

# Procure por estas mensagens:
🕐 Iniciando agendador de versículos diários...
📖 Buscando versículo aleatório...
✨ Versículo selecionado: [texto do versículo]
✅ Notificação agendada para [horário]
```

---

## 2️⃣ Notificações Push via Firebase (Remotas)

### Como Funciona
- Servidor envia notificações remotamente via **Firebase Cloud Messaging**
- Você controla quando e o que enviar
- Funciona com app **fechado, em background ou aberto**

### Como Testar

#### Passo 1: Obter o FCM Token
1. Abra o app
2. Vá em **Settings** → **Notificações**
3. Role até **"Firebase Cloud Messaging"**
4. Clique em **"Copiar FCM Token"**
5. Token será copiado para área de transferência

#### Passo 2: Enviar Teste via Firebase Console
1. Acesse: https://console.firebase.google.com
2. Selecione seu projeto: **holy_messages**
3. Vá em **Cloud Messaging** (menu lateral)
4. Clique em **"Send your first message"** ou **"New notification"**
5. Preencha:
   - **Notification title**: `🙏 Não esqueça de rezar!`
   - **Notification text**: `Não temas, porque eu sou contigo - Isaías 41:10`
6. Clique em **"Send test message"**
7. Cole o **FCM Token** que você copiou
8. Clique em **"Test"**

#### Passo 3: Testar com Dados (para navegação)
Para testar navegação quando clicar na notificação:

1. No Firebase Console, ao criar notificação
2. Clique em **"Additional options"**
3. Em **"Custom data"**, adicione:
   ```
   type: verse
   book: 23
   chapter: 41
   verse: 10
   text: Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus. - Isaías 41:10
   ```
4. Envie a notificação
5. Clique nela → deve abrir o versículo no app

---

## 📱 Testar via API (Avançado)

Se você quiser enviar notificações programaticamente:

### Usando cURL
```bash
# Substitua:
# - YOUR_SERVER_KEY: Server Key do Firebase (Project Settings → Cloud Messaging)
# - DEVICE_FCM_TOKEN: Token copiado do app

curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "🙏 Não esqueça de rezar!",
      "body": "Não temas, porque eu sou contigo - Isaías 41:10",
      "sound": "default"
    },
    "data": {
      "type": "verse",
      "book": "23",
      "chapter": "41",
      "verse": "10",
      "text": "Não temas, porque eu sou contigo; não te assombres, porque eu sou o teu Deus. - Isaías 41:10"
    }
  }'
```

### Usando Postman
1. Método: **POST**
2. URL: `https://fcm.googleapis.com/fcm/send`
3. Headers:
   - `Authorization: key=YOUR_SERVER_KEY`
   - `Content-Type: application/json`
4. Body (raw JSON):
   ```json
   {
     "to": "DEVICE_FCM_TOKEN",
     "notification": {
       "title": "🙏 Não esqueça de rezar!",
       "body": "Não temas, porque eu sou contigo - Isaías 41:10",
       "sound": "default"
     },
     "data": {
       "type": "verse",
       "book": "23",
       "chapter": "41",
       "verse": "10",
       "text": "Não temas, porque eu sou contigo - Isaías 41:10"
     }
   }
   ```

---

## 🐛 Solução de Problemas

### Notificações Locais não Aparecem
```bash
# Verificar notificações pendentes
flutter run
# Procure por: "Total de notificações pendentes"
```

**Soluções:**
- Verifique se permissões estão concedidas
- Tente agendar para 1-2 minutos no futuro
- Reinicie o app e agende novamente

### FCM Token não Disponível
**Causas comuns:**
- Firebase não configurado corretamente
- App não conectado à internet
- Problemas com google-services.json

**Solução:**
```bash
# Reconfigurar Firebase
cd ios && pod install && cd ..
flutter clean && flutter pub get
```

### Notificação não Navega Corretamente
**Verifique os dados:**
- Payload deve incluir: `type`, `book`, `chapter`, `verse`, `text`
- Formato correto no campo `data` (não `notification`)

---

## ✅ Checklist de Teste

### Notificações Locais
- [ ] Ativar notificações
- [ ] Escolher horário futuro próximo
- [ ] Aguardar notificação aparecer
- [ ] Clicar e verificar navegação
- [ ] Desativar notificações
- [ ] Verificar que pararam

### Notificações Firebase
- [ ] Copiar FCM token
- [ ] Enviar teste via Firebase Console
- [ ] Receber notificação (app aberto)
- [ ] Receber notificação (app em background)
- [ ] Receber notificação (app fechado)
- [ ] Clicar e verificar navegação com dados

---

## 📚 Documentação Adicional

- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Send notifications](https://firebase.google.com/docs/cloud-messaging/send-message)

---

## 🎯 Diferença Entre os Dois Tipos

| Recurso | Notificações Locais | Firebase Push |
|---------|-------------------|---------------|
| **Precisa Internet?** | ❌ Não | ✅ Sim |
| **Versículos Aleatórios?** | ✅ Sim (diários) | ⚠️ Você escolhe |
| **Controle Remoto?** | ❌ Não | ✅ Sim |
| **Servidor Necessário?** | ❌ Não | ✅ Sim (Firebase) |
| **Usa verses.json?** | ✅ Sim | ⚠️ Opcional |
| **Funciona Offline?** | ✅ Sim | ❌ Não |

---

**🎉 Agora você tem o melhor dos dois mundos!**
- **Usuários comuns**: Recebem versículos diários automáticos
- **Você (admin)**: Pode enviar mensagens especiais via Firebase quando quiser
