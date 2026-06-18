import 'package:get/get.dart';
import '../../data/models/quote_model.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/services/share_service.dart';
import '../../data/services/analytics_service.dart';
import '../../data/services/sound_service.dart';

class FavoritesController extends GetxController {
  final FavoritesRepository _favoritesRepository = Get.find<FavoritesRepository>();
  final ShareService _shareService = Get.find<ShareService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final SoundService _soundService = Get.find<SoundService>();

  final favorites = <QuoteModel>[].obs;
  final filteredFavorites = <QuoteModel>[].obs;
  final isLoading = true.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _analytics.logScreenView('Favorites Screen');
    _listenToFavorites();
  }

  void _listenToFavorites() {
    favorites.bindStream(_favoritesRepository.favoritesStream());
    
    // Automatically apply search filter when favorites list or search query changes
    everAll([favorites, searchQuery], (_) {
      _applyFilter();
    });
    
    // Bind stream takes care of loading state after first emit
    favorites.listen((list) {
      isLoading.value = false;
    });
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }

  void _applyFilter() {
    if (searchQuery.isEmpty) {
      filteredFavorites.assignAll(favorites);
    } else {
      filteredFavorites.assignAll(
        favorites.where((quote) {
          final text = quote.text.toLowerCase();
          final author = quote.author.toLowerCase();
          return text.contains(searchQuery.value) || author.contains(searchQuery.value);
        }).toList(),
      );
    }
  }

  Future<void> removeFavorite(String quoteId) async {
    _soundService.playChime();
    try {
      await _favoritesRepository.removeFavorite(quoteId);
      _analytics.logEvent('remove_favorite_list', parameters: {'quote_id': quoteId});
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove from favorites.');
    }
  }

  Future<void> shareQuote(QuoteModel quote) async {
    _soundService.playChime();
    await _shareService.shareQuote(quote);
    _analytics.logEvent('share_favorite_quote', parameters: {'quote_id': quote.id});
  }
}
