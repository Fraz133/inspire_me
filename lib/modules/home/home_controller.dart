import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/routes.dart';
import '../../data/models/quote_model.dart';
import '../../data/repositories/quote_repository.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/sound_service.dart';
import '../../data/services/share_service.dart';
import '../../data/services/analytics_service.dart';
import '../../data/services/tts_service.dart';


class HomeController extends GetxController {
  final QuoteRepository _quoteRepository = Get.find<QuoteRepository>();
  final FavoritesRepository _favoritesRepository = Get.find<FavoritesRepository>();
  final AuthService authService = Get.find<AuthService>();
  final SoundService soundService = Get.find<SoundService>();
  final ShareService _shareService = Get.find<ShareService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();
  final TtsService ttsService = Get.find<TtsService>();

  final quotesHistory = <QuoteModel>[].obs;
  final currentIndex = 0.obs;
  final isLoading = false.obs;
  final useOnlyLocal = false.obs;
  final showSwipeGuide = false.obs;
  final onboardingStep = 0.obs; // Onboarding steps 1 to 6

  late final PageController pageController;

  // Real-time tracking of favorited quote IDs
  final favoriteIds = <String>{}.obs;
  final lastSeenFavoritesCount = 0.obs;
  StreamSubscription? _favoritesSubscription;

  void markFavoritesAsSeen() {
    lastSeenFavoritesCount.value = favoriteIds.length;
  }

  @override
  void onInit() {
    pageController = PageController();
    super.onInit();
    _analytics.logScreenView('Home Screen');
    _subscribeToFavorites();
    _checkFirstTimeLogin();
    fetchFirstQuote();
    _updateLastActiveTimestamp();
  }

  @override
  void onClose() {
    _favoritesSubscription?.cancel();
    pageController.dispose();
    ttsService.stop();
    super.onClose();
  }

  Future<void> _updateLastActiveTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_active_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (_) {}
  }

  Future<void> _checkFirstTimeLogin() async {
    try {
      final uid = authService.userId;
      if (uid == null) {
        showSwipeGuide.value = false;
        onboardingStep.value = 0;
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final hasSeen = prefs.getBool('has_seen_swipe_guide_$uid') ?? false;
      if (!hasSeen) {
        onboardingStep.value = 1;
        showSwipeGuide.value = true;
      } else {
        showSwipeGuide.value = false;
        onboardingStep.value = 0;
      }
    } catch (_) {
      showSwipeGuide.value = false;
      onboardingStep.value = 0;
    }
  }

  void nextOnboardingStep() {
    soundService.playChime();
    onboardingStep.value++;
    if (onboardingStep.value > 6) {
      dismissSwipeGuide();
    }
  }

  Future<void> dismissSwipeGuide() async {
    showSwipeGuide.value = false;
    onboardingStep.value = 0;
    soundService.playChime();
    try {
      final uid = authService.userId;
      if (uid != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('has_seen_swipe_guide_$uid', true);
      }
    } catch (_) {}
  }

  void _subscribeToFavorites() {
    _favoritesSubscription = _favoritesRepository.favoritesStream().listen((favoritesList) {
      favoriteIds.assignAll(favoritesList.map((q) => q.id).toSet());
      
      // Update favorite state for all quotes in history
      for (var i = 0; i < quotesHistory.length; i++) {
        final quote = quotesHistory[i];
        final isFav = favoriteIds.contains(quote.id);
        if (quote.isFavorite != isFav) {
          quotesHistory[i] = quote.copyWith(isFavorite: isFav);
        }
      }
    });
  }

  Future<void> fetchFirstQuote() async {
    isLoading.value = true;
    try {
      QuoteModel quote;
      if (useOnlyLocal.value) {
        quote = _quoteRepository.getLocalRandomQuote();
      } else {
        quote = await _quoteRepository.getRandomQuote();
      }
      quote.isFavorite = favoriteIds.contains(quote.id);
      quotesHistory.assign(quote);
      
      // Pre-fetch a second quote immediately
      _preFetchNextQuote();
    } catch (e) {
      final quote = _quoteRepository.getLocalRandomQuote();
      quote.isFavorite = favoriteIds.contains(quote.id);
      quotesHistory.assign(quote);
      _preFetchNextQuote();
    } finally {
      isLoading.value = false;
    }
  }

  final _isPreFetching = false.obs;

  Future<void> _preFetchNextQuote() async {
    if (_isPreFetching.value) return;
    _isPreFetching.value = true;
    try {
      final excludeIds = quotesHistory.map((q) => q.id).toList();
      final String? excludeId = excludeIds.isNotEmpty ? excludeIds.last : null;
      QuoteModel quote;
      if (useOnlyLocal.value) {
        quote = _quoteRepository.getLocalRandomQuote(excludeId: excludeId);
      } else {
        quote = await _quoteRepository.getRandomQuote(excludeId: excludeId);
      }
      quote.isFavorite = favoriteIds.contains(quote.id);
      
      if (!quotesHistory.contains(quote)) {
        quotesHistory.add(quote);
      }
    } catch (e) {
      debugPrint("Pre-fetch failed: $e");
    } finally {
      _isPreFetching.value = false;
    }
  }

  void onQuotePageChanged(int index) {
    currentIndex.value = index;
    ttsService.stop();

    if (index < quotesHistory.length) {
      final quote = quotesHistory[index];
      _analytics.logEvent(
        'view_quote',
        parameters: {
          'quote_id': quote.id,
          'author': quote.author,
        },
      );
    }

    // Pre-fetch next quote if we are on the last page of history
    if (index == quotesHistory.length - 1) {
      _preFetchNextQuote();
    }
  }

  Future<void> fetchNewQuote() async {
    soundService.playChime();
    ttsService.stop();

    if (currentIndex.value < quotesHistory.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    } else {
      isLoading.value = true;
      try {
        final excludeIds = quotesHistory.map((q) => q.id).toList();
        final String? excludeId = excludeIds.isNotEmpty ? excludeIds.last : null;
        
        QuoteModel quote;
        if (useOnlyLocal.value) {
          quote = _quoteRepository.getLocalRandomQuote(excludeId: excludeId);
        } else {
          quote = await _quoteRepository.getRandomQuote(excludeId: excludeId);
        }
        quote.isFavorite = favoriteIds.contains(quote.id);
        
        if (!quotesHistory.contains(quote)) {
          quotesHistory.add(quote);
        }
        
        WidgetsBinding.instance.addPostFrameCallback((_) {
          pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
          );
        });
      } catch (e) {
        Get.snackbar('Error', 'Could not get another quote');
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> toggleFavorite() async {
    if (quotesHistory.isEmpty) return;
    final quote = quotesHistory[currentIndex.value];
    
    soundService.playChime();

    final isCurrentlyFav = favoriteIds.contains(quote.id);
    try {
      if (isCurrentlyFav) {
        await _favoritesRepository.removeFavorite(quote.id);
        _analytics.logEvent('remove_favorite', parameters: {'quote_id': quote.id});
      } else {
        await _favoritesRepository.addFavorite(quote);
        _analytics.logEvent('add_favorite', parameters: {'quote_id': quote.id});
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not update favorite: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> shareQuote() async {
    if (quotesHistory.isEmpty) return;
    final quote = quotesHistory[currentIndex.value];

    soundService.playChime();

    await _shareService.shareQuote(quote);
    _analytics.logEvent('share_quote', parameters: {'quote_id': quote.id});
  }

  void speakCurrentQuote() {
    if (quotesHistory.isEmpty) return;
    final quote = quotesHistory[currentIndex.value];
    final readText = "${quote.text} by ${quote.author.isEmpty || quote.author == 'Unknown' ? 'an unknown author' : quote.author}";
    ttsService.speak(readText);
  }



  Future<void> logout() async {
    try {
      await authService.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('last_active_timestamp');
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar('Sign Out Failed', e.toString());
    }
  }
}
