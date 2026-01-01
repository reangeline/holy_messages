# 🚀 Supabase Setup Guide

## O que é Supabase?

Supabase é uma alternativa **open-source ao Firebase** com:
- ✅ PostgreSQL real (em vez de Firestore)
- ✅ Auth integrada
- ✅ Real-time sync
- ✅ Sem conflitos de compilação!
- ✅ Melhor para Flutter

## Passo 1: Criar Projeto no Supabase

1. Acesse https://supabase.com
2. Clique em "Create a new project"
3. Nome: `holy-messages`
4. Senha do banco: Use uma senha forte
5. Região: Escolha a mais próxima (ex: us-east-1)
6. Clique em "Create new project"

## Passo 2: Obter Credenciais

Após criação, você verá:
- **URL**: `https://xxxxx.supabase.co`
- **Anon Key**: `xxxxx.xxxxxxxx`

Copie ambas!

## Passo 3: Atualizar lib/app/supabase_config.dart

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'COLE_A_URL_AQUI';
  static const String supabaseAnonKey = 'COLE_A_CHAVE_AQUI';
  // ...
}
```

## Passo 4: Criar Tabelas no Supabase

No Supabase Console (SQL Editor), execute:

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

-- Índice para buscas rápidas
CREATE INDEX idx_purchases_user_id ON purchases(user_id);
```

## Passo 5: Ativar Auth

1. No Supabase Console: **Authentication** > **Providers**
2. Email/Password: Ativar
3. (Opcional) Google Sign-In, GitHub, etc

## Passo 6: Compilar e Testar

```bash
flutter clean && rm -rf ios/Pods ios/Podfile.lock
flutter pub get
flutter run
```

## Código Pronto para Usar

### Providers Disponíveis:

```dart
// Arquivo de autenticação
import 'features/settings/state/supabase_auth_provider.dart';

// Login com email
final auth = ref.watch(supabaseAuthNotifierProvider);
await auth.signUpWithEmail(email: 'user@example.com', password: 'senha');

// Verificar login
bool isLogged = auth.isLoggedIn();

// Sincronizar premium
import 'features/settings/state/synced_supabase_premium_provider.dart';
final premium = ref.watch(syncedSupabasePremiumProvider.notifier);
await premium.purchasePremium();
```

## Arquivos Criados

- ✅ `lib/app/supabase_config.dart` - Configuração
- ✅ `lib/features/settings/state/supabase_auth_provider.dart` - Auth
- ✅ `lib/features/settings/state/supabase_service.dart` - Sync de compras
- ✅ `lib/features/settings/state/synced_supabase_premium_provider.dart` - Premium sincronizado

## Diferenciais Supabase vs Firebase

| Feature | Supabase | Firebase |
|---------|----------|----------|
| Compilação iOS | ✅ Sem problemas | ❌ Conflito "-G" |
| Database | PostgreSQL | Firestore |
| Auth | ✅ Integrada | ✅ Integrada |
| Real-time | ✅ WebSocket | ✅ WebSocket |
| Custo | Gratuito até 50GB | Gratuito com limites |
| Self-hosted | ✅ Sim | ❌ Não |

## Próximos Passos

1. ✅ Criar projeto Supabase
2. ✅ Configurar credenciais
3. ✅ Criar tabelas
4. ✅ Atualizar supabase_config.dart
5. ✅ Compilar e testar
6. 📝 Adicionar UI para login
7. 🔐 Implementar Google Sign-In (opcional)
