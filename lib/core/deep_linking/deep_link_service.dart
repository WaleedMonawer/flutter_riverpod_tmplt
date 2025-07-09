import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import '../logger.dart';

abstract class DeepLinkService {
  Future<void> initialize();
  Future<void> handleDeepLink(String link);
  Future<void> handleInitialLink();
  void navigateTo(String route, {Map<String, String>? parameters});
  void navigateToPost(int postId);
  void navigateToUser(int userId);
  void navigateToSettings();
}

class GoRouterDeepLinkService implements DeepLinkService {
  final GoRouter router;

  GoRouterDeepLinkService(this.router);

  @override
  Future<void> initialize() async {
    if (kDebugMode) {
      Logger.info('🔗 Deep Link Service initialized');
    }
    
    // Handle initial link if app was opened from deep link
    await handleInitialLink();
  }

  @override
  Future<void> handleDeepLink(String link) async {
    if (kDebugMode) {
      Logger.info('🔗 Handling deep link: $link');
    }

    try {
      final uri = Uri.parse(link);
      
      switch (uri.host) {
        case 'post':
          final postId = uri.queryParameters['id'];
          if (postId != null) {
            navigateToPost(int.parse(postId));
          }
          break;
        case 'user':
          final userId = uri.queryParameters['id'];
          if (userId != null) {
            navigateToUser(int.parse(userId));
          }
          break;
        case 'settings':
          navigateToSettings();
          break;
        default:
          if (kDebugMode) {
            Logger.warning('🔗 Unknown deep link host: ${uri.host}');
          }
      }
    } catch (e) {
      if (kDebugMode) {
        Logger.error('🔗 Error handling deep link: $e');
      }
    }
  }

  @override
  Future<void> handleInitialLink() async {
    if (kDebugMode) {
      Logger.info('🔗 Handling initial link');
    }
    // TODO: Implement initial link handling
    // This would typically check if the app was opened from a deep link
  }

  @override
  void navigateTo(String route, {Map<String, String>? parameters}) {
    if (kDebugMode) {
      Logger.info('🔗 Navigating to: $route');
      if (parameters != null) {
        Logger.info('   Parameters: $parameters');
      }
    }
    
    try {
      if (parameters != null) {
        final queryParams = parameters.map((key, value) => MapEntry(key, value));
        router.go(route, extra: queryParams);
      } else {
        router.go(route);
      }
    } catch (e) {
      if (kDebugMode) {
        Logger.error('🔗 Navigation error: $e');
      }
    }
  }

  @override
  void navigateToPost(int postId) {
    if (kDebugMode) {
      Logger.info('🔗 Navigating to post: $postId');
    }
    router.go('/post/$postId');
  }

  @override
  void navigateToUser(int userId) {
    if (kDebugMode) {
      Logger.info('🔗 Navigating to user: $userId');
    }
    router.go('/user/$userId');
  }

  @override
  void navigateToSettings() {
    if (kDebugMode) {
      Logger.info('🔗 Navigating to settings');
    }
    router.go('/settings');
  }
}

class MockDeepLinkService implements DeepLinkService {
  @override
  Future<void> initialize() async {
    Logger.info('🎭 Mock Deep Link Service initialized');
  }

  @override
  Future<void> handleDeepLink(String link) async {
    Logger.info('🔗 Mock: Handling deep link: $link');
  }

  @override
  Future<void> handleInitialLink() async {
    Logger.info('🔗 Mock: Handling initial link');
  }

  @override
  void navigateTo(String route, {Map<String, String>? parameters}) {
    Logger.info('🔗 Mock: Navigating to: $route');
    if (parameters != null) {
      Logger.info('   Parameters: $parameters');
    }
  }

  @override
  void navigateToPost(int postId) {
    Logger.info('🔗 Mock: Navigating to post: $postId');
  }

  @override
  void navigateToUser(int userId) {
    Logger.info('🔗 Mock: Navigating to user: $userId');
  }

  @override
  void navigateToSettings() {
    Logger.info('🔗 Mock: Navigating to settings');
  }
} 