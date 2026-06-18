import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isObscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    _analytics.logScreenView('Login Screen');
  }



  void togglePasswordVisibility() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  Future<void> loginWithEmail() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final user = await _authService.signInWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('last_active_timestamp', DateTime.now().millisecondsSinceEpoch);
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithGoogle() async {
    isLoading.value = true;
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('last_active_timestamp', DateTime.now().millisecondsSinceEpoch);
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar(
        'Google Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
