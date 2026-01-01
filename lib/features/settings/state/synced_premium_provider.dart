// Arquivo comentado - Firebase foi substituído por Supabase
// Veja: lib/features/settings/state/synced_supabase_premium_provider.dart

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hive/hive.dart';
// import 'firebase_service.dart';
// import 'auth_provider.dart';

// class SyncedPremiumNotifier extends StateNotifier<bool> {
//   final FirebaseService _firebaseService;
//   final AuthNotifier _authNotifier;
//   Box<bool>? _premiumBox;

//   SyncedPremiumNotifier({
//     required FirebaseService firebaseService,
//     required AuthNotifier authNotifier,
//   })  : _firebaseService = firebaseService,
//         _authNotifier = authNotifier,
//         super(false) {
//     _initializePremium();
//   }

//   Future<void> _initializePremium() async {
//     try {
//       _premiumBox = await Hive.openBox<bool>('premium');

//       // Primeiro, carregar estado local
//       final localPremium = _premiumBox?.get('premium_purchased') ?? false;
//       state = localPremium;
//       print('💾 Premium carregado do Hive: $localPremium');

//       // Se usuário está logado, sincronizar com Firebase
//       final userId = _authNotifier.getCurrentUserId();
//       if (userId != null) {
//         print('🔄 Sincronizando premium do Firebase para usuário: $userId');
//         final firebasePremium = await _firebaseService.isPremiumUser(userId);
//         if (firebasePremium != localPremium) {
//           state = firebasePremium;
//           await _premiumBox?.put('premium_purchased', firebasePremium);
//           print('✅ Premium sincronizado: $firebasePremium');
//         }
//       }
//     } catch (e) {
//       print('❌ Erro ao inicializar premium: $e');
//     }
//   }

//   Future<void> purchasePremium() async {
//     try {
//       state = true;
//       await _premiumBox?.put('premium_purchased', true);

//       // Se usuário está logado, salvar no Firebase
//       final userId = _authNotifier.getCurrentUserId();
//       if (userId != null) {
//         print('💰 Salvando compra no Firestore para usuário: $userId');
//         await _firebaseService.savePurchaseData(
//           userId: userId,
//           isPremium: true,
//           receiptData: 'local_purchase',
//           platform: 'iOS',
//         );
//       }

//       print('✅ Premium ativado com sucesso!');
//     } catch (e) {
//       print('❌ Erro ao ativar premium: $e');
//       state = false;
//       rethrow;
//     }
//   }

//   void removePremium() {
//     state = false;
//     _premiumBox?.put('premium_purchased', false);
//     print('🗑️ Premium removido para teste');
//   }

//   Future<void> syncWithFirebase() async {
//     try {
//       final userId = _authNotifier.getCurrentUserId();
//       if (userId == null) {
//         print('⚠️ Usuário não autenticado');
//         return;
//       }

//       print('🔄 Sincronizando com Firebase para usuário: $userId');
//       final firebasePremium = await _firebaseService.isPremiumUser(userId);
//       state = firebasePremium;
//       await _premiumBox?.put('premium_purchased', firebasePremium);
//       print('✅ Sincronização concluída: $firebasePremium');
//     } catch (e) {
//       print('❌ Erro ao sincronizar: $e');
//     }
//   }
// }

// final syncedPremiumProvider =
//     StateNotifierProvider<SyncedPremiumNotifier, bool>((ref) {
//   final firebaseService = ref.watch(firebaseServiceProvider);
//   final authNotifier = ref.watch(authNotifierProvider);

//   return SyncedPremiumNotifier(
//     firebaseService: firebaseService,
//     authNotifier: authNotifier,
//   );
// });

