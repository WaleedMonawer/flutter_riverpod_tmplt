import 'package:flutter/foundation.dart';
import '../../logger.dart';

abstract class AnalyticsService {
  Future<void> initialize();
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters});
  Future<void> setUserProperty(String name, String value);
  Future<void> setUserId(String userId);
  Future<void> logScreenView(String screenName, {String? screenClass});
  Future<void> logError(String error, {StackTrace? stackTrace});
  Future<void> logPurchase({
    required String currency,
    required double value,
    required String itemId,
    String? itemName,
  });
}

class FirebaseAnalyticsService implements AnalyticsService {
  @override
  Future<void> initialize() async {
    if (kDebugMode) {
      Logger.info('🔥 Firebase Analytics initialized');
    }
  }

  @override
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    if (kDebugMode) {
      Logger.info('📊 Analytics Event: $eventName');
      if (parameters != null) {
        Logger.info('   Parameters: $parameters');
      }
    }
    // TODO: Implement Firebase Analytics
    // await FirebaseAnalytics.instance.logEvent(
    //   name: eventName,
    //   parameters: parameters,
    // );
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    if (kDebugMode) {
      Logger.info('👤 User Property: $name = $value');
    }
    // TODO: Implement Firebase Analytics
    // await FirebaseAnalytics.instance.setUserProperty(name: name, value: value);
  }

  @override
  Future<void> setUserId(String userId) async {
    if (kDebugMode) {
      Logger.info('🆔 User ID: $userId');
    }
    // TODO: Implement Firebase Analytics
    // await FirebaseAnalytics.instance.setUserId(id: userId);
  }

  @override
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    if (kDebugMode) {
      Logger.info('📱 Screen View: $screenName');
      if (screenClass != null) {
        Logger.info('   Class: $screenClass');
      }
    }
    // TODO: Implement Firebase Analytics
    // await FirebaseAnalytics.instance.logScreenView(
    //   screenName: screenName,
    //   screenClass: screenClass,
    // );
  }

  @override
  Future<void> logError(String error, {StackTrace? stackTrace}) async {
    if (kDebugMode) {
      Logger.error('❌ Analytics Error: $error');
      if (stackTrace != null) {
        Logger.error('   Stack Trace: $stackTrace');
      }
    }
    // TODO: Implement Firebase Analytics
    // await FirebaseAnalytics.instance.logEvent(
    //   name: 'app_error',
    //   parameters: {
    //     'error_message': error,
    //     'stack_trace': stackTrace?.toString(),
    //   },
    // );
  }

  @override
  Future<void> logPurchase({
    required String currency,
    required double value,
    required String itemId,
    String? itemName,
  }) async {
    if (kDebugMode) {
      Logger.info('💰 Purchase: $itemId - $value $currency');
      if (itemName != null) {
        Logger.info('   Item: $itemName');
      }
    }
    // TODO: Implement Firebase Analytics
    // await FirebaseAnalytics.instance.logPurchase(
    //   currency: currency,
    //   value: value,
    //   items: [
    //     AnalyticsEventItem(
    //       itemId: itemId,
    //       itemName: itemName,
    //     ),
    //   ],
    // );
  }
}

class MockAnalyticsService implements AnalyticsService {
  @override
  Future<void> initialize() async {
    Logger.info('🎭 Mock Analytics initialized');
  }

  @override
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    Logger.info('📊 Mock Analytics Event: $eventName');
    if (parameters != null) {
      Logger.info('   Parameters: $parameters');
    }
  }

  @override
  Future<void> setUserProperty(String name, String value) async {
    Logger.info('👤 Mock User Property: $name = $value');
  }

  @override
  Future<void> setUserId(String userId) async {
    Logger.info('🆔 Mock User ID: $userId');
  }

  @override
  Future<void> logScreenView(String screenName, {String? screenClass}) async {
    Logger.info('📱 Mock Screen View: $screenName');
    if (screenClass != null) {
      Logger.info('   Class: $screenClass');
    }
  }

  @override
  Future<void> logError(String error, {StackTrace? stackTrace}) async {
    Logger.error('❌ Mock Analytics Error: $error');
    if (stackTrace != null) {
      Logger.error('   Stack Trace: $stackTrace');
    }
  }

  @override
  Future<void> logPurchase({
    required String currency,
    required double value,
    required String itemId,
    String? itemName,
  }) async {
    Logger.info('💰 Mock Purchase: $itemId - $value $currency');
    if (itemName != null) {
      Logger.info('   Item: $itemName');
    }
  }
} 