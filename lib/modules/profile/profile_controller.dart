import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/routes.dart';
import '../../data/models/quote_model.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/firestore_service.dart';
import '../../data/services/sound_service.dart';
import '../../data/services/analytics_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final SoundService _soundService = Get.find<SoundService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  final userQuotes = <QuoteModel>[].obs;
  final isLoadingQuotes = false.obs;
  final isSavingProfile = false.obs;
  final isSubmittingQuote = false.obs;

  // Form controllers
  late TextEditingController nameController;
  late TextEditingController quoteTextController;
  late TextEditingController quoteAuthorController;

  final quoteFormKey = GlobalKey<FormState>();
  final profileFormKey = GlobalKey<FormState>();

  final profilePictureUrl = ''.obs;

  User? get currentUser => _authService.currentUser.value;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: currentUser?.displayName ?? '');
    quoteTextController = TextEditingController();
    quoteAuthorController = TextEditingController();

    // Check if we have a locally stored Base64 photo, else default to Auth URL
    final localPhoto = _authService.userPhotoBase64.value;
    profilePictureUrl.value = localPhoto.isNotEmpty ? localPhoto : (currentUser?.photoURL ?? '');

    // Keep profile picture updated when auth cache changes
    ever(_authService.userPhotoBase64, (val) {
      profilePictureUrl.value = val.isNotEmpty ? val : (currentUser?.photoURL ?? '');
    });
    
    _analytics.logScreenView('Profile Screen');
    fetchUserQuotes();
  }

  @override
  void onClose() {
    nameController.dispose();
    quoteTextController.dispose();
    quoteAuthorController.dispose();
    super.onClose();
  }

  Future<void> fetchUserQuotes() async {
    final uid = _authService.userId;
    if (uid == null) return;

    isLoadingQuotes.value = true;
    try {
      final quotes = await _firestoreService.getUserQuotes(uid);
      quotes.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
      userQuotes.assignAll(quotes);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not load your quotes: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingQuotes.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (!profileFormKey.currentState!.validate()) return;

    _soundService.playChime();
    isSavingProfile.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final newName = nameController.text.trim();

        await user.updateDisplayName(newName);
        await user.reload();

        _authService.currentUser.value = FirebaseAuth.instance.currentUser;

        _analytics.logEvent('profile_updated');

        Get.snackbar(
          'Success',
          'Display name updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Update Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSavingProfile.value = false;
    }
  }

  Future<void> uploadCustomQuote() async {
    if (!quoteFormKey.currentState!.validate()) return;

    final uid = _authService.userId;
    if (uid == null) return;

    _soundService.playChime();
    isSubmittingQuote.value = true;

    final text = quoteTextController.text.trim();
    final author = quoteAuthorController.text.trim();

    try {
      final docId = FirebaseFirestore.instance.collection('quotes').doc().id;
      final quote = QuoteModel(
        id: docId,
        text: text,
        author: author.isEmpty ? 'Anonymous' : author,
        createdAt: DateTime.now(),
        uploadedBy: uid,
        isFavorite: false,
      );

      await _firestoreService.addQuote(quote).timeout(const Duration(seconds: 8));

      _analytics.logEvent('profile_quote_uploaded', parameters: {
        'quote_id': docId,
        'author': quote.author,
      });

      userQuotes.insert(0, quote);

      quoteTextController.clear();
      quoteAuthorController.clear();

      Get.snackbar(
        'Quote Uploaded!',
        'Your quote is now active in Firestore for other users to discover!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Upload Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isSubmittingQuote.value = false;
    }
  }

  Future<void> deleteUserQuote(String quoteId) async {
    _soundService.playChime();
    try {
      await _firestoreService.deleteQuote(quoteId);
      
      _analytics.logEvent('profile_quote_deleted', parameters: {
        'quote_id': quoteId,
      });

      userQuotes.removeWhere((q) => q.id == quoteId);

      Get.snackbar(
        'Success',
        'Quote deleted successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withValues(alpha: 0.1),
        colorText: Colors.green,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not delete quote: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  void logout() {
    _soundService.playChime();
    _authService.signOut();
    Get.offAllNamed(AppRoutes.login);
  }
}
