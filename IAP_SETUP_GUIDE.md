# 🍎 Configuração In-App Purchase - App Store Connect

## ✅ Mudanças Implementadas

Agora seu app usa **Apple In-App Purchase (IAP)** corretamente! Isso resolve o problema de rejeição do App Review.

### O que foi feito:
- ✅ Integração com `in_app_purchase` package (já estava instalado)
- ✅ `premium_provider.dart` agora usa StoreKit da Apple
- ✅ Botão "Comprar Premium via Apple" implementado
- ✅ Botão "Restaurar Compras" implementado
- ✅ Tratamento automático de compras completadas
- ✅ Persistência de compras em Hive

---

## 📋 Configuração no App Store Connect

### Passo 1: Criar o Produto IAP

1. Acesse: https://appstoreconnect.apple.com
2. Clique em **"My Apps"** → Selecione **Holy Messages**
3. No menu lateral, clique em **"In-App Purchases"**
4. Clique em **"Manage"** (se pedido)
5. Clique no botão **"+"** para criar novo produto

### Passo 2: Configurar o Produto

**Tipo de Produto:**
- Selecione: **Non-Consumable** (não consumível - compra única permanente)

**Informações de Referência:**
- **Product ID**: `com.holymessages.premium`
  - ⚠️ **IMPORTANTE**: Use EXATAMENTE este ID (está no código)
- **Reference Name**: `Premium Version` (apenas para sua referência interna)

### Passo 3: Preço

1. Na seção **"Pricing"**
2. Selecione: **Price Schedule** → **Add Price**
3. Escolha o preço (exemplo):
   - **Brasil**: R$ 9,90
   - **USA**: $ 2.99
   - Ou use "Equalizar preços globalmente"

### Passo 4: Informações de Localização

Para cada idioma (mínimo Inglês):

**Inglês (US):**
- **Display Name**: `Premium Version`
- **Description**: `Remove ads and support the app forever!`

**Português (Brasil):**
- **Display Name**: `Versão Premium`
- **Description**: `Remova anúncios e apoie o app para sempre!`

### Passo 5: App Store Promotion (Opcional)

- **Promotional Image**: 1024x1024 px (pode deixar em branco inicialmente)
- **Promotional Text**: Descrição curta

### Passo 6: Review Information

- **Screenshot**: Capture tela da compra no app (pode usar Print Screen)
- **Review Notes**: "This is a premium version that removes ads"

### Passo 7: Salvar

1. Clique em **"Save"**
2. Status deve mostrar: **"Ready to Submit"**

---

## 🧪 Como Testar (Sandbox)

### Criar Usuário de Teste

1. App Store Connect → **"Users and Access"**
2. **"Sandbox Testers"** (menu lateral)
3. Clique em **"+"** para adicionar
4. Preencha:
   - Email (pode ser fake: test@test.com)
   - Senha
   - País: Brasil
   - Clique em **"Invite"**

### Testar no iPhone

1. **Configurações** → **App Store** → **Sandbox Account**
2. Login com conta de teste criada
3. Abra o Holy Messages
4. Vá em **Settings** → Clique em **"Comprar Premium via Apple"**
5. Deve aparecer diálogo da Apple com o preço
6. Clique em **"Comprar"**
7. Use credenciais do Sandbox
8. Premium deve ser ativado!

### Testar Restauração

1. Delete o app
2. Reinstale
3. **Settings** → **"Restaurar Compras"**
4. Premium deve voltar automaticamente

---

## 📱 Como Funciona no App

### Fluxo de Compra

```dart
// Usuário clica "Comprar Premium"
↓
// App busca produto: com.holymessages.premium
↓
// Abre diálogo nativo da Apple
↓
// Usuário confirma com Face ID / Touch ID / Senha
↓
// Apple processa pagamento
↓
// App recebe confirmação
↓
// Premium ativado automaticamente
↓
// Salvo no Hive (permanente)
```

### Preço Dinâmico

O preço é buscado automaticamente do App Store Connect:
- Mostra na moeda local do usuário
- Apple gerencia conversões
- Sem hardcode de preços no app

### Segurança

- ✅ Apple valida todas as compras
- ✅ Não é possível hackear (server-side)
- ✅ Restauração automática em novos devices
- ✅ Compras sincronizadas via Apple ID

---

## 🐛 Troubleshooting

### Erro: "Produto não encontrado"

**Causa**: Product ID não configurado ou diferente
**Solução**: 
1. Verifique que usou: `com.holymessages.premium`
2. Aguarde 15min-2h para Apple propagar
3. Teste em device real (não simulador)

### Erro: "Produto não disponível"

**Causa**: IAP não aprovado ou app não publicado
**Solução**:
1. Produto deve estar "Ready to Submit"
2. App deve ter pelo menos 1 build em Review/TestFlight
3. Aguarde aprovação

### Compra não completa

**Causa**: Sandbox não configurado
**Solução**:
1. Use conta Sandbox (não sua conta real!)
2. Logout da conta real antes
3. Teste sempre em device real

---

## ✅ Checklist Final

Antes de submeter para Review:

- [ ] Produto `com.holymessages.premium` criado
- [ ] Preço configurado (mínimo R$ 9,90 / $2.99)
- [ ] Descrições em Inglês e Português
- [ ] Status: "Ready to Submit"
- [ ] Testado com Sandbox Account
- [ ] Botão "Comprar" funciona
- [ ] Botão "Restaurar" funciona
- [ ] Premium persiste após reiniciar app

---

## 🎉 Próximos Passos

1. **Configure o produto agora** no App Store Connect
2. **Teste com Sandbox** para garantir que funciona
3. **Atualize versão** para 1.0.1 em `pubspec.yaml`
4. **Faça novo build** para iOS
5. **Resubmeta** para App Store Review

**Apple vai aprovar desta vez!** 🚀

---

## 💰 Comissão da Apple

- Apple fica com **30%** de cada venda no primeiro ano
- **15%** após 1 ano de subscrição (não se aplica a non-consumable)
- Para produto de R$ 9,90: você recebe ~R$ 6,93

---

## 📚 Referências

- [In-App Purchase Documentation](https://developer.apple.com/in-app-purchase/)
- [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
- [StoreKit Testing](https://developer.apple.com/documentation/storekit/in-app_purchase/testing_in-app_purchases_with_sandbox)
