import 'package:flutter_riverpod_tmplt/core/presentation/theme/app_theme.dart';

class SettingsState {
  final AppThemeType currentTheme;
  final String currentLanguage;
  final bool isLoading;
  final String? error;

  const SettingsState({
    required this.currentTheme,
    required this.currentLanguage,
    this.isLoading = false,
    this.error,
  });

  SettingsState copyWith({
    AppThemeType? currentTheme,
    String? currentLanguage,
    bool? isLoading,
    String? error,
  }) {
    return SettingsState(
      currentTheme: currentTheme ?? this.currentTheme,
      currentLanguage: currentLanguage ?? this.currentLanguage,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
