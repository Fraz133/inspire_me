import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/routes.dart';
import '../../config/constants.dart';
import '../../data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = Get.find<AuthService>();

  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for the animation to play slightly
    await Future.delayed(const Duration(milliseconds: 2500));
    
    // Check if user is logged in
    if (_authService.isLoggedIn) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final lastActiveMs = prefs.getInt('last_active_timestamp');
        
        if (lastActiveMs != null) {
          final lastActive = DateTime.fromMillisecondsSinceEpoch(lastActiveMs);
          final diff = DateTime.now().difference(lastActive);
          
          if (diff.inDays >= 14) {
            // Expired after 14 days of inactivity
            await _authService.signOut();
            await prefs.remove('last_active_timestamp');
            Get.offAllNamed(AppRoutes.login);
            Get.snackbar(
              'Session Expired',
              'You have been logged out due to 14 days of inactivity.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange.withValues(alpha: 0.1),
              colorText: Colors.orange,
              margin: const EdgeInsets.all(16),
              borderRadius: 12,
            );
            return;
          }
        }
        
        // Not expired, refresh the active timestamp and go home
        await prefs.setInt('last_active_timestamp', DateTime.now().millisecondsSinceEpoch);
        Get.offAllNamed(AppRoutes.home);
      } catch (e) {
        // Fallback in case of error: allow login and proceed
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [AppColors.darkBg1, AppColors.darkBg2]
                : [AppColors.lightBg1, AppColors.lightBg2],
          ),
        ),
        child: Stack(
          children: [
            // Background ambient glow circles
            Positioned(
              top: -100,
              right: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                      .withValues(alpha: 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark ? AppColors.darkAccent2 : AppColors.lightAccent2)
                      .withValues(alpha: 0.12),
                ),
              ),
            ),
            // Center Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text Logo "inspire."
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: isDark
                          ? [AppColors.darkAccent, AppColors.darkAccent2]
                          : [AppColors.lightAccent, AppColors.lightAccent2],
                    ).createShader(bounds),
                    child: Text(
                      'inspire.',
                      style: GoogleFonts.poppins(
                        fontSize: 64,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2.5,
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        duration: 1000.ms,
                        curve: Curves.fastOutSlowIn,
                      )
                      .fadeIn(duration: 800.ms)
                      .then()
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(
                        duration: 2500.ms,
                        begin: const Offset(1, 1),
                        end: const Offset(1.05, 1.05),
                        curve: Curves.easeInOut,
                      ),
                  const SizedBox(height: 12),
                  // Subtitle
                  Text(
                    'Your Daily Dose of Motivation',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                      letterSpacing: 0.5,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 600.ms)
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
                ],
              ),
            ),
            // Modern capsule loading indicator at bottom
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 140,
                  height: 4,
                  decoration: BoxDecoration(
                    color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? AppColors.darkAccent2 : AppColors.lightAccent,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms, duration: 500.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
            ),
          ],
        ),
      ),
    );
  }
}
