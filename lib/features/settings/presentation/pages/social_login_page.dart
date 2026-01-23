import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:holy_messages/app/firebase_options.dart';

class SocialLoginPage extends ConsumerStatefulWidget {
  const SocialLoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SocialLoginPage> createState() => _SocialLoginPageState();
}

class _SocialLoginPageState extends ConsumerState<SocialLoginPage> {
  bool _isLoading = false;
  String? _error;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      if (mounted) {
        setState(() => _currentUser = user);
      }
    });
  }

  Future<void> _handleAccountConflict(String email, String existingProvider) async {
    if (!mounted) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Conta Já Existente'),
        content: Text(
          'O email $email já está associado ao método de login: $existingProvider.\n\n'
          'Por favor, use o mesmo método de login que você usou anteriormente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('🔐 Iniciando login com Google via Firebase...');
      print('🔗 webClientId: ${DefaultFirebaseOptions.webClientId}');
      
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: DefaultFirebaseOptions.webClientId,
        scopes: ['email', 'profile'],
      );
      
      print('🔍 Verificando se há contas Google disponíveis...');
      
      // Tentar fazer signin
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print('⚠️ Usuário cancelou o login');
        setState(() {
          _error = 'Login cancelado pelo usuário';
        });
        return;
      }

      print('✔️ Usuário selecionado: ${googleUser.email}');
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      print('✔️ Autenticação obtida - Token ID: ${googleAuth.idToken != null ? 'OK' : 'FALHOU'}');
      
      if (googleAuth.idToken == null || googleAuth.accessToken == null) {
        throw Exception('Falha ao obter tokens de autenticação');
      }
      
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔐 Fazendo signin no Firebase...');
      final UserCredential result = await _auth.signInWithCredential(credential);
      
      print('✅ Login realizado com sucesso: ${result.user?.email}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Login realizado!\n${result.user?.email}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        if (mounted) Navigator.of(context).pop(true);
      }
    } on FirebaseAuthException catch (e) {
      String errorMsg = 'Firebase Error (${e.code}): ${e.message}';
      
      // Detectar conflito de contas
      if (e.code == 'account-exists-with-different-credential') {
        final email = e.email ?? 'este email';
        try {
          final existingMethods = await _auth.fetchSignInMethodsForEmail(email);
          final providerNames = existingMethods.map((method) {
            if (method.contains('google')) return 'Google';
            if (method.contains('apple')) return 'Apple';
            if (method.contains('facebook')) return 'Facebook';
            return method;
          }).join(', ');
          
          await _handleAccountConflict(email, providerNames);
        } catch (_) {
          await _handleAccountConflict(email, 'outro método');
        }
        errorMsg = 'Esta conta já existe com outro método de login';
      }
      
      print('❌ $errorMsg');
      setState(() => _error = errorMsg);
    } catch (e, stackTrace) {
      final errorMsg = 'Erro durante login: $e';
      print('❌ $errorMsg');
      print('Stack: $stackTrace');
      setState(() => _error = errorMsg);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signInWithApple() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('🍎 Iniciando login com Apple via Firebase...');
      
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print('✔️ Credencial Apple obtida');
      print('   - Identity Token: OK');
      print('   - Auth Code: OK');
      print('   - User ID: ${credential.userIdentifier}');

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: credential.identityToken,
        accessToken: credential.authorizationCode,
      );

      print('🔐 Fazendo signin no Firebase com credencial Apple...');
      final UserCredential result = await _auth.signInWithCredential(oauthCredential);
      
      print('✅ Login com Apple realizado: ${result.user?.email ?? result.user?.uid}');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Login com Apple realizado!\n${result.user?.email ?? 'Usuário'}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        if (mounted) Navigator.of(context).pop(true);
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      String errorMsg;
      if (e.code == AuthorizationErrorCode.unknown) {
        errorMsg = 'Erro desconhecido do Apple (${e.message}).\n\nPossíveis causas:\n1. Apple Sign In não habilitado no Firebase\n2. Team ID não configurado\n3. Bundle ID não registrado';
      } else if (e.code == AuthorizationErrorCode.canceled) {
        errorMsg = 'Login cancelado pelo usuário';
      } else if (e.code == AuthorizationErrorCode.failed) {
        errorMsg = 'Falha na autenticação do Apple';
      } else if (e.code == AuthorizationErrorCode.invalidResponse) {
        errorMsg = 'Resposta inválida do Apple';
      } else if (e.code == AuthorizationErrorCode.notHandled) {
        errorMsg = 'Requisição não manipulada';
      } else if (e.code == AuthorizationErrorCode.notInteractive) {
        errorMsg = 'Não é possível interagir com a autenticação';
      } else {
        errorMsg = 'Erro Apple: ${e.message}';
      }
      
      print('❌ Erro Sign In with Apple: $errorMsg');
      setState(() => _error = errorMsg);
    } on FirebaseAuthException catch (e) {
      final errorMsg = 'Firebase Error (${e.code}): ${e.message}';
      print('❌ $errorMsg');
      setState(() => _error = errorMsg);
    } catch (e, stackTrace) {
      final errorMsg = 'Erro inesperado: $e';
      print('❌ $errorMsg');
      print('Stack: $stackTrace');
      setState(() => _error = errorMsg);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ignore: unused_element
  Future<void> _signInWithFacebook() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('📘 Iniciando login com Facebook via Firebase...');
      
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        print('✔️ Access Token obtido: ${accessToken.token.substring(0, 20)}...');
        
        final facebookCredential = FacebookAuthProvider.credential(
          accessToken.token,
        );

        print('🔐 Fazendo signin no Firebase com credencial Facebook...');
        final UserCredential userCredential = await _auth.signInWithCredential(facebookCredential);
        
        print('✅ Login com Facebook realizado: ${userCredential.user?.email ?? userCredential.user?.uid}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ Login com Facebook realizado!\n${userCredential.user?.email ?? 'Usuário'}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
          if (mounted) Navigator.of(context).pop(true);
        }
      } else if (result.status == LoginStatus.cancelled) {
        print('⚠️ Login com Facebook cancelado pelo usuário');
        setState(() {
          _error = 'Login cancelado pelo usuário';
        });
      } else {
        throw Exception('Erro ao fazer login com Facebook: ${result.message}');
      }
    } on FirebaseAuthException catch (e) {
      final errorMsg = 'Firebase Error (${e.code}): ${e.message}';
      print('❌ $errorMsg');
      setState(() => _error = errorMsg);
    } catch (e, stackTrace) {
      final errorMsg = 'Erro durante login com Facebook: $e';
      print('❌ $errorMsg');
      print('Stack: $stackTrace');
      setState(() => _error = errorMsg);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se já está logado, mostrar tela de logout
    if (_currentUser != null) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFFB45309)),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 100,
                  color: Colors.green,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Você já está logado!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  _currentUser!.email ?? _currentUser!.uid,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Sair da Conta'),
                        content: const Text('Tem certeza que deseja sair?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              await _auth.signOut();
                              if (context.mounted) {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Sair'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Sair da Conta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    // Tela de login normal
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB45309)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),

            // Ícone
            Icon(
              Icons.account_circle,
              size: 100,
              color: Colors.blue[300],
            ),
            const SizedBox(height: 40),

            // Título
            Text(
              'Faça Login',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Sincronize suas compras entre dispositivos',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Google Sign In
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _signInWithGoogle,
                icon: const Text(
                'G',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                ),
              label: const Text('Login com Google'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 15),

            // Apple Sign In (apenas iOS/macOS)
            if (Platform.isIOS || Platform.isMacOS) ...[
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _signInWithApple,
                icon: const Icon(Icons.apple),
                label: const Text('Login com Apple'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 15),
            ],

            // Facebook Login (oculto temporariamente)
            // ElevatedButton.icon(
            //   onPressed: _isLoading ? null : _signInWithFacebook,
            //   icon: const Text(
            //     'f',
            //     style: TextStyle(
            //       fontSize: 18,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   ),
            //   label: const Text('Login com Facebook'),
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(vertical: 15),
            //     backgroundColor: const Color(0xFF1877F2),
            //     foregroundColor: Colors.white,
            //   ),
            // ),
            const SizedBox(height: 30),

            // Loading Indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),

            // Error Message
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Erro: $_error',
                      style: TextStyle(
                        color: Colors.red[900],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Dica: Se você recebeu um erro do Google, verifique se o OAuth está configurado no Firebase Console.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 40),

            // Info
           
          ],
        ),
      ),
    );
  }
}

