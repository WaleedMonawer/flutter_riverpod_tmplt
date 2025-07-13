import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_tmplt/core/firebase/analytics/analytics_service.dart';
import 'package:flutter_riverpod_tmplt/core/firebase/notifications/notification_service.dart';

import 'package:flutter_riverpod_tmplt/core/routing/deep_linking/deep_link_service.dart'; 


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
