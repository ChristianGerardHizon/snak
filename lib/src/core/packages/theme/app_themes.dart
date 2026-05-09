import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

/// App theme definitions for light and dark modes.
///
/// Uses Material 3 with seed-based color schemes.
class AppThemes {
  AppThemes._();

  /// Light theme ID.
  static const String lightId = 'light_theme';

  /// Dark theme ID.
  static const String darkId = 'dark_theme';

  /// Default seed color for the app.
  static const Color seedColor = Colors.blue;

  /// App-wide font family.
  static const String fontFamily = 'AlmondMocca';

  /// Brand sky color matching the static background image.
  static const Color brandSky = Color(0xFFBDD5ED);

  /// Light theme definition.
  static AppTheme light() => AppTheme(
        id: lightId,
        description: 'Light Theme',
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: fontFamily,
          scaffoldBackgroundColor: Colors.black,
        ),
      );

  /// Dark theme definition.
  static AppTheme dark() => AppTheme(
        id: darkId,
        description: 'Dark Theme',
        data: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
          fontFamily: fontFamily,
          scaffoldBackgroundColor: Colors.black,
        ),
      );

  /// All available themes.
  static List<AppTheme> get all => [light(), dark()];
}
