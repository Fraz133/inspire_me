import 'package:get/get.dart';
import '../data/services/auth_service.dart';
import '../data/services/firestore_service.dart';
import '../data/services/analytics_service.dart';
import '../data/services/sound_service.dart';
import '../data/services/share_service.dart';
import '../data/services/tts_service.dart';
import '../data/repositories/quote_repository.dart';
import '../data/repositories/favorites_repository.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<FirestoreService>(() => FirestoreService(), fenix: true);
    Get.lazyPut<AnalyticsService>(() => AnalyticsService(), fenix: true);
    Get.lazyPut<SoundService>(() => SoundService(), fenix: true);
    Get.lazyPut<ShareService>(() => ShareService(), fenix: true);
    Get.lazyPut<TtsService>(() => TtsService(), fenix: true);

    // Repositories
    Get.lazyPut<QuoteRepository>(() => QuoteRepository(), fenix: true);
    Get.lazyPut<FavoritesRepository>(() => FavoritesRepository(), fenix: true);
  }
}
