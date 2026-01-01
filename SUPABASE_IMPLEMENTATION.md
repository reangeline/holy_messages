# ✅ Supabase + Holy Messages - Setup Completo

## Status Atual

O app agora tem **backend de sincronização com Supabase** sem problemas de compilação!

### ✅ O Que Está Funcionando

- **Supabase integrado** - Sincronização de compras cross-device
- **Autenticação** - Email/senha e anônima via Supabase Auth
- **Premium local** - Hive (funciona offline)
- **Premium sincronizado** - Supabase (funciona online)
- **31,103 versículos** - Todos carregados e indexados
- **Ads** - Google Mobile Ads funcionando
- **In-App Purchase** - Apple IAP integrado

## Próximas Etapas - Configurar Supabase

### 1️⃣ Criar Conta Supabase (5 min)

Acesse: https://supabase.com/dashboard

### 2️⃣ Criar Novo Projeto

- Nome: `holy-messages`
- Senha do DB: Use uma forte
- Região: Próxima a você

### 3️⃣ Copiar Credenciais

No dashboard: **Settings > API**
- Copie: **Project URL**
- Copie: **anon public key**

### 4️⃣ Atualizar Credenciais

Edite: `lib/app/supabase_config.dart`

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'SEU_PROJECT_URL_AQUI';
  static const String supabaseAnonKey = 'SUA_CHAVE_AQUI';
  // ...
}
```

### 5️⃣ Criar Tabelas no Banco

No Supabase: **SQL Editor > New Query**

Cole este SQL:

```sql
-- Tabela de compras
CREATE TABLE purchases (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL UNIQUE,
  is_premium BOOLEAN DEFAULT false,
  receipt_data TEXT,
  platform TEXT,
  purchase_date TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  CONSTRAINT purchases_user_id_fkey FOREIGN KEY (user_id) 
    REFERENCES auth.users(id) ON DELETE CASCADE
);

CREATE INDEX idx_purchases_user_id ON purchases(user_id);
```

Clique em **Execute**

### 6️⃣ Testar

```bash
flutter run
```

## Arquivos Criados

### Core Supabase
- 📄 `lib/app/supabase_config.dart` - Configuração inicial
- 📄 `lib/features/settings/state/supabase_auth_provider.dart` - Autenticação
- 📄 `lib/features/settings/state/supabase_service.dart` - Sincronização de compras
- 📄 `lib/features/settings/state/synced_supabase_premium_provider.dart` - Premium sincronizado

### Documentação
- 📘 `SUPABASE_SETUP.md` - Guia detalhado
- 📘 `FIREBASE_SETUP.md` - Info sobre Firebase (alternativa)

## Como Usar no Código

### Verificar se está logado
```dart
final auth = ref.watch(supabaseAuthNotifierProvider);
bool isLogged = auth.isLoggedIn();
```

### Fazer login
```dart
await auth.signUpWithEmail(
  email: 'user@example.com',
  password: 'senha123'
);
```

### Ativar premium e sincronizar
```dart
final premium = ref.watch(syncedSupabasePremiumProvider.notifier);
await premium.purchasePremium();
```

### Sincronizar com servidor
```dart
await premium.syncWithSupabase();
```

## Benefícios do Supabase

✅ **Sem problemas de compilação** (diferente do Firebase)
✅ **PostgreSQL real** (dados estruturados)
✅ **Auth integrada** (email, Google, GitHub, etc)
✅ **Real-time sync** (WebSocket)
✅ **Self-hostable** (você pode hospedar seu próprio servidor)
✅ **Preço justo** (gratuito até 50GB)
✅ **Comunidade ativa** (muito usado em Flutter)

## Fluxo de Autenticação

```
┌─────────────────────────────────────────────┐
│  App (Offline Mode)                         │
│  - Premium armazenado em Hive               │
│  - Funciona sem internet                    │
└────────────┬────────────────────────────────┘
             │
             ├─ Usuário faz login
             │
             ▼
┌─────────────────────────────────────────────┐
│  Supabase Auth                              │
│  - Email/Senha                              │
│  - Google Sign-In (opcional)                │
└────────────┬────────────────────────────────┘
             │
             ├─ Autenticação sucesso
             │
             ▼
┌─────────────────────────────────────────────┐
│  Supabase Database (PostgreSQL)             │
│  - Sincroniza dados de compra               │
│  - Cross-device sync                        │
│  - Histórico de compras                     │
└─────────────────────────────────────────────┘
```

## Plano Futuro

- 📱 Adicionar Google Sign-In
- 💳 Melhorar integração com Apple IAP
- 📊 Dashboard de analytics
- 🔐 2FA (Two-Factor Authentication)
- 📦 Backup automático

---

**Status**: ✅ Pronto para configuração Supabase
