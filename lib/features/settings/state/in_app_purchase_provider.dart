import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:hive/hive.dart';

final inAppPurchaseProvider =
    StateNotifierProvider<InAppPurchaseNotifier, AsyncValue<void>>((ref) {
  return InAppPurchaseNotifier();
});

// Provider para obter o preço do produto Premium
final premiumProductProvider = FutureProvider<ProductDetails?>((ref) async {
  try {
    final iap = InAppPurchase.instance;
    const productId = 'com.holymessages.app.premium_version';
    
    final productDetails = await iap.queryProductDetails({productId});
    
    if (productDetails.productDetails.isEmpty) {
      print('⚠️ Produto Premium não encontrado');
      return null;
    }
    
    final product = productDetails.productDetails.first;
    print('💰 Preço do Premium: ${product.price}');
    return product;
  } catch (e) {
    print('❌ Erro ao buscar preço: $e');
    return null;
  }
});

class InAppPurchaseNotifier extends StateNotifier<AsyncValue<void>> {
  final InAppPurchase _iap = InAppPurchase.instance;
  static const String premiumProductId = 'com.holymessages.app.premium_version';
  Box<bool>? _purchaseBox;

  InAppPurchaseNotifier() : super(const AsyncValue.data(null)) {
    _initializePurchases();
  }

  Future<void> _initializePurchases() async {
    try {
      _purchaseBox = await Hive.openBox<bool>('purchases');
      
      // Restaurar compras anteriores
      await _iap.restorePurchases();
      print('🔄 Restaurando compras anteriores...');
      
      // Escutar mudanças em compras
      _iap.purchaseStream.listen((purchases) {
        print('📲 Mudanças em compras detectadas: ${purchases.length} compra(s)');
        for (var purchase in purchases) {
          _handlePurchase(purchase);
        }
      });
    } catch (e) {
      print('❌ Erro ao inicializar compras: $e');
    }
  }

  void _handlePurchase(PurchaseDetails purchase) {
    print('🛍️ Status da compra: ${purchase.status}');
    print('📝 ID da compra: ${purchase.productID}');
    
    if (purchase.status == PurchaseStatus.purchased) {
      // Salvar que o usuário tem premium
      _purchaseBox?.put('premium_purchased', true);
      
      // Completar a compra
      if (purchase.pendingCompletePurchase) {
        InAppPurchase.instance.completePurchase(purchase);
        print('✅ Compra completada e salva!');
      }
    }
  }

  Future<void> purchasePremium() async {
    try {
      state = const AsyncValue.loading();
      print('💰 Iniciando compra de Premium...');
      
      // Buscar os produtos disponíveis
      final productDetails = await _iap.queryProductDetails({premiumProductId});
      print('🔍 Produtos encontrados: ${productDetails.productDetails.length}');
      print('❌ Produtos não encontrados: ${productDetails.notFoundIDs}');
      
      if (productDetails.notFoundIDs.contains(premiumProductId)) {
        print('⚠️ Produto Premium não encontrado no App Store');
        state = AsyncValue.error(
          Exception('Produto Premium não encontrado. Configure no App Store Connect.'),
          StackTrace.current,
        );
        return;
      }

      if (productDetails.productDetails.isEmpty) {
        print('⚠️ Nenhum produto disponível');
        state = AsyncValue.error(
          Exception('Nenhum produto disponível para compra.'),
          StackTrace.current,
        );
        return;
      }

      final productDetail = productDetails.productDetails.first;
      print('📦 Produto: ${productDetail.title} - ${productDetail.price}');

      // Iniciar compra
      final purchaseParam = PurchaseParam(productDetails: productDetail);
      print('🛒 Abrindo dialog de compra da Apple...');
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      
      state = const AsyncValue.data(null);
      print('✅ Compra iniciada!');
    } catch (e) {
      print('❌ Erro durante compra: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  bool isPurchased() {
    return _purchaseBox?.get('premium_purchased', defaultValue: false) ?? false;
  }
}
