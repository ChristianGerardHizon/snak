import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:theme_provider/theme_provider.dart';

import 'core/i18n/strings.g.dart';
import 'core/packages/pocketbase/pocketbase_provider.dart';
import 'core/packages/theme/app_themes.dart';
import 'core/pages/app_initialization_page.dart';
import 'core/routing/router.dart';
import 'core/widgets/window_size_listener.dart';
import 'core/packages/theme/theme_controller.dart';

/// Main application widget.
///
/// Sets up MaterialApp with GoRouter navigation and localization.
class Application extends HookConsumerWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeModeAsync = ref.watch(themeControllerProvider);
    final themeController = ref.read(themeControllerProvider.notifier);
    final isInitializing = themeModeAsync.isLoading;

    final continueAfterLanding = useState(false);
    final showHealthConsent = useState(false);
    final showProfileSetup = useState(false);

    final showSplash = isInitializing || !continueAfterLanding.value;

    return ThemeProvider(
      themes: AppThemes.all,
      saveThemesOnChange: false,
      loadThemeOnInit: false,
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) {
            // Determine system brightness for system mode
            final systemBrightness =
                MediaQuery.platformBrightnessOf(themeContext);

            // Get effective theme based on mode
            final effectiveThemeId = themeModeAsync.whenOrNull(
                  data: (_) =>
                      themeController.getEffectiveThemeId(systemBrightness),
                ) ??
                AppThemes.lightId;

            // Apply theme via post-frame callback to avoid build-time mutations
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final controller = ThemeProvider.controllerOf(themeContext);
              if (controller.theme.id != effectiveThemeId) {
                controller.setTheme(effectiveThemeId);
              }
            });

            return WindowSizeListener(
              child: showSplash
                  ? MaterialApp(
                      title: appTitle,
                      debugShowCheckedModeBanner: false,
                      locale: TranslationProvider.of(context).flutterLocale,
                      supportedLocales: AppLocaleUtils.supportedLocales,
                      localizationsDelegates:
                          GlobalMaterialLocalizations.delegates,
                      theme: ThemeProvider.themeOf(themeContext).data,
                      home: AppInitializationPage(
                        canContinue: !isInitializing,
                        showConsent: showHealthConsent.value,
                        showProfileSetup: showProfileSetup.value,
                        onSplashContinue: () {
                          showHealthConsent.value = true;
                        },
                        onConsentContinue: () {
                          showHealthConsent.value = false;
                          showProfileSetup.value = true;
                        },
                        onConsentBack: () {
                          showHealthConsent.value = false;
                        },
                        onProfileComplete: () {
                          continueAfterLanding.value = true;
                        },
                        onProfileBack: () {
                          showProfileSetup.value = false;
                          showHealthConsent.value = true;
                        },
                      ),
                    )
                  : MaterialApp.router(
                      scaffoldMessengerKey: rootScaffoldMessengerKey,
                      title: appTitle,
                      debugShowCheckedModeBanner: false,
                      locale: TranslationProvider.of(context).flutterLocale,
                      supportedLocales: AppLocaleUtils.supportedLocales,
                      localizationsDelegates:
                          GlobalMaterialLocalizations.delegates,
                      theme: ThemeProvider.themeOf(themeContext).data,
                      routerConfig: router,
                    ),
            );
          },
        ),
      ),
    );
  }
}
