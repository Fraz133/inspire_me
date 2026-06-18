import 'package:get/get.dart';
import '../models/quote_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class FavoritesRepository {
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final AuthService _authService = Get.find<AuthService>();

  String? get _userId => _authService.userId;

  Future<void> addFavorite(QuoteModel quote) async {
    if (_userId != null) {
      await _firestoreService.addFavorite(_userId!, quote);
    }
  }

  Future<void> removeFavorite(String quoteId) async {
    if (_userId != null) {
      await _firestoreService.removeFavorite(_userId!, quoteId);
    }
  }

  Stream<List<QuoteModel>> favoritesStream() {
    if (_userId != null) {
      return _firestoreService.favoritesStream(_userId!);
    }
    return Stream.value([]);
  }

  Future<List<QuoteModel>> getFavorites() async {
    if (_userId != null) {
      return await _firestoreService.getFavorites(_userId!);
    }
    return [];
  }

  Future<bool> isFavorite(String quoteId) async {
    if (_userId != null) {
      return await _firestoreService.isFavorite(_userId!, quoteId);
    }
    return false;
  }

  Future<Set<String>> getFavoriteIds() async {
    if (_userId != null) {
      return await _firestoreService.getFavoriteIds(_userId!);
    }
    return {};
  }
}
