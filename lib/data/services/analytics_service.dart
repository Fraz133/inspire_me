import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

class AnalyticsService extends GetxService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  Future<void> logQuoteViewed(String quoteId, String author) async {
    await _analytics.logEvent(
      name: 'quote_viewed',
      parameters: {
        'quote_id': quoteId,
        'author': author,
      },
    );
  }

  Future<void> logQuoteFavorited(String quoteId, String author) async {
    await _analytics.logEvent(
      name: 'quote_favorited',
      parameters: {
        'quote_id': quoteId,
        'author': author,
      },
    );
  }

  Future<void> logQuoteUnfavorited(String quoteId) async {
    await _analytics.logEvent(
      name: 'quote_unfavorited',
      parameters: {
        'quote_id': quoteId,
      },
    );
  }

  Future<void> logQuoteShared(String quoteId, String author) async {
    await _analytics.logEvent(
      name: 'quote_shared',
      parameters: {
        'quote_id': quoteId,
        'author': author,
      },
    );
  }

  Future<void> logThemeChanged(bool isDark) async {
    await _analytics.logEvent(
      name: 'theme_changed',
      parameters: {
        'theme': isDark ? 'dark' : 'light',
      },
    );
  }

  Future<void> logInspireButtonTapped() async {
    await _analytics.logEvent(name: 'inspire_button_tapped');
  }

  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);
  }
}
