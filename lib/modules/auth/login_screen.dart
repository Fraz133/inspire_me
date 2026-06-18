import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/routes.dart';
import '../../app/widgets/google_logo.dart';
import '../../config/constants.dart';
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LoginController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Base Ambient Gradient Background
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [AppColors.darkBg1, AppColors.darkBg2]
                    : [AppColors.lightBg1, AppColors.lightBg2],
              ),
            ),
          ),
          
          // Glowing Ambient Blob 1 (Top-Left)
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                    .withValues(alpha: isDark ? 0.22 : 0.25),
              ),
            ),
          ),
          
          // Glowing Ambient Blob 2 (Middle-Right)
          Positioned(
            bottom: 180,
            right: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark ? AppColors.darkAccent2 : AppColors.lightAccent2)
                    .withValues(alpha: isDark ? 0.18 : 0.2),
              ),
            ),
          ),
          
          // Blur Filter to smooth out ambient blobs
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
              child: const SizedBox.shrink(),
            ),
          ),
          
          // Screen Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      
                      // Text Logo "inspire."
                      Center(
                        child: ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: isDark
                                ? [AppColors.darkAccent, AppColors.darkAccent2]
                                : [AppColors.lightAccent, AppColors.lightAccent2],
                          ).createShader(bounds),
                          child: Text(
                            'inspire.',
                            style: GoogleFonts.poppins(
                              fontSize: 42,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1.5,
                            ),
                          ),
                        ),
                      ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack).fadeIn(),
                      
                      const SizedBox(height: 36),
                      
                      // Welcome Text
                      Text(
                        'Welcome Back',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 8),
                      
                      Text(
                        'Log in to sync your favorites and get inspired.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                        ),
                      ).animate().fadeIn(delay: 100.ms, duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 48),

                      // Email Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email Address',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              hintText: 'name@example.com',
                              prefixIcon: const Icon(Icons.email_outlined),
                              filled: true,
                              fillColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: isDark ? AppColors.darkAccent2 : AppColors.lightAccent,
                                  width: 1.8,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.redAccent.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                  width: 1.8,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                              }
                              if (!GetUtils.isEmail(value)) {
                                  return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ).animate().fadeIn(delay: 200.ms, duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 24),

                      // Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(() => TextFormField(
                            controller: controller.passwordController,
                            obscureText: controller.isObscurePassword.value,
                            textInputAction: TextInputAction.done,
                            style: theme.textTheme.bodyLarge,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isObscurePassword.value
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                              filled: true,
                              fillColor: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: isDark ? AppColors.darkAccent2 : AppColors.lightAccent,
                                  width: 1.8,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.redAccent.withValues(alpha: 0.5),
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: Colors.redAccent,
                                  width: 1.8,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => controller.loginWithEmail(),
                          )),
                        ],
                      ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 36),

                      // Premium Gradient Log In Button
                      Obx(() => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.loginWithEmail(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 58,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: LinearGradient(
                              colors: isDark
                                  ? [AppColors.darkAccent, AppColors.darkAccent2]
                                  : [AppColors.lightAccent, AppColors.lightAccent2],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                                    .withValues(alpha: isDark ? 0.35 : 0.25),
                                blurRadius: controller.isLoading.value ? 6 : 16,
                                offset: controller.isLoading.value
                                    ? const Offset(0, 2)
                                    : const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: controller.isLoading.value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Log In',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      )).animate().fadeIn(delay: 400.ms, duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 28),

                      // OR Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                              thickness: 1.2,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'OR',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                              thickness: 1.2,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 500.ms, duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 28),

                      // Google Login Button (Glassmorphic)
                      Obx(() => GestureDetector(
                        onTap: controller.isLoading.value
                            ? null
                            : () => controller.loginWithGoogle(),
                        child: Container(
                          height: 58,
                          decoration: BoxDecoration(
                            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.03),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const GoogleLogoWidget(size: 22),
                              const SizedBox(width: 12),
                              Text(
                                'Continue with Google',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                      const SizedBox(height: 48),

                      // Go to Signup
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Get.toNamed(AppRoutes.signup),
                            child: Text(
                              'Sign Up',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.darkAccent2 : AppColors.lightAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fadeIn(delay: 700.ms, duration: 500.ms).slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
