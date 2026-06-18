import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/theme/app_theme.dart';
import '../config/theme/theme_controller.dart';
import 'routes.dart';
import 'bindings.dart';

class InspireMeApp extends StatelessWidget {
  const InspireMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize theme controller
    final themeController = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
          title: 'InspireMe',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode:
              themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          initialBinding: AppBindings(),
          getPages: AppRoutes.routes,
          initialRoute: AppRoutes.splash,
          defaultTransition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 400),
          builder: (context, child) {
            return AnimatedTheme(
              data: themeController.isDarkMode.value
                  ? AppTheme.darkTheme
                  : AppTheme.lightTheme,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              child: child!,
            );
          },
        ));
  }
}
