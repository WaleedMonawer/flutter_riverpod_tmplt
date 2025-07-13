import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod_tmplt/core/common/utils/logger.dart';

abstract class NotificationService {
  Future<void> initialize();
  Future<void> requestPermission();
  Future<String?> getToken();
  Future<void> subscribeToTopic(String topic);
  Future<void> unsubscribeFromTopic(String topic);
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  });
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotifications();
  Future<void> onMessageReceived(Map<String, dynamic> message);
  Future<void> onNotificationTapped(String? payload);
}

class FirebaseNotificationService implements NotificationService {
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  String? _fcmToken;

  @override
  Future<void> initialize() async {
    if (kDebugMode) {
      Logger.info('🔔 Firebase Notification Service initialized');
    }

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        onNotificationTapped(details.payload);
      },
    );

    // TODO: Initialize Firebase Cloud Messaging
    // await Firebase.initializeApp();
    // await _initializeFCM();
  }

  // Future<void> _initializeFCM() async {
  //   final messaging = FirebaseMessaging.instance;
  //   
  //   // Request permission
  //   final settings = await messaging.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );
  //   
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     Logger.info('📱 Notification permission granted');
  //   }
  //   
  //   // Get FCM token
  //   _fcmToken = await messaging.getToken();
  //   Logger.info('🔑 FCM Token: $_fcmToken');
  //   
  //   // Handle foreground messages
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     Logger.info('📨 Foreground message received');
  //     onMessageReceived(message.data);
  //   });
  //   
  //   // Handle background messages
  //   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  //   
  //   // Handle notification taps
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     Logger.info('👆 Notification tapped');
  //     onNotificationTapped(message.data.toString());
  //   });
  // }

  @override
  Future<void> requestPermission() async {
    if (kDebugMode) {
      Logger.info('🔔 Requesting notification permission');
    }
    // TODO: Implement permission request
  }

  @override
  Future<String?> getToken() async {
    if (kDebugMode) {
      Logger.info('🔑 Getting FCM token: $_fcmToken');
    }
    return _fcmToken;
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    if (kDebugMode) {
      Logger.info('📡 Subscribing to topic: $topic');
    }
    // TODO: Implement topic subscription
    // await FirebaseMessaging.instance.subscribeToTopic(topic);
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    if (kDebugMode) {
      Logger.info('📡 Unsubscribing from topic: $topic');
    }
    // TODO: Implement topic unsubscription
    // await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
  }

  @override
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      channelDescription: 'Default notification channel',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id ?? DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
      payload: payload,
    );

    if (kDebugMode) {
      Logger.info('📱 Local notification shown: $title - $body');
    }
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
    if (kDebugMode) {
      Logger.info('❌ Notification cancelled: $id');
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
    if (kDebugMode) {
      Logger.info('❌ All notifications cancelled');
    }
  }

  @override
  Future<void> onMessageReceived(Map<String, dynamic> message) async {
    if (kDebugMode) {
      Logger.info('📨 Message received: $message');
    }

    // Show local notification
    final title = message['title'] ?? 'New Message';
    final body = message['body'] ?? 'You have a new message';
    
    await showLocalNotification(
      title: title,
      body: body,
      payload: message.toString(),
    );
  }

  @override
  Future<void> onNotificationTapped(String? payload) async {
    if (kDebugMode) {
      Logger.info('👆 Notification tapped with payload: $payload');
    }
    // TODO: Handle navigation based on payload
  }
}

// Background message handler
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   Logger.info('📨 Background message received: ${message.messageId}');
// }

class MockNotificationService implements NotificationService {
  @override
  Future<void> initialize() async {
    Logger.info('🎭 Mock Notification Service initialized');
  }

  @override
  Future<void> requestPermission() async {
    Logger.info('🔔 Mock: Requesting notification permission');
  }

  @override
  Future<String?> getToken() async {
    Logger.info('🔑 Mock: Getting FCM token');
    return 'mock_fcm_token_123';
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    Logger.info('📡 Mock: Subscribing to topic: $topic');
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    Logger.info('📡 Mock: Unsubscribing from topic: $topic');
  }

  @override
  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    int? id,
  }) async {
    Logger.info('📱 Mock: Local notification shown: $title - $body');
  }

  @override
  Future<void> cancelNotification(int id) async {
    Logger.info('❌ Mock: Notification cancelled: $id');
  }

  @override
  Future<void> cancelAllNotifications() async {
    Logger.info('❌ Mock: All notifications cancelled');
  }

  @override
  Future<void> onMessageReceived(Map<String, dynamic> message) async {
    Logger.info('📨 Mock: Message received: $message');
  }

  @override
  Future<void> onNotificationTapped(String? payload) async {
    Logger.info('👆 Mock: Notification tapped with payload: $payload');
  }
} 