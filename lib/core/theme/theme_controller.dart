import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_theme.dart';
import '../providers.dart';

final themeControllerProvider = StateNotifierProvider<ThemeController, AppThemeType>(
  (ref) => ThemeController(ref),
);

final themeDataProvider = Provider<ThemeData>((ref) {
  final themeType = ref.watch(themeControllerProvider);
  return _getThemeData(themeType);
});

class ThemeController extends StateNotifier<AppThemeType> {
  final Ref ref;
  
  ThemeController(this.ref) : super(AppThemeType.light) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    try {
      final persistence = ref.read(statePersistenceServiceProvider);
      final savedTheme = await persistence.loadState('theme', (json) {
        final value = json['value'] as String;
        return AppThemeType.values.firstWhere(
          (e) => e.toString() == value,
          orElse: () => AppThemeType.light,
        );
      });
      
      if (savedTheme != null) {
        state = savedTheme;
      }
    } catch (e) {
      // Keep default theme if loading fails
    }
  }

  Future<void> _saveTheme(AppThemeType themeType) async {
    try {
      final persistence = ref.read(statePersistenceServiceProvider);
      await persistence.saveState('theme', themeType);
    } catch (e) {
      // Ignore save errors
    }
  }

  void setTheme(AppThemeType themeType) {
    state = themeType;
    _saveTheme(themeType);
  }

  void toggleTheme() {
    final newTheme = state == AppThemeType.light ? AppThemeType.dark : AppThemeType.light;
    setTheme(newTheme);
  }
}

ThemeData _getThemeData(AppThemeType themeType) {
  switch (themeType) {
    case AppThemeType.light:
      return AppThemeData.lightTheme;
    case AppThemeType.dark:
      return AppThemeData.darkTheme;
    case AppThemeType.system:
      // For now, default to light theme
      return AppThemeData.lightTheme;
  }
} 