import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

class AuthNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential?> signInAnonymous() async {
    try {
      print('🔐 Iniciando login anônimo...');
      final userCredential = await _auth.signInAnonymously();
      print('✅ Login anônimo realizado: ${userCredential.user?.uid}');
      return userCredential;
    } catch (e) {
      print('❌ Erro no login anônimo: $e');
      return null;
    }
  }

  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('📧 Criando conta com email...');
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Conta criada: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      print('❌ Erro ao criar conta: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('📧 Fazendo login com email...');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ Login realizado: ${userCredential.user?.email}');
      return userCredential;
    } catch (e) {
      print('❌ Erro no login: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('👋 Logout realizado');
    } catch (e) {
      print('❌ Erro ao fazer logout: $e');
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  bool isLoggedIn() {
    return _auth.currentUser != null;
  }

  bool isAnonymous() {
    return _auth.currentUser?.isAnonymous ?? false;
  }
}

final authNotifierProvider = Provider<AuthNotifier>((ref) {
  return AuthNotifier();
});