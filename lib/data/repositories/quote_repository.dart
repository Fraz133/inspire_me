import 'dart:math';
import 'package:get/get.dart';
import '../models/quote_model.dart';
import '../providers/quote_provider.dart';
import '../providers/api_provider.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';

class QuoteRepository {
  final ApiProvider _apiProvider = ApiProvider();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final Random _random = Random();

  Future<QuoteModel> getRandomQuote({String? excludeId}) async {
    // 50% chance to fetch from user uploads in Firestore, if online
    final tryFirestore = _random.nextBool();
    if (tryFirestore) {
      try {
        final firestoreQuotes = await _firestoreService.getQuotes();
        if (firestoreQuotes.isNotEmpty) {
          final currentUserId = Get.find<AuthService>().userId;
          final pool = firestoreQuotes.where((q) {
            final isNotExcluded = q.id != excludeId;
            final isNotMine = q.uploadedBy != currentUserId;
            return isNotExcluded && isNotMine;
          }).toList();
          if (pool.isNotEmpty) {
            pool.shuffle();
            return pool.first;
          }
        }
      } catch (_) {
        // Fallback silently if offline or Firestore query errors
      }
    }

    // Try ZenQuotes API
    try {
      final apiQuote = await _apiProvider.fetchRandomQuote();
      if (apiQuote != null && apiQuote.text.isNotEmpty && apiQuote.id != excludeId) {
        return apiQuote;
      }
    } catch (_) {}

    // Fallback to local quotes database
    return QuoteProvider.getRandomQuote(excludeId: excludeId);
  }

  QuoteModel getLocalRandomQuote({String? excludeId}) {
    return QuoteProvider.getRandomQuote(excludeId: excludeId);
  }
}
