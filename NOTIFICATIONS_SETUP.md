# Sistema de Notificações - Holy Messages

## ✅ Implementação Completa

O app agora possui **dois tipos de notificações**:

### 1. 📱 Notificações Locais Agendadas
- Enviam versículos bíblicos diariamente no horário escolhido
- Funcionam mesmo com o app fechado
- Não dependem de internet após configuração
- Usuário escolhe o horário

### 2. 🌐 Push Notifications Remotas (Firebase Cloud Messaging)
- Permite enviar notificações do Firebase Console ou API
- Ideal para comunicados especiais, eventos, novos recursos
- Requer internet para receber

---

## 🚀 Como Usar

### No App (Para Usuários):

1. **Abra o App** e vá em **Configurações** (ícone de engrenagem)
2. **Toque em "Notificações"**
3. **Ative "Notificações Diárias"**
4. **Escolha o horário** (ex: 9:00 da manhã)
5. **Teste** clicando em "Enviar Notificação de Teste"

---

## 📬 Como Enviar Push Notifications Remotas

### Opção 1: Firebase Console (Mais Fácil)

1. Acesse: https://console.firebase.google.com
2. Selecione seu projeto **holy_messages**
3. Vá em **Messaging** (Cloud Messaging)
4. Clique em **"Send your first message"** ou **"New notification"**
5. Preencha:
   - **Título**: "Versículo Especial 🙏"
   - **Texto**: "Pois Deus amou o mundo de tal maneira..."
   - **Imagem** (opcional): URL de uma imagem
6. Clique em **"Next"**
7. Selecione:
   - **Target**: User segment > All users
   - Ou use o **FCM Token** (disponível na página de notificações do app)
8. Configure horário (agora ou agendar)
9. Clique em **"Review"** e depois **"Publish"**

### Opção 2: API (Para Desenvolvedores)

#### Requisitos:
- Server Key do Firebase (em Project Settings > Cloud Messaging)
- FCM Token do dispositivo (mostrado no app)

#### Exemplo com cURL:
```bash
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Versículo do Dia 🙏",
      "body": "Confie no Senhor de todo o seu coração - Provérbios 3:5"
    },
    "data": {
      "verse_id": "123",
      "book": "Provérbios",
      "chapter": "3"
    }
  }'
```

#### Exemplo com Node.js:
```javascript
const admin = require('firebase-admin');

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

const message = {
  notification: {
    title: 'Versículo do Dia 🙏',
    body: 'O Senhor é o meu pastor, nada me faltará - Salmos 23:1',
  },
  data: {
    verse_id: '456',
    book: 'Salmos',
    chapter: '23',
  },
  token: 'DEVICE_FCM_TOKEN', // Token do dispositivo
};

admin.messaging().send(message)
  .then((response) => {
    console.log('✅ Notificação enviada:', response);
  })
  .catch((error) => {
    console.log('❌ Erro:', error);
  });
```

#### Exemplo com Python:
```python
import requests
import json

SERVER_KEY = 'YOUR_FIREBASE_SERVER_KEY'
FCM_URL = 'https://fcm.googleapis.com/fcm/send'

headers = {
    'Authorization': f'key={SERVER_KEY}',
    'Content-Type': 'application/json',
}

payload = {
    'to': 'DEVICE_FCM_TOKEN',
    'notification': {
        'title': 'Versículo do Dia 🙏',
        'body': 'Tudo posso naquele que me fortalece - Filipenses 4:13',
    },
    'data': {
        'verse_id': '789',
        'book': 'Filipenses',
        'chapter': '4',
    }
}

response = requests.post(FCM_URL, headers=headers, data=json.dumps(payload))
print('✅ Resposta:', response.json())
```

---

## 🔧 Configurações Técnicas

### Android
- ✅ Permissões configuradas em `AndroidManifest.xml`
- ✅ Firebase Cloud Messaging service registrado
- ✅ Boot receiver para manter notificações após reiniciar

### iOS
- ✅ Background modes configurados (remote-notification, fetch)
- ✅ Permissões de notificação solicitadas automaticamente
- ✅ Firebase delegate configurado

---

## 🎯 Recursos Implementados

### NotificationService (`lib/core/services/notification_service.dart`)

**Métodos principais:**
- `initialize()` - Inicializa o serviço (chamado no `main.dart`)
- `scheduleDailyNotification()` - Agenda notificação diária
- `cancelDailyNotification()` - Cancela notificação diária
- `sendTestNotification()` - Envia notificação de teste
- `requestNotificationPermission()` - Solicita permissão
- `fcmToken` - Getter para obter o FCM token

### NotificationSettingsPage

**Interface completa para:**
- ✅ Ativar/Desativar notificações diárias
- ✅ Escolher horário personalizado
- ✅ Enviar notificação de teste
- ✅ Ver token FCM (para envio remoto)

---

## 📊 Fluxo de Notificações

### Notificação Local Diária:
```
1. Usuário ativa notificações
2. Escolhe horário (ex: 9:00)
3. App agenda notificação local
4. Todo dia às 9:00, sistema exibe versículo
5. Versículo é escolhido aleatoriamente do banco
```

### Push Notification Remota:
```
1. Admin/Backend envia via Firebase
2. Firebase entrega para o dispositivo
3. App recebe a mensagem
4. Se app fechado: Sistema exibe notificação
5. Se app aberto: App mostra notificação local
6. Usuário toca: App abre e processa dados
```

---

## 🧪 Como Testar

### 1. Testar Notificações Locais:
```
1. Abra o app
2. Configurações > Notificações
3. Ative notificações diárias
4. Escolha horário próximo (ex: daqui 1 minuto)
5. Aguarde o horário
6. ✅ Deve aparecer versículo
```

### 2. Testar Push Remotas:
```
1. Copie o FCM Token da página de notificações
2. Vá no Firebase Console
3. Cloud Messaging > New notification
4. Cole o token no campo "FCM registration token"
5. Envie
6. ✅ Deve receber imediatamente
```

### 3. Testar Notificação de Teste:
```
1. Configurações > Notificações
2. Clique em "Enviar Notificação de Teste"
3. ✅ Deve aparecer imediatamente
```

---

## 🔑 Obtendo o Server Key do Firebase

Para enviar notificações via API, você precisa do Server Key:

1. Acesse https://console.firebase.google.com
2. Selecione seu projeto
3. ⚙️ **Project Settings** (engrenagem no topo)
4. Aba **Cloud Messaging**
5. Em **"Cloud Messaging API (Legacy)"** copie o **"Server Key"**

⚠️ **Importante**: Mantenha este key em segredo! Nunca comita no código.

---

## 💡 Ideias de Uso

### Notificações Locais Diárias:
- ✅ Versículo do dia (já implementado)
- Lembretes de oração
- Devocionais matinais
- Meditações noturnas

### Push Notifications Remotas:
- Versículos especiais em datas comemorativas
- Avisos de novos recursos
- Comunicados da comunidade
- Eventos ao vivo
- Estudos bíblicos temáticos
- Série de versículos sobre um tema

---

## 📱 Permissões

### Android
- POST_NOTIFICATIONS (Android 13+)
- VIBRATE
- RECEIVE_BOOT_COMPLETED
- SCHEDULE_EXACT_ALARM

### iOS
- Notification permission (solicitada automaticamente)
- Background fetch
- Remote notifications

---

## 🐛 Troubleshooting

### Notificações não aparecem:
1. Verifique se permissão foi concedida
2. Confirme que horário está correto
3. Teste com botão "Notificação de Teste"
4. Verifique configurações do sistema

### Push remota não chega:
1. Confirme que tem internet
2. Verifique se o FCM token está correto
3. Teste no Firebase Console primeiro
4. Verifique Server Key na API

### Notificação não aparece em iOS:
1. Permissão concedida?
2. Firebase configurado corretamente?
3. APNs habilitado no Firebase?
4. Bundle ID correto?

---

## 📚 Documentação Adicional

- [Firebase Cloud Messaging](https://firebase.google.com/docs/cloud-messaging)
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Firebase Messaging Flutter](https://pub.dev/packages/firebase_messaging)

---

## ✨ Próximos Passos (Opcional)

1. **Personalização de Versículos**:
   - Escolher temas (amor, fé, esperança)
   - Filtrar por livro
   - Versículos favoritos

2. **Analytics**:
   - Rastrear quantas notificações são abertas
   - Ver horários mais efetivos

3. **Notificações Ricas**:
   - Adicionar imagens
   - Botões de ação (Favoritar, Compartilhar)
   - Sons personalizados

4. **Backend Dedicado**:
   - API para envio programático
   - Segmentação de usuários
   - A/B testing de mensagens
