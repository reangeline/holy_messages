import 'package:http/http.dart' as http;

/// Perform a fresh quick connectivity check.
Future<bool> isOnlineNow({Duration timeout = const Duration(seconds: 2)}) async {
  try {
    final uri = Uri.parse('https://clients3.google.com/generate_204');
    final resp = await http.get(uri).timeout(timeout);
    return resp.statusCode == 204 || resp.statusCode == 200;
  } catch (_) {
    return false;
  }
}
