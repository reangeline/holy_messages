import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/favorite.dart' show Favorite;

final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<Favorite>>(() => FavoritesNotifier());

class FavoritesNotifier extends AsyncNotifier<List<Favorite>> {
  Box<Favorite>? _box;

  @override
  FutureOr<List<Favorite>> build() async {
    _box = await Hive.openBox<Favorite>('favorites');
    return _box!.values.cast<Favorite>().toList();
  }

  /// Adiciona um favorito com limite de 5 para não-premium
  /// Retorna true se adicionado, false se atingiu o limite
  Future<bool> addFavorite(Favorite fav, {bool isPremium = false}) async {
    final currentCount = _box?.values.length ?? 0;
    
    // Se não é premium e já tem 5 favoritos, não permite
    if (!isPremium && currentCount >= 5) {
      return false;
    }
    
    state = const AsyncValue.loading();
    await _box!.put(fav.id, fav);
    state = AsyncValue.data(_box!.values.cast<Favorite>().toList());
    return true;
  }

  Future<void> removeFavorite(String id) async {
    state = const AsyncValue.loading();
    await _box!.delete(id);
    state = AsyncValue.data(_box!.values.cast<Favorite>().toList());
  }

  bool containsMessage(String messageId) {
    return _box?.values.cast<Favorite>().any((f) => f.messageId == messageId) ?? false;
  }

  Favorite? favoriteByMessage(String messageId) {
    try {
      return _box!.values.cast<Favorite>().firstWhere((f) => f.messageId == messageId);
    } catch (_) {
      return null;
    }
  }
}
