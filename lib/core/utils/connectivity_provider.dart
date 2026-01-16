import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'connectivity_helper.dart';

class ConnectivityNotifier extends StateNotifier<bool> {
  // Default to online to avoid showing "sem conexão" by default while checking
  ConnectivityNotifier() : super(true) {
    // initial check
    check();
  }

  Future<void> check() async {
    final online = await isOnlineNow().catchError((_) => false);
    state = online;
  }
}

final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});
