import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../config/constants.dart';
import '../../config/theme/app_theme.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: themeColors.text),
          onPressed: () => Get.back(),
        ),
      ),
      extendBodyBehindAppBar: true,
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
              // Glowing backgrounds (Ambient art)
              Positioned(
                top: -60,
                left: -20,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColors.accentAlphaLow,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: const Duration(seconds: 4), curve: Curves.easeInOut),

              Positioned(
                bottom: 100,
                right: -60,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColors.accent2AlphaLow,
                  ),
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
               .scale(begin: const Offset(1.1, 1.1), end: const Offset(0.9, 0.9), duration: const Duration(seconds: 5), curve: Curves.easeInOut),

              // Scrollable body
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Interactive User Profile Card (Tapping picks image from gallery)
                    _buildAvatarCard(context, controller, isDark),
                    const SizedBox(height: 24),

                    // Display Name Form Card
                    _buildNameCard(context, controller, isDark),
                    const SizedBox(height: 24),

                    // Premium Upload Quote Card (No icon, sleek style)
                    _buildUploadQuoteCard(context, controller, isDark),
                    const SizedBox(height: 24),

                    // My Quotes List Section
                    _buildUserQuotesSection(context, controller, isDark),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarCard(BuildContext context, ProfileController controller, bool isDark) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
          decoration: BoxDecoration(
            color: themeColors.cardBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: themeColors.cardBorder!,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // Profile Photo Container
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: themeColors.accent1!,
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeColors.accent1!.withValues(alpha: 0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: ClipOval(
                  child: Obx(() {
                    final url = controller.profilePictureUrl.value;
                    return url.isNotEmpty
                        ? (url.startsWith('http')
                            ? Image.network(
                                url,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    size: 50,
                                    color: isDark ? AppColors.darkSubtext : AppColors.lightSubtext,
                                  ),
                                ),
                              )
                            : Image.memory(
                                base64Decode(url),
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => Container(
                                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                                  child: Icon(
                                    Icons.person_outline_rounded,
                                    size: 50,
                                    color: isDark ? AppColors.darkSubtext : AppColors.lightSubtext,
                                  ),
                                ),
                              ))
                        : Container(
                            color: (isDark ? AppColors.darkAccent : AppColors.lightAccent).withValues(alpha: 0.15),
                            child: Center(
                              child: Text(
                                controller.currentUser?.displayName?.isNotEmpty == true
                                    ? controller.currentUser!.displayName![0].toUpperCase()
                                    : 'U',
                                style: GoogleFonts.outfit(
                                  color: isDark ? AppColors.darkAccent2 : AppColors.lightAccent2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 48,
                                ),
                              ),
                            ),
                          );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // User details display
              Obx(() => Text(
                    controller.currentUser?.displayName ?? 'InspireMe User',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 0.2),
                  )),
              const SizedBox(height: 6),
              Text(
                controller.currentUser?.email ?? 'No email associated',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                  letterSpacing: 0.1,
                ),
              ),
              const SizedBox(height: 24),

              // Action buttons (Logout - clean text button with no icons)
              ScaleButton(
                onTap: () => _showLogoutConfirmDialog(context, controller),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 11),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                    color: Colors.redAccent.withValues(alpha: 0.05),
                  ),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.poppins(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.97, 0.97), end: const Offset(1.0, 1.0), curve: Curves.easeOutCubic).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildNameCard(BuildContext context, ProfileController controller, bool isDark) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: themeColors.cardBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: themeColors.cardBorder!,
              width: 1.5,
            ),
          ),
          child: Form(
            key: controller.profileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Account Settings',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 16),

                // Name field
                TextFormField(
                  controller: controller.nameController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    prefixIcon: Icon(
                      Icons.person_outline_rounded,
                      color: themeColors.text?.withValues(alpha: 0.5),
                    ),
                    filled: true,
                    fillColor: themeColors.glassTextFill,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: themeColors.glassTextBorder!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: themeColors.speakIconActiveColor!,
                        width: 1.8,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Display name cannot be empty';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Save button
                Obx(() => ScaleButton(
                      onTap: controller.isSavingProfile.value ? null : () => controller.updateProfile(),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: themeColors.accentGradient!,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeColors.accent1!
                                  .withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: controller.isSavingProfile.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Save Changes',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 80.ms, duration: 500.ms).scale(begin: const Offset(0.97, 0.97), end: const Offset(1.0, 1.0), curve: Curves.easeOutCubic).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildUploadQuoteCard(BuildContext context, ProfileController controller, bool isDark) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: themeColors.cardBg,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: themeColors.cardBorder!,
              width: 1.5,
            ),
          ),
          child: Form(
            key: controller.quoteFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Share a Motivation',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                const SizedBox(height: 6),
                Text(
                  'Your quote will be added to the Firestore pool for other users to discover. To make things interesting, it will be excluded from your own stream.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.55),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 20),

                // Quote field
                TextFormField(
                  controller: controller.quoteTextController,
                  maxLines: 3,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Enter your motivational quote here...',
                    filled: true,
                    fillColor: themeColors.glassTextFill,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: themeColors.glassTextBorder!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: themeColors.speakIconActiveColor!,
                        width: 1.8,
                      ),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Quote text is required';
                    if (val.trim().length < 10) return 'Quote must be at least 10 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Author field
                TextFormField(
                  controller: controller.quoteAuthorController,
                  style: theme.textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Author (e.g. Albert Einstein) - optional',
                    filled: true,
                    fillColor: themeColors.glassTextFill,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: themeColors.glassTextBorder!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: themeColors.speakIconActiveColor!,
                        width: 1.8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sleek upload button (No icon, centered, highly polished, ScaleButton)
                Obx(() => ScaleButton(
                      onTap: controller.isSubmittingQuote.value ? null : () => controller.uploadCustomQuote(),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: themeColors.accentGradient!,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: themeColors.accent1!
                                  .withValues(alpha: 0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
                          child: controller.isSubmittingQuote.value
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Upload and Share Quote',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 160.ms, duration: 500.ms).scale(begin: const Offset(0.97, 0.97), end: const Offset(1.0, 1.0), curve: Curves.easeOutCubic).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildUserQuotesSection(BuildContext context, ProfileController controller, bool isDark) {
    final theme = Theme.of(context);
    final themeColors = theme.extension<AppThemeColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Obx(() => Text(
                'My Uploaded Quotes (${controller.userQuotes.length})',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
              )),
        ),
        Obx(() {
          if (controller.isLoadingQuotes.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (controller.userQuotes.isEmpty) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
                decoration: BoxDecoration(
                  color: themeColors.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: themeColors.cardBorder!,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.comment_bank_outlined,
                      size: 44,
                      color: theme.iconTheme.color?.withValues(alpha: 0.35),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'You haven\'t uploaded any quotes yet.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Lists items with staggered animations
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.userQuotes.length,
            separatorBuilder: (c, i) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final quote = controller.userQuotes[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: themeColors.cardBg,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: themeColors.cardBorder!,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"${quote.text}"',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '— ${quote.author}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
                        onPressed: () => _showDeleteConfirmDialog(context, controller, quote.id),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 60).ms, duration: 400.ms).slideX(begin: 0.08, end: 0, curve: Curves.easeOutQuart);
            },
          );
        }),
      ],
    ).animate().fadeIn(delay: 240.ms, duration: 500.ms).scale(begin: const Offset(0.97, 0.97), end: const Offset(1.0, 1.0), curve: Curves.easeOutCubic).slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  void _showDeleteConfirmDialog(BuildContext context, ProfileController controller, String quoteId) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: isDark ? Colors.grey[900]?.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Delete Quote?', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to permanently delete this quote? Other users will no longer see it.'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                controller.deleteUserQuote(quoteId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context, ProfileController controller) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Get.dialog(
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AlertDialog(
          backgroundColor: isDark ? Colors.grey[900]?.withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.9),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text('Log Out', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
          content: const Text('Are you sure you want to log out of your account?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel', style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                controller.logout();
              },
              child: const Text('Log Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable scale transition on button taps for a premium, tactile UI response
class ScaleButton extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;
  final Duration duration;
  final double scaleFactor;

  const ScaleButton({
    super.key,
    required this.onTap,
    required this.child,
    this.duration = const Duration(milliseconds: 100),
    this.scaleFactor = 0.95,
  });

  @override
  State<ScaleButton> createState() => _ScaleButtonState();
}

class _ScaleButtonState extends State<ScaleButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = widget.onTap != null;
    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed && isEnabled ? widget.scaleFactor : 1.0,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
