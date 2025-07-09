import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'storage/local_storage.dart';
import 'analytics/analytics_service.dart';
import 'notifications/notification_service.dart';
import 'deep_linking/deep_link_service.dart';
import 'persistence/state_persistence_service.dart';
import '../features/settings/presentation/controllers/settings_controller.dart';

// Global providers that can be overridden in main.dart
final localStorageProvider = Provider<LocalStorage>((ref) {
  // This will be overridden in main.dart with the actual implementation
  throw UnimplementedError('LocalStorage should be initialized with SharedPreferencesStorage.getInstance()');
});

// Language Provider with persistence
final localeProvider = StateNotifierProvider<LocaleController, Locale>((ref) {
  return LocaleController(ref);
});

class LocaleController extends StateNotifier<Locale> {
  final Ref ref;
  
  LocaleController(this.ref) : super(const Locale('en', '')) {
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    try {
      final persistence = ref.read(statePersistenceServiceProvider);
      final savedLocale = await persistence.loadState('locale', (json) {
        final languageCode = json['languageCode'] as String;
        final countryCode = json['countryCode'] as String?;
        return Locale(languageCode, countryCode);
      });
      
      if (savedLocale != null) {
        state = savedLocale;
      }
    } catch (e) {
      // Keep default locale if loading fails
    }
  }

  Future<void> _saveLocale(Locale locale) async {
    try {
      final persistence = ref.read(statePersistenceServiceProvider);
      await persistence.saveState('locale', {
        'languageCode': locale.languageCode,
        'countryCode': locale.countryCode,
      });
    } catch (e) {
      // Ignore save errors
    }
  }

  void setLocale(Locale locale) {
    state = locale;
    _saveLocale(locale);
  }

  void toggleLocale() {
    final newLocale = state.languageCode == 'en' 
        ? const Locale('ar', '') 
        : const Locale('en', '');
    setLocale(newLocale);
  }
}

// Analytics Service Provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  // Use MockAnalyticsService for now, can be overridden with FirebaseAnalyticsService
  return MockAnalyticsService();
});

// Notification Service Provider
final notificationServiceProvider = Provider<NotificationService>((ref) {
  // Use MockNotificationService for now, can be overridden with FirebaseNotificationService
  return MockNotificationService();
});

// Deep Link Service Provider
final deepLinkServiceProvider = Provider<DeepLinkService>((ref) {
  // Use MockDeepLinkService for now, can be overridden with GoRouterDeepLinkService
  return MockDeepLinkService();
});

// State Persistence Service Provider
final statePersistenceServiceProvider = Provider<StatePersistenceService>((ref) {
  final localStorage = ref.read(localStorageProvider);
  return LocalStatePersistenceService(localStorage);
});

