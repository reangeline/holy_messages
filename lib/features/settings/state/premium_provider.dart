import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Provider para gerenciar o estado de premium
final premiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});

class PremiumNotifier extends StateNotifier<bool> {
  Box<bool>? _purchaseBox;

  PremiumNotifier() : super(false) {
    _initializePremium();
  }

  Future<void> _initializePremium() async {
    try {
      _purchaseBox = await Hive.openBox<bool>('purchases');
      final isPremium = _purchaseBox?.get('premium_purchased', defaultValue: false) ?? false;
      print('🔍 Premium inicializado: $isPremium');
      state = isPremium;
    } catch (e) {
      print('Erro ao inicializar premium: $e');
    }
  }

  Future<void> purchasePremium() async {
    try {
      print('💰 Ativando premium...');
      _purchaseBox = await Hive.openBox<bool>('purchases');
      await _purchaseBox?.put('premium_purchased', true);
      state = true;
      print('✅ Premium ativado com sucesso! Estado: $state');
    } catch (e) {
      print('Erro ao atualizar premium: $e');
    }
  }

  Future<void> restorePurchase() async {
    // Restaurar compras do histórico da Apple
    try {
      _purchaseBox = await Hive.openBox<bool>('purchases');
      final isPremium = _purchaseBox?.get('premium_purchased', defaultValue: false) ?? false;
      state = isPremium;
      print('🔄 Compras restauradas: $isPremium');
    } catch (e) {
      print('Erro ao restaurar compra: $e');
    }
  }

  Future<void> removePremium() async {
    // Para teste: remove o status de premium
    try {
      _purchaseBox = await Hive.openBox<bool>('purchases');
      await _purchaseBox?.put('premium_purchased', false);
      state = false;
      print('🔄 Premium removido para teste. Estado: $state');
    } catch (e) {
      print('Erro ao remover premium: $e');
    }
  }
}

