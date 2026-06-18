import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/quote_model.dart';

class FirestoreService extends GetxService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Quotes ───
  CollectionReference get _quotesRef => _db.collection('quotes');

  Future<void> addQuote(QuoteModel quote) async {
    await _quotesRef.doc(quote.id).set(quote.toMap());
  }

  Future<List<QuoteModel>> getQuotes() async {
    final snapshot = await _quotesRef.get();
    return snapshot.docs
        .map((doc) => QuoteModel.fromMap(doc.data() as Map<String, dynamic>, docId: doc.id))
        .toList();
  }

  Future<List<QuoteModel>> getUserQuotes(String userId) async {
    final snapshot = await _quotesRef.where('uploadedBy', isEqualTo: userId).get();
    return snapshot.docs
        .map((doc) => QuoteModel.fromMap(doc.data() as Map<String, dynamic>, docId: doc.id))
        .toList();
  }

  Future<void> deleteQuote(String quoteId) async {
    await _quotesRef.doc(quoteId).delete();
  }

  // ─── Favorites ───
  CollectionReference _favoritesRef(String userId) =>
      _db.collection('users').doc(userId).collection('favorites');

  Future<void> addFavorite(String userId, QuoteModel quote) async {
    await _favoritesRef(userId).doc(quote.id).set(quote.toMap());
  }

  Future<void> removeFavorite(String userId, String quoteId) async {
    await _favoritesRef(userId).doc(quoteId).delete();
  }

  Stream<List<QuoteModel>> favoritesStream(String userId) {
    return _favoritesRef(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => QuoteModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  docId: doc.id,
                ).copyWith(isFavorite: true))
            .toList());
  }

  Future<List<QuoteModel>> getFavorites(String userId) async {
    final snapshot = await _favoritesRef(userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => QuoteModel.fromMap(
              doc.data() as Map<String, dynamic>,
              docId: doc.id,
            ).copyWith(isFavorite: true))
        .toList();
  }

  Future<bool> isFavorite(String userId, String quoteId) async {
    final doc = await _favoritesRef(userId).doc(quoteId).get();
    return doc.exists;
  }

  Future<Set<String>> getFavoriteIds(String userId) async {
    final snapshot = await _favoritesRef(userId).get();
    return snapshot.docs.map((doc) => doc.id).toSet();
  }
}
