// Arquivo comentado - Firebase foi substituído por Supabase
// Veja: lib/features/settings/state/supabase_service.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class PurchaseData {
//   final String userId;
//   final bool isPremium;
//   final String? receiptData;
//   final String platform; // 'iOS' ou 'Android'
//   final DateTime purchaseDate;

//   PurchaseData({
//     required this.userId,
//     required this.isPremium,
//     this.receiptData,
//     required this.platform,
//     required this.purchaseDate,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'userId': userId,
//       'isPremium': isPremium,
//       'receiptData': receiptData,
//       'platform': platform,
//       'purchaseDate': purchaseDate.toIso8601String(),
//     };
//   }

//   factory PurchaseData.fromMap(Map<String, dynamic> map) {
//     return PurchaseData(
//       userId: map['userId'] as String,
//       isPremium: map['isPremium'] as bool,
//       receiptData: map['receiptData'] as String?,
//       platform: map['platform'] as String,
//       purchaseDate: DateTime.parse(map['purchaseDate'] as String),
//     );
//   }
// }

// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> savePurchaseData({
//     required String userId,
//     required bool isPremium,
//     String? receiptData,
//     required String platform,
//   }) async {
//     try {
//       final purchaseData = PurchaseData(
//         userId: userId,
//         isPremium: isPremium,
//         receiptData: receiptData,
//         platform: platform,
//         purchaseDate: DateTime.now(),
//       );

//       await _firestore
//           .collection('purchases')
//           .doc(userId)
//           .set(purchaseData.toMap(), SetOptions(merge: true));

//       print('✅ Dados de compra salvos no Firestore');
//     } catch (e) {
//       print('❌ Erro ao salvar dados de compra: $e');
//       rethrow;
//     }
//   }

//   Future<bool> isPremiumUser(String userId) async {
//     try {
//       final doc = await _firestore.collection('purchases').doc(userId).get();
//       if (doc.exists) {
//         return doc.data()?['isPremium'] as bool? ?? false;
//       }
//       return false;
//     } catch (e) {
//       print('❌ Erro ao verificar status premium: $e');
//       return false;
//     }
//   }

//   Future<PurchaseData?> getPurchaseData(String userId) async {
//     try {
//       final doc = await _firestore.collection('purchases').doc(userId).get();
//       if (doc.exists) {
//         return PurchaseData.fromMap(doc.data() as Map<String, dynamic>);
//       }
//       return null;
//     } catch (e) {
//       print('❌ Erro ao obter dados de compra: $e');
//       return null;
//     }
//   }

//   Future<void> restorePurchaseFromReceipt({
//     required String userId,
//     required String receiptData,
//     required String platform,
//   }) async {
//     try {
//       await savePurchaseData(
//         userId: userId,
//         isPremium: true,
//         receiptData: receiptData,
//         platform: platform,
//       );
//       print('✅ Compra restaurada com sucesso');
//     } catch (e) {
//       print('❌ Erro ao restaurar compra: $e');
//       rethrow;
//     }
//   }
// }

// final firebaseServiceProvider = Provider<FirebaseService>((ref) {
//   return FirebaseService();
// });

// });

