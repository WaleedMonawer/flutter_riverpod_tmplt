import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_tmplt/features/settings/presentation/controllers/settings_state.dart';

import 'package:flutter_riverpod_tmplt/core/providers/local_providers.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/theme_controller.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/app_theme.dart';
import 'package:flutter_riverpod_tmplt/core/common/utils/logger.dart';
import 'package:flutter_riverpod_tmplt/core/domain/entities/result.dart';
import '../../../posts/presentation/controllers/posts_controller.dart';

final settingsControllerProvider = StateNotifierProvider<SettingsController, AsyncValue<SettingsState>>(
  (ref) => SettingsController(ref),
);

class SettingsController extends StateNotifier<AsyncValue<SettingsState>> {
  final Ref ref;

  SettingsController(this.ref) : super(const AsyncLoading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      state = const AsyncLoading();
      
      final persistence = ref.read(statePersistenceServiceProvider);
      
      // Load theme
      final savedTheme = await persistence.loadState('theme', (json) {
        final value = json['value'] as String;
        return AppThemeType.values.firstWhere(
          (e) => e.toString() == value,
          orElse: () => AppThemeType.light,
        );
      });

      // Load language
      final savedLocale = await persistence.loadState('locale', (json) {
        final languageCode = json['languageCode'] as String;
        final countryCode = json['countryCode'] as String?;
        return {'languageCode': languageCode, 'countryCode': countryCode};
      });

      final settingsState = SettingsState(
        currentTheme: savedTheme ?? AppThemeType.light,
        currentLanguage: savedLocale?['languageCode'] ?? 'en',
      );

      state = AsyncData(settingsState);
      Logger.info('Settings loaded successfully');
    } catch (e) {
      Logger.error('Error loading settings', e);
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<Result<void>> updateTheme(AppThemeType themeType) async {
    try {
      state = state.whenData((settings) => settings.copyWith(isLoading: true));
      
      final persistence = ref.read(statePersistenceServiceProvider);
      await persistence.saveState('theme', themeType);
      
      // Update theme controller
      ref.read(themeControllerProvider.notifier).setTheme(themeType);
      
      state = state.whenData((settings) => settings.copyWith(
        currentTheme: themeType,
        isLoading: false,
      ));
      
      Logger.info('Theme updated to: $themeType');
      return Result.success(null);
    } catch (e) {
      Logger.error('Error updating theme', e);
      state = state.whenData((settings) => settings.copyWith(
        isLoading: false,
        error: 'Failed to update theme: $e',
      ));
      return Result.failure('Failed to update theme: $e');
    }
  }

  Future<Result<void>> updateLanguage(String languageCode) async {
    try {
      state = state.whenData((settings) => settings.copyWith(isLoading: true));
      
      final persistence = ref.read(statePersistenceServiceProvider);
      final newLocale = Locale(languageCode, '');
      
      await persistence.saveState('locale', {
        'languageCode': newLocale.languageCode,
        'countryCode': newLocale.countryCode,
      });
      
      // Update locale controller
      ref.read(localeProvider.notifier).setLocale(newLocale);
      
      state = state.whenData((settings) => settings.copyWith(
        currentLanguage: languageCode,
        isLoading: false,
      ));
      
      Logger.info('Language updated to: $languageCode');
      return Result.success(null);
    } catch (e) {
      Logger.error('Error updating language', e);
      state = state.whenData((settings) => settings.copyWith(
        isLoading: false,
        error: 'Failed to update language: $e',
      ));
      return Result.failure('Failed to update language: $e');
    }
  }

  Future<Result<void>> clearAllData() async {
    try {
      state = state.whenData((settings) => settings.copyWith(isLoading: true));
      
      final persistence = ref.read(statePersistenceServiceProvider);
      await persistence.clearAllStates();
      
      // Reset to defaults
      await updateTheme(AppThemeType.light);
      await updateLanguage('en');
      
      // Refresh posts
      ref.read(postsControllerProvider.notifier).refreshPosts();
      
      Logger.info('All data cleared successfully');
      return Result.success(null);
    } catch (e) {
      Logger.error('Error clearing data', e);
      state = state.whenData((settings) => settings.copyWith(
        isLoading: false,
        error: 'Failed to clear data: $e',
      ));
      return Result.failure('Failed to clear data: $e');
    }
  }

  Future<Result<Map<String, dynamic>>> getDataUsage() async {
    try {
      final persistence = ref.read(statePersistenceServiceProvider);
      final keys = await persistence.getAllKeys();
      
      final dataUsage = <String, dynamic>{};
      for (final key in keys) {
        final hasData = await persistence.hasState(key);
        dataUsage[key] = hasData;
      }
      
      Logger.info('Data usage retrieved: $dataUsage');
      return Result.success(dataUsage);
    } catch (e) {
      Logger.error('Error getting data usage', e);
      return Result.failure('Failed to get data usage: $e');
    }
  }

  void clearError() {
    state = state.whenData((settings) => settings.copyWith(error: null));
  }

  void refresh() {
    _loadSettings();
  }
} 