import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'app_theme.dart';

class AdaptiveTheme {
  static ThemeData getMaterialTheme(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.light:
        return ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        );
      case AppThemeType.dark:
        return ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1F1F1F),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: CardTheme(
            elevation: 2,
            color: const Color(0xFF1F1F1F),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        );
      case AppThemeType.system:
        return ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
        );
    }
  }

  static CupertinoThemeData getCupertinoTheme(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.light:
        return const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemBlue,
          scaffoldBackgroundColor: CupertinoColors.systemBackground,
        );
      case AppThemeType.dark:
        return const CupertinoThemeData(
          brightness: Brightness.dark,
          primaryColor: CupertinoColors.systemBlue,
          scaffoldBackgroundColor: CupertinoColors.systemBackground,
        );
      case AppThemeType.system:
        return const CupertinoThemeData(
          brightness: Brightness.light,
          primaryColor: CupertinoColors.systemBlue,
        );
    }
  }

  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isWeb => kIsWeb;
  static bool get isDesktop => defaultTargetPlatform == TargetPlatform.macOS || 
                              defaultTargetPlatform == TargetPlatform.windows || 
                              defaultTargetPlatform == TargetPlatform.linux;
} 