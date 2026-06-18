import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/analytics_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final AnalyticsService _analytics = Get.find<AnalyticsService>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isObscurePassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    _analytics.logScreenView('Signup Screen');
  }



  void togglePasswordVisibility() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final user = await _authService.signUpWithEmail(
        emailController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
      );

      if (user != null) {
        await _authService.signOut();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('last_active_timestamp', DateTime.now().millisecondsSinceEpoch);
        Get.offAllNamed(AppRoutes.login);
        Get.snackbar(
          'Account Created',
          'Your account has been created successfully. Please log in with your credentials.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
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
