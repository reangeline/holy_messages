import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

// Provider para gerenciar o estado de premium usando Apple In-App Purchase
final premiumProvider = StateNotifierProvider<PremiumNotifier, bool>((ref) {
  return PremiumNotifier();
});

class PremiumNotifier extends StateNotifier<bool> {
  final InAppPurchase _iap = InAppPurchase.instance;
  static const String premiumProductId = 'com.holymessages.app.premium_version';
  Box<bool>? _purchaseBox;

  PremiumNotifier() : super(false) {
    _initializePremium();
  }

  Future<void> _initializePremium() async {
    try {
      _purchaseBox = await Hive.openBox<bool>('purchases');
      var isPremium = _purchaseBox?.get('premium_purchased', defaultValue: false) ?? false;

      // 🎨 MODO DEBUG: Forçar Premium para screenshots
      
      print('🔍 Premium inicializado: $isPremium');
      state = isPremium;
      
      // Escutar mudanças em compras
      _iap.purchaseStream.listen((purchases) {
        _handlePurchaseUpdates(purchases);
      });
      
      // Restaurar compras automaticamente
      if (!isPremium) {
        await restorePurchase();
      }
    } catch (e) {
      print('❌ Erro ao inicializar premium: $e');
      state = false;
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    print('📥 Recebeu ${purchases.length} atualizações de compra');
    
    for (var purchase in purchases) {
      print('🔍 Compra recebida:');
      print('   - Product ID: ${purchase.productID}');
      print('   - Status: ${purchase.status}');
      print('   - Transaction Date: ${purchase.transactionDate}');
      
      if (purchase.productID == premiumProductId) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          print('✅ Compra confirmada! Ativando premium...');
          _activatePremium();
          
          if (purchase.pendingCompletePurchase) {
            print('🔄 Completando compra pendente...');
            _iap.completePurchase(purchase);
          }
        } else if (purchase.status == PurchaseStatus.error) {
          print('❌ Erro na compra:');
          print('   - Código: ${purchase.error?.code}');
          print('   - Mensagem: ${purchase.error?.message}');
          print('   - Detalhes: ${purchase.error?.details}');
        } else if (purchase.status == PurchaseStatus.canceled) {
          print('⚠️ Compra cancelada pelo usuário');
        } else if (purchase.status == PurchaseStatus.pending) {
          print('⏳ Compra pendente de aprovação');
        }
      } else {
        print('⚠️ Product ID diferente do esperado: ${purchase.productID} != $premiumProductId');
      }
    }
  }

  Future<void> purchasePremium() async {
    try {
      print('💰 Iniciando compra via Apple In-App Purchase...');
      print('🔍 IAP disponível: ${await _iap.isAvailable()}');
      print('🔍 Buscando produto ID: $premiumProductId');
      
      // Buscar produto no App Store
      final productDetails = await _iap.queryProductDetails({premiumProductId});
      
      print('🔍 IDs não encontrados: ${productDetails.notFoundIDs}');
      print('🔍 Produtos encontrados: ${productDetails.productDetails.length}');
      
      if (productDetails.notFoundIDs.contains(premiumProductId)) {
        throw Exception('Produto não configurado no App Store Connect.\n'
            'ID procurado: $premiumProductId\n'
            'Certifique-se que criou o produto com este ID exato.');
      }

      if (productDetails.productDetails.isEmpty) {
        throw Exception('Produto não disponível no momento.\n'
            'Aguarde 15-30 minutos após criar no App Store Connect.');
      }

      final productDetail = productDetails.productDetails.first;
      print('📦 Produto encontrado:');
      print('   - ID: ${productDetail.id}');
      print('   - Título: ${productDetail.title}');
      print('   - Descrição: ${productDetail.description}');
      print('   - Preço: ${productDetail.price}');

      // Iniciar compra
      final purchaseParam = PurchaseParam(productDetails: productDetail);
      print('🚀 Iniciando buyNonConsumable...');
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      
      print('✅ Diálogo de compra da Apple deve aparecer agora');
    } catch (e) {
      print('❌ Erro detalhado ao comprar:');
      print('   Tipo: ${e.runtimeType}');
      print('   Mensagem: $e');
      rethrow;
    }
  }

  Future<void> restorePurchase() async {
    try {
      print('🔄 Restaurando compras da Apple...');
      await _iap.restorePurchases();
      
      // Aguardar processamento
      await Future.delayed(const Duration(seconds: 2));
      
      print('✅ Restauração concluída. Premium: $state');
    } catch (e) {
      print('❌ Erro ao restaurar: $e');
    }
  }

  void _activatePremium() {
    try {
      print('⭐ Ativando premium...');
      _purchaseBox?.put('premium_purchased', true);
      state = true;
      print('✅ Premium ativado! Estado: $state');
    } catch (e) {
      print('❌ Erro ao ativar: $e');
    }
  }

  // Método para teste - REMOVER EM PRODUÇÃO
  Future<void> removePremium() async {
    try {
      await _purchaseBox?.put('premium_purchased', false);
      state = false;
      print('🔄 Premium removido (teste). Estado: $state');
    } catch (e) {
      print('❌ Erro ao remover: $e');
    }
  }
}
