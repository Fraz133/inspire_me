import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/routes.dart';
import '../../data/models/quote_model.dart';
import '../../config/constants.dart';
import '../../config/theme/app_theme.dart';
import '../../config/theme/theme_controller.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final themeController = Get.find<ThemeController>();
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [themeColors.bgStart!, themeColors.bgEnd!],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Glowing Ambient circles (background)
              Positioned(
                top: -80,
                left: -40,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColors.accentAlphaLow,
                  ),
                ),
              ),
              Positioned(
                bottom: 120,
                right: -80,
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColors.accent2AlphaLow,
                  ),
                ),
              ),

              // Main Body Layout
              Column(
                children: [
                  // Beautiful Custom AppBar
                  _buildCustomAppBar(context, controller, themeController),

                  // Middle Quote Space (PageView for Swiping)
                  Expanded(
                    child: Center(
                      child: Obx(() {
                        if (controller.isLoading.value && controller.quotesHistory.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: _buildLoadingQuoteCard(context, isDark),
                          );
                        }

                        if (controller.quotesHistory.isEmpty) {
                          return const Text('Click below to get inspired!')
                              .animate()
                              .fadeIn();
                        }

                        return PageView.builder(
                          controller: controller.pageController,
                          itemCount: controller.quotesHistory.length,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: controller.onQuotePageChanged,
                          itemBuilder: (context, index) {
                            final quote = controller.quotesHistory[index];
                            final isFav = controller.favoriteIds.contains(quote.id);
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Center(
                                child: _buildQuoteCard(context, controller, quote, isFav, isDark),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),

                  // Bottom Action Section
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Toggle for API vs. Local Quotes
                        Obx(() => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                              decoration: BoxDecoration(
                                color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.06),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    controller.useOnlyLocal.value
                                        ? Icons.cloud_off_rounded
                                        : Icons.cloud_queue_rounded,
                                    size: 16,
                                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.useOnlyLocal.value ? 'Offline Mode' : 'Online Mode',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Switch(
                                    value: controller.useOnlyLocal.value,
                                    activeThumbColor: themeColors.speakIconActiveColor,
                                    onChanged: (val) => controller.useOnlyLocal.value = val,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 24),

                        // "Inspire Me" main button with gradient (No icon)
                        Obx(() => GestureDetector(
                              onTap: controller.isLoading.value
                                  ? null
                                  : () => controller.fetchNewQuote(),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                height: 64,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    colors: themeColors.accentGradient!,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: themeColors.accent1!
                                          .withValues(alpha: isDark ? 0.35 : 0.25),
                                      blurRadius: controller.isLoading.value ? 8 : 20,
                                      offset: controller.isLoading.value
                                          ? const Offset(0, 3)
                                          : const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          'Inspire Me',
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            )).animate(target: controller.isLoading.value ? 0.96 : 1.0)
                             .scale(duration: 150.ms, curve: Curves.easeOutCubic),
                      ],
                    ),
                  ),
                ],
              ),
              // Swipe Guide Tutorial Overlay
              Obx(() {
                if (controller.showSwipeGuide.value) {
                  return _buildSwipeTutorialOverlay(context, controller);
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context, HomeController controller, ThemeController themeController) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: User Profile Button
          Obx(() {
            final user = controller.authService.currentUser.value;
            final name = user?.displayName ?? 'User';
            final photoUrl = user?.photoURL;
            final localPhoto = controller.authService.userPhotoBase64.value;
            
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.profile),
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColors.text!.withValues(alpha: 0.05),
                ),
                child: ClipOval(
                  child: localPhoto.isNotEmpty
                      ? Image.memory(
                          base64Decode(localPhoto),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.person_outline_rounded,
                            color: themeColors.text,
                            size: 20,
                          ),
                        )
                      : (photoUrl != null
                          ? Image.network(
                              photoUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.person_outline_rounded,
                                color: themeColors.text,
                                size: 20,
                              ),
                            )
                          : Center(
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                style: TextStyle(
                                  color: themeColors.speakIconActiveColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            )),
                ),
              ),
            );
          }),

          // Title
          Text(
            'InspireMe',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),

          // Right side: Theme switch and Favorites button
          Row(
            children: [
              // Sound toggle button
              Obx(() => IconButton(
                    icon: Icon(
                      controller.soundService.isSoundEnabled.value
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      color: themeColors.text,
                    ),
                    onPressed: () {
                      controller.soundService.toggleSound();
                      Get.snackbar(
                        controller.soundService.isSoundEnabled.value ? 'Sound On' : 'Sound Muted',
                        controller.soundService.isSoundEnabled.value ? 'Sound effects enabled' : 'Sound effects muted',
                        snackPosition: SnackPosition.BOTTOM,
                        duration: const Duration(seconds: 1),
                        backgroundColor: themeColors.cardBg!.withValues(alpha: 0.85),
                        colorText: themeColors.text,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    },
                  )),

              const SizedBox(width: 4),

              // Theme switcher
              Obx(() => IconButton(
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => RotationTransition(
                        turns: anim,
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: Icon(
                        themeController.isDarkMode.value
                            ? Icons.wb_sunny_outlined
                            : Icons.nightlight_outlined,
                        key: ValueKey(themeController.isDarkMode.value),
                        color: themeColors.text,
                      ),
                    ),
                    onPressed: themeController.toggleTheme,
                  )),

              const SizedBox(width: 8),

              // Favorites screen button
              Stack(
                children: [
                  IconButton(
                    icon: Hero(
                      tag: 'favorites_icon',
                      child: Icon(
                        Icons.favorite_border_rounded,
                        color: themeColors.text,
                      ),
                    ),
                    onPressed: () {
                      controller.markFavoritesAsSeen();
                      Get.toNamed(AppRoutes.favorites);
                    },
                  ),
                  Obx(() {
                    final unseenCount = controller.favoriteIds.length - controller.lastSeenFavoritesCount.value;
                    if (unseenCount <= 0) return const SizedBox.shrink();
                    return Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: themeColors.speakIconActiveColor,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '$unseenCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }






  Widget _buildQuoteCard(
      BuildContext context, HomeController controller, QuoteModel quote, bool isFav, bool isDark) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          decoration: BoxDecoration(
            color: themeColors.cardBg,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: themeColors.cardBorder!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quote Mark Icon
              Icon(
                Icons.format_quote_rounded,
                size: 48,
                color: themeColors.quoteMarkColor,
              ),
              const SizedBox(height: 16),

              // Quote Text
              Text(
                quote.text,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  height: 1.4,
                  fontSize: quote.text.length > 100 ? 20 : 24,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Quote Author
              Text(
                '— ${quote.author.isEmpty ? "Unknown" : quote.author}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.textTheme.titleMedium?.color?.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // Actions inside Card: Share, Speak, & Love
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Share button
                  _buildCardActionButton(
                    icon: Icons.share_rounded,
                    color: themeColors.text?.withValues(alpha: 0.6),
                    onTap: () => controller.shareQuote(),
                  ),
                  const SizedBox(width: 24),
                  // Voice Speak button
                  Obx(() {
                    final isSpeaking = controller.ttsService.isSpeaking.value;
                    final isThisQuoteSpeaking = isSpeaking &&
                        controller.quotesHistory.isNotEmpty &&
                        controller.quotesHistory[controller.currentIndex.value].id == quote.id;
                    return _buildCardActionButton(
                      icon: isThisQuoteSpeaking
                          ? Icons.stop_circle_outlined
                          : Icons.volume_up_rounded,
                      color: isThisQuoteSpeaking
                          ? themeColors.speakIconActiveColor
                          : themeColors.text?.withValues(alpha: 0.6),
                      onTap: () => controller.speakCurrentQuote(),
                    );
                  }),
                  const SizedBox(width: 24),
                  // Favorite button
                  _buildCardActionButton(
                    icon: isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                    color: isFav
                        ? Colors.redAccent
                        : themeColors.text?.withValues(alpha: 0.6),
                    onTap: () => controller.toggleFavorite(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardActionButton({
    required IconData icon,
    required Color? color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color!.withValues(alpha: 0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildLoadingQuoteCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;
    final baseColor = themeColors.text!.withValues(alpha: 0.15);
    final highlightColor = themeColors.text!.withValues(alpha: 0.05);

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
          decoration: BoxDecoration(
            color: themeColors.cardBg,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: themeColors.cardBorder!,
              width: 1.5,
            ),
          ),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quote Mark Icon Placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: baseColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(height: 24),

                // Quote Text Placeholder lines
                Container(
                  width: double.infinity,
                  height: 18,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 18,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 150,
                  height: 18,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 32),

                // Author Placeholder
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: baseColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeTutorialOverlay(BuildContext context, HomeController controller) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;
    final themeController = Get.find<ThemeController>();
    final step = controller.onboardingStep.value;

    if (step == 0) return const SizedBox.shrink();

    double? arrowTop;
    double? arrowBottom;
    double? arrowLeft;
    double? arrowRight;
    bool isArrowUp = true;
    String title = '';
    String description = '';

    switch (step) {
      case 1:
        // Inspire Me Button (bottom center)
        arrowBottom = 112;
        arrowLeft = 0;
        arrowRight = 0;
        isArrowUp = false;
        title = 'Inspire Me';
        description = 'Tap here to get a brand new motivational quote instantly, accompanied by a soothing chime sound!';
        break;
      case 2:
        // Sound Switcher (top right, first icon)
        arrowTop = 56;
        arrowRight = 104;
        isArrowUp = true;
        title = 'Sound Controls';
        description = 'Enable or mute interactive sound effects according to your preference.';
        break;
      case 3:
        // Theme Switcher (top right, second icon)
        arrowTop = 56;
        arrowRight = 58;
        isArrowUp = true;
        title = 'Day/Night Theme';
        description = 'Toggle between vibrant light mode and relaxing dark mode.';
        break;
      case 4:
        // Favorites Screen Button (top right, third icon)
        arrowTop = 56;
        arrowRight = 12;
        isArrowUp = true;
        title = 'My Favorites';
        description = 'View all your saved quotes here. They sync with Firestore automatically!';
        break;
      case 5:
        // Profile & Upload Button (top left)
        arrowTop = 56;
        arrowLeft = 20;
        isArrowUp = true;
        title = 'Profile & Settings';
        description = 'Click here to update your display name, upload gallery profile photos, or share your own quotes!';
        break;
      case 6:
        // Quote Card Swipe Gesture
        title = 'Swipe Card Gestures';
        description = 'You can also swipe quotes left/right to browse! Swipe back to read previous quotes in your history stack.';
        break;
    }

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
        child: Container(
          color: Colors.black.withValues(alpha: 0.6),
          child: Stack(
            children: [
              // Highlighted AppBar elements (Steps 2 to 5)
              if (step >= 2 && step <= 5)
                _buildHighlightedAppBar(context, controller, themeController, step),

              // Highlighted Main Action Button (Step 1)
              if (step == 1)
                Positioned(
                  bottom: 40,
                  left: 24,
                  right: 24,
                  child: IgnorePointer(
                    child: Container(
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          colors: themeColors.accentGradient!,
                        ),
                        border: Border.all(
                          color: themeColors.speakIconActiveColor!,
                          width: 2.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: themeColors.accent1!.withValues(alpha: 0.45),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'Inspire Me',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Bouncing Arrow Pointer (Steps 1 to 5)
              if (step >= 1 && step <= 5)
                Positioned(
                  top: arrowTop,
                  bottom: arrowBottom,
                  left: arrowLeft,
                  right: arrowRight,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isArrowUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                          size: 44,
                          color: themeColors.speakIconActiveColor,
                        )
                        .animate(onPlay: (animController) => animController.repeat(reverse: true))
                        .move(begin: const Offset(0, -8), end: const Offset(0, 8), duration: 600.ms, curve: Curves.easeInOut),
                      ],
                    ),
                  ),
                ),

              // Sliding Hand Gesture (Step 6)
              if (step == 6)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.swipe_right_rounded,
                        size: 80,
                        color: Colors.white,
                      )
                      .animate(onPlay: (animController) => animController.repeat(reverse: true))
                      .slideX(begin: -0.35, end: 0.35, duration: 1200.ms, curve: Curves.easeInOut)
                      .fadeIn(duration: 400.ms),
                    ),
                  ),
                ),

              // Tooltip Card (Aligned in center, slightly shifted to avoid overlap)
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Container(
                      margin: EdgeInsets.only(
                        top: (step >= 2 && step <= 5) ? 140 : 0,
                        bottom: (step == 1) ? 140 : 0,
                      ),
                      padding: const EdgeInsets.all(24.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[900]!.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Step Indicator
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: themeColors.speakIconActiveColor!.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Step $step of 6',
                              style: TextStyle(
                                color: themeColors.speakIconActiveColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Tooltip Title
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          
                          // Tooltip Description
                          Text(
                            description,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.75),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 28),
                          
                          // Buttons Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Skip button
                              TextButton(
                                onPressed: controller.dismissSwipeGuide,
                                child: Text(
                                  'Skip Tour',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.45),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              
                              // Next / Finish button
                              GestureDetector(
                                onTap: controller.nextOnboardingStep,
                                child: Container(
                                  height: 44,
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    gradient: LinearGradient(
                                      colors: themeColors.accentGradient!,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      step == 6 ? 'Get Started' : 'Next',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to overlay and highlight the exact AppBar item corresponding to the active step
  Widget _buildHighlightedAppBar(BuildContext context, HomeController controller, ThemeController themeController, int step) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: User Profile Button (Visible only in Step 5)
          Opacity(
            opacity: step == 5 ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: step != 5,
              child: Obx(() {
                final user = controller.authService.currentUser.value;
                final name = user?.displayName ?? 'User';
                final localPhoto = controller.authService.userPhotoBase64.value;
                final photoUrl = user?.photoURL;
                return Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColors.text!.withValues(alpha: 0.05),
                    border: Border.all(
                      color: themeColors.speakIconActiveColor!,
                      width: 2.0,
                    ),
                  ),
                  child: ClipOval(
                    child: localPhoto.isNotEmpty
                        ? Image.memory(
                            base64Decode(localPhoto),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : (photoUrl != null
                            ? Image.network(
                                photoUrl,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                  style: TextStyle(
                                    color: themeColors.speakIconActiveColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              )),
                  ),
                );
              }),
            ),
          ),

          // Middle Title (Invisible, but keeps AppBar buttons spaced correctly)
          Opacity(
            opacity: 0.0,
            child: Text(
              'InspireMe',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Right side: Theme switch and Favorites button
          Row(
            children: [
              // Sound toggle button (Visible only in Step 2)
              Opacity(
                opacity: step == 2 ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: step != 2,
                  child: Obx(() => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkAccent2 : AppColors.lightAccent,
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        controller.soundService.isSoundEnabled.value
                            ? Icons.volume_up_rounded
                            : Icons.volume_off_rounded,
                        color: themeColors.speakIconActiveColor,
                      ),
                      onPressed: null,
                    ),
                  )),
                ),
              ),

              const SizedBox(width: 4),

              // Theme switcher (Visible only in Step 3)
              Opacity(
                opacity: step == 3 ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: step != 3,
                  child: Obx(() => Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkAccent2 : AppColors.lightAccent,
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        themeController.isDarkMode.value
                            ? Icons.wb_sunny_outlined
                            : Icons.nightlight_outlined,
                        color: themeColors.speakIconActiveColor,
                      ),
                      onPressed: null,
                    ),
                  )),
                ),
              ),

              const SizedBox(width: 8),

              // Favorites screen button (Visible only in Step 4)
              Opacity(
                opacity: step == 4 ? 1.0 : 0.0,
                child: IgnorePointer(
                  ignoring: step != 4,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkAccent2 : AppColors.lightAccent,
                        width: 1.5,
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.favorite_border_rounded,
                        color: themeColors.speakIconActiveColor,
                      ),
                      onPressed: null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
